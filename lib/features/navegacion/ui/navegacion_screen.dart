import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/providers.dart';
import '../../../core/utils/geo.dart';
import '../../checkpoints/models/checkpoint_info.dart';
import '../../hoja_ruta/models/trip.dart';
import '../data/es_instructions.dart';
import '../models/trip_navigation.dart';
import '../service/route_watcher.dart';
import '../service/turn_by_turn_voice.dart';
import '../state/navegacion_state.dart';

class NavegacionScreen extends ConsumerStatefulWidget {
  const NavegacionScreen({super.key, required this.tripId});
  final String tripId;

  @override
  ConsumerState<NavegacionScreen> createState() => _NavegacionScreenState();
}

class _NavegacionScreenState extends ConsumerState<NavegacionScreen> {
  final _mapCtrl = MapController();
  bool _autofollow = true;
  bool _bootstrapped = false;
  StreamSubscription<MapEvent>? _mapEvents;

  @override
  void initState() {
    super.initState();
    _mapEvents = _mapCtrl.mapEventStream.listen((event) {
      if (event is MapEventMoveStart && event.source == MapEventSource.onDrag) {
        if (_autofollow) setState(() => _autofollow = false);
      }
    });
  }

  @override
  void dispose() {
    _mapEvents?.cancel();
    _mapCtrl.dispose();
    super.dispose();
  }

  void _bootstrapOnce() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    Future.microtask(() {
      ref
          .read(navegacionNotifierProvider(widget.tripId).notifier)
          .loadFor(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    _bootstrapOnce();
    final tripFuture = ref.read(tripsRepoProvider).detalle(widget.tripId);
    return Scaffold(
      body: FutureBuilder<Trip>(
        future: tripFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: Text('${snap.error}')),
            );
          }
          return _Contenido(
            trip: snap.data!,
            mapCtrl: _mapCtrl,
            autofollow: _autofollow,
            onAutofollowChange: (v) => setState(() => _autofollow = v),
          );
        },
      ),
    );
  }
}

class _Contenido extends ConsumerStatefulWidget {
  const _Contenido({
    required this.trip,
    required this.mapCtrl,
    required this.autofollow,
    required this.onAutofollowChange,
  });

  final Trip trip;
  final MapController mapCtrl;
  final bool autofollow;
  final ValueChanged<bool> onAutofollowChange;

  @override
  ConsumerState<_Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends ConsumerState<_Contenido> {
  late final TurnByTurnVoice _voice;
  late final RouteWatcher _watcher;

  @override
  void initState() {
    super.initState();
    _voice = TurnByTurnVoice();
    _watcher = RouteWatcher();
  }

  @override
  void dispose() {
    _voice.dispose();
    _watcher.reset();
    super.dispose();
  }

  /// Llamado cada build cuando hay `pos` + `navigation`. Alimenta a:
  ///   1. `_voice` — anuncia la proxima maniobra al cruzar buckets de
  ///      distancia.
  ///   2. `_watcher` — chequea desvio sostenido y dispara auto-reroute.
  void _onPositionTick({
    required double lat,
    required double lon,
    required NavegacionState nav,
  }) {
    final navigation = nav.navigation;
    if (navigation == null) return;
    final progress = nav.progress;
    final step = nav.currentStep;
    if (step != null &&
        progress?.currentLegIndex != null &&
        progress?.currentStepIndex != null) {
      final dist = progress?.distanceToNextManeuverM ?? step.distanceM;
      unawaited(_voice.onProgress(
        legIndex: progress!.currentLegIndex!,
        stepIndex: progress.currentStepIndex!,
        distanceToManeuver: dist,
        maneuver: step.maneuver,
      ));
    }
    unawaited(_watcher.onPositionUpdate(
      lat: lat,
      lon: lon,
      navigation: navigation,
      onRecompute: (startLat, startLon) async {
        final repo = ref.read(navigationRepoProvider);
        try {
          return await repo.recomputar(
            widget.trip.id,
            startLat: startLat,
            startLon: startLon,
          );
        } catch (_) {
          return null;
        }
      },
      onSay: (frase) {
        unawaited(_voice.speakImmediate(frase));
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger
          ?..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Recalculando ruta...'),
              duration: Duration(seconds: 2),
            ),
          );
      },
      onApply: (nuevo) {
        ref
            .read(navegacionNotifierProvider(widget.trip.id).notifier)
            .aplicarRecompute(nuevo);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final mapCtrl = widget.mapCtrl;
    final autofollow = widget.autofollow;

    final gps = ref.watch(gpsServiceProvider);
    final cpState = ref.watch(checkpointsNotifierProvider(trip.id));
    final nav = ref.watch(navegacionNotifierProvider(trip.id));
    final pos = gps.ultimaPosicion;

    // MC-021: cada cambio de pos + nav → alimentar voz + watcher.
    // En post-frame para no disparar setState durante build.
    if (pos != null && nav.navigation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _onPositionTick(
          lat: pos.latitude,
          lon: pos.longitude,
          nav: nav,
        );
      });
    }

    // Calcular proyeccion del chofer sobre el polyline para el dibujo
    // dinamico (recorrido vs restante) y mover el marcador a la
    // proyeccion en vez de la posicion GPS cruda. Si la distancia GPS
    // → polyline supera 100 m, dejamos el marcador en la posicion
    // real (asi el chofer ve claramente que esta off-route).
    ProjectionOnPolyline? proj;
    final coords = nav.navigation?.geometry.coordinates ?? const [];
    if (pos != null && coords.length >= 2) {
      proj = projectOnPolyline(
        lat: pos.latitude,
        lon: pos.longitude,
        coords: coords,
      );
    }

    // Autofollow: cada cambio de GPS recentrar el mapa.
    if (autofollow && pos != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapCtrl.move(LatLng(pos.latitude, pos.longitude), 17);
      });
    }

    final fallback = primerDestinoFallback(
      trip: trip,
      checkpoints: cpState.checkpoints,
    );

    return Stack(
      children: [
        _Mapa(
          mapCtrl: mapCtrl,
          navigation: nav.navigation,
          choferLat: pos?.latitude,
          choferLon: pos?.longitude,
          heading: pos?.heading,
          checkpoints: cpState.checkpoints,
          fallback: fallback,
          proyeccion: proj,
        ),
        SafeArea(
          child: Column(
            children: [
              _Banner(state: nav, tripId: trip.id),
              const Spacer(),
              if (!autofollow)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      widget.onAutofollowChange(true);
                      if (pos != null) {
                        mapCtrl.move(LatLng(pos.latitude, pos.longitude), 17);
                      }
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text('Centrar en mi ubicacion'),
                  ),
                ),
              _PieResumen(state: nav),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 3,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (GoRouter.of(context).canPop()) context.pop();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Banner extends ConsumerWidget {
  const _Banner({required this.state, required this.tripId});
  final NavegacionState state;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    if (state.loading && state.navigation == null) {
      return _BannerShell(
        fondo: scheme.primaryContainer,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.reintentando
                  ? 'Generando ruta en el servidor...'
                  : 'Cargando navegación...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
            ),
          ),
        ],
      );
    }

    if (state.error != null && state.navigation == null) {
      return _BannerShell(
        fondo: scheme.errorContainer,
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.error!,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            color: scheme.onErrorContainer,
            onPressed: () => ref
                .read(navegacionNotifierProvider(tripId).notifier)
                .recargar(tripId),
          ),
        ],
      );
    }

    if (state.fueraDeRuta) {
      return _BannerShell(
        fondo: Colors.orange.withValues(alpha: 0.18),
        border: Colors.orange.withValues(alpha: 0.6),
        children: [
          const Icon(Icons.wrong_location, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fuera de ruta',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.orange[900],
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'El servidor está recalculando.',
                  style: TextStyle(color: Colors.orange[900]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final step = state.currentStep;
    final maneuver = step?.maneuver;
    final dist = state.progress?.distanceToNextManeuverM ?? step?.distanceM ?? 0;
    final calle = step?.roadName;
    final iconKey = iconoManiobra(maneuver);
    final instruccion = (maneuver?.instructionEs.isNotEmpty ?? false)
        ? maneuver!.instructionEs
        : (maneuver != null
            ? instruccionEsFallback(maneuver: maneuver, calle: calle)
            : 'Seguí');
    final destinoLabel = etiquetaDestinoActual(state);

    return _BannerShell(
      fondo: scheme.primary.withValues(alpha: 0.95),
      children: [
        _IconManiobra(tipo: iconKey, color: scheme.onPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dist > 0 ? 'En ${_fmtM(dist)}' : 'Ahora',
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              Text(
                instruccion,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (destinoLabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  state.progress?.distanceToCurrentTargetM != null
                      ? 'Próximo: $destinoLabel · '
                          '${_fmtM(state.progress!.distanceToCurrentTargetM!)}'
                      : 'Próximo: $destinoLabel',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PieResumen extends StatelessWidget {
  const _PieResumen({required this.state});
  final NavegacionState state;

  @override
  Widget build(BuildContext context) {
    final p = state.progress;
    final nav = state.navigation;
    if (p == null && nav == null) return const SizedBox.shrink();
    final restante = p?.distanceToDestinationM ?? 0;
    final total = p?.routeTotalM ?? nav?.totalDistanceM ?? 0;
    final pctHecho = (p?.progressPct ?? 0).clamp(0, 100);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      restante > 0
                          ? 'Quedan ${_fmtM(restante)}'
                          : 'Cerca del destino',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (total > 0)
                    Text(
                      '${pctHecho.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                ],
              ),
              if (total > 0) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (pctHecho / 100).clamp(0.0, 1.0),
                    minHeight: 4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerShell extends StatelessWidget {
  const _BannerShell({
    required this.children,
    required this.fondo,
    this.border,
  });
  final List<Widget> children;
  final Color fondo;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: fondo,
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: border != null
                ? Border.all(color: border!, width: 1)
                : null,
          ),
          child: Row(children: children),
        ),
      ),
    );
  }
}

class _IconManiobra extends StatelessWidget {
  const _IconManiobra({required this.tipo, required this.color});
  final IconKey tipo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    switch (tipo) {
      case IconKey.turnLeft:
        icon = Icons.turn_left;
        break;
      case IconKey.turnRight:
        icon = Icons.turn_right;
        break;
      case IconKey.turnSlightLeft:
        icon = Icons.turn_slight_left;
        break;
      case IconKey.turnSlightRight:
        icon = Icons.turn_slight_right;
        break;
      case IconKey.turnSharpLeft:
        icon = Icons.turn_sharp_left;
        break;
      case IconKey.turnSharpRight:
        icon = Icons.turn_sharp_right;
        break;
      case IconKey.uTurnLeft:
        icon = Icons.u_turn_left;
        break;
      case IconKey.roundaboutRight:
        icon = Icons.roundabout_right;
        break;
      case IconKey.forkRight:
        icon = Icons.fork_right;
        break;
      case IconKey.merge:
        icon = Icons.merge;
        break;
      case IconKey.flag:
        icon = Icons.flag;
        break;
      case IconKey.arrowUpward:
        icon = Icons.arrow_upward;
        break;
    }
    return Icon(icon, color: color, size: 36);
  }
}

class _Mapa extends StatelessWidget {
  const _Mapa({
    required this.mapCtrl,
    required this.navigation,
    required this.choferLat,
    required this.choferLon,
    required this.heading,
    required this.checkpoints,
    required this.fallback,
    required this.proyeccion,
  });

  final MapController mapCtrl;
  final TripNavigation? navigation;
  final double? choferLat;
  final double? choferLon;
  final double? heading;
  final List<CheckpointInfo> checkpoints;
  final ({double lat, double lon, String etiqueta})? fallback;
  /// Proyeccion del chofer sobre el polyline (MC-021). Si esta
  /// presente y el chofer esta razonablemente cerca de la ruta,
  /// dibujamos el tramo recorrido en verde y el restante en gris,
  /// y ponemos el marcador del camion sobre la proyeccion (snap a
  /// la linea). Si el chofer esta MUY lejos (>100 m) lo dibujamos
  /// en su posicion GPS cruda — asi se ve claro que esta off-route.
  final ProjectionOnPolyline? proyeccion;

  /// Threshold (m) sobre el cual dejamos de "snapear" el marcador al
  /// polyline y mostramos la posicion real. Coincide con el threshold
  /// del banner "fuera de ruta" del backend (server lo dice via
  /// `is_on_route`). El watcher de MC-021 usa 50 m para disparar
  /// recompute — el snap visual usa 100 m para no aparentar que el
  /// chofer esta sobre la ruta cuando va por una colectora paralela.
  static const double _snapMaxM = 100.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final centroInicial = choferLat != null && choferLon != null
        ? LatLng(choferLat!, choferLon!)
        : fallback != null
            ? LatLng(fallback!.lat, fallback!.lon)
            : const LatLng(-34.6037, -58.3816);

    final coords = navigation?.geometry.coordinates ?? const [];
    final points = [
      for (final c in coords)
        if (c.length >= 2) LatLng(c[1], c[0]),
    ];

    final pendientes = checkpoints
        .where((cp) => !cp.reached && cp.lat != null && cp.lon != null)
        .toList();

    // Split del polyline: tramo recorrido (verde) vs restante (gris).
    // Solo si hay proyeccion valida y el chofer esta cerca de la ruta.
    List<LatLng> recorrido = const [];
    List<LatLng> restante = const [];
    final puedeSnap = proyeccion != null &&
        proyeccion!.distM <= _snapMaxM &&
        points.length >= 2;
    if (puedeSnap) {
      final idx = proyeccion!.segmentIndex.clamp(0, points.length - 1);
      final projLatLng = LatLng(proyeccion!.projLat, proyeccion!.projLon);
      // Recorrido: [start, ..., points[idx], proj].
      recorrido = [
        for (var i = 0; i <= idx; i++) points[i],
        projLatLng,
      ];
      // Restante: [proj, points[idx+1], ..., end].
      restante = [
        projLatLng,
        for (var i = idx + 1; i < points.length; i++) points[i],
      ];
    }

    final marcadorChoferLat = puedeSnap
        ? proyeccion!.projLat
        : (choferLat ?? 0);
    final marcadorChoferLon = puedeSnap
        ? proyeccion!.projLon
        : (choferLon ?? 0);

    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        initialCenter: centroInicial,
        initialZoom: 17,
        minZoom: 5,
        maxZoom: 19,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'net.isatech.mobile_isatech',
          maxZoom: 19,
        ),
        // Caso normal: ruta dibujada con tramo recorrido y restante.
        if (puedeSnap && recorrido.length >= 2 && restante.length >= 2)
          PolylineLayer(
            polylines: [
              // Restante primero (queda abajo). Gris claro semi-transp.
              Polyline(
                points: restante,
                strokeWidth: 6,
                color: scheme.outlineVariant.withValues(alpha: 0.85),
                borderStrokeWidth: 1.5,
                borderColor: Colors.white.withValues(alpha: 0.5),
              ),
              // Recorrido encima. Verde brillante.
              Polyline(
                points: recorrido,
                strokeWidth: 6,
                color: Colors.green.shade600.withValues(alpha: 0.9),
                borderStrokeWidth: 1.5,
                borderColor: Colors.white.withValues(alpha: 0.6),
              ),
            ],
          )
        else if (points.length >= 2)
          // Sin proyeccion utilizable (chofer todavia sin GPS, o muy
          // off-route) → polyline unica con el color de antes.
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                strokeWidth: 6,
                color: scheme.primary.withValues(alpha: 0.85),
                borderStrokeWidth: 2,
                borderColor: Colors.white.withValues(alpha: 0.6),
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            // Targets de cada leg (checkpoints + destino).
            if (navigation != null)
              for (final leg in navigation!.legs)
                Marker(
                  point: LatLng(leg.targetLat, leg.targetLon),
                  width: 38,
                  height: 38,
                  alignment: Alignment.topCenter,
                  child: leg.esDestinoFinal
                      ? const Icon(Icons.flag, color: Colors.red, size: 34)
                      : _MarcadorCheckpoint(numero: (leg.targetIndex ?? 0) + 1),
                )
            else
              // Sin nav todavia: mostrar checkpoints crudos.
              for (final cp in pendientes)
                Marker(
                  point: LatLng(cp.lat!, cp.lon!),
                  width: 38,
                  height: 38,
                  alignment: Alignment.topCenter,
                  child: _MarcadorCheckpoint(numero: cp.index + 1),
                ),
            if (choferLat != null && choferLon != null)
              Marker(
                point: LatLng(marcadorChoferLat, marcadorChoferLon),
                width: 40,
                height: 40,
                child: Transform.rotate(
                  angle: (heading ?? 0) * 3.141592653589793 / 180,
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 4),
                      ],
                    ),
                    child: const Icon(
                      Icons.navigation,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _MarcadorCheckpoint extends StatelessWidget {
  const _MarcadorCheckpoint({required this.numero});
  final int numero;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: scheme.tertiary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '$numero',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          width: 2,
          height: 10,
          color: scheme.tertiary,
        ),
      ],
    );
  }
}

String _fmtM(double m) {
  if (m < 1000) return '${m.round()} m';
  return '${(m / 1000).toStringAsFixed(1)} km';
}
