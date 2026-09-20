import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:permission_handler/permission_handler.dart' as ph;

import '../../../core/providers.dart';
import '../../alertas/data/prefijos_alerta.dart';
import '../../alertas/ui/alertas_panel.dart';
import '../../alertas/ui/pending_action_banner.dart';
import '../../checkpoints/ui/recorrido_section.dart';
import '../../hoja_ruta/data/trip_exceptions.dart';
import '../../hoja_ruta/models/road_sheet.dart';
import '../../hoja_ruta/models/trip.dart';
import '../../ingest/service/gps_service.dart';
import '../../shared/ui/proximity_error_helpers.dart';
import 'checklist_section.dart';
import 'trip_pause_banner.dart';
import 'viaje_pendiente_card.dart';

class ViajeActivoScreen extends ConsumerStatefulWidget {
  const ViajeActivoScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<ViajeActivoScreen> createState() => _ViajeActivoScreenState();
}

class _ViajeActivoScreenState extends ConsumerState<ViajeActivoScreen>
    with WidgetsBindingObserver {
  late Future<Trip> _future;
  // Referencia capturada al GpsService. Usarla en dispose() y en el observer
  // de lifecycle en vez de `ref.read(...)`, porque el ref puede quedar
  // invalido si el observer se dispara despues del dispose.
  GpsService? _gpsRef;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _cargar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gpsRef = ref.read(gpsServiceProvider);
  }

  Future<Trip> _cargar() {
    final repo = ref.read(tripsRepoProvider);
    return repo.detalle(widget.tripId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final gps = _gpsRef;
    if (gps == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        gps.setBackground(false);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        gps.setBackground(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // NO detener el GPS al salir de la pantalla. El reporte de ubicacion
    // tiene que seguir mientras el viaje este ACTIVE — incluso si el chofer
    // minimiza la app o navega a otra pantalla. Solo se detiene en logout
    // (401) o cuando el viaje pasa a FINISHED/CANCELLED.
    super.dispose();
  }

  /// Asegurar que el GPS este reportando si el viaje esta ACTIVE. Llamado
  /// desde el build cuando detecta el estado.
  void _watchdogGpsActivo(Trip trip) {
    if (!trip.esActivo) return;
    final gps = ref.read(gpsServiceProvider);
    if (gps.activo) return;
    Future.microtask(() async {
      final permiso = await gps.pedirPermisoUbicacion();
      if (permiso != PermisoUbicacionResult.ok) {
        // Sin permisos no podemos arrancar — el banner rojo de la UI
        // lo informa al chofer.
        return;
      }
      await gps.iniciar(imei: trip.imei, tripId: trip.id);
    });
  }

  Future<void> _toggleTracking(Trip trip) async {
    final gps = ref.read(gpsServiceProvider);
    if (gps.activo) {
      // Durante un viaje ACTIVE no permitimos detener el tracking
      // manualmente — el reporte tiene que ser continuo.
      if (trip.esActivo) return;
      await gps.detener();
    } else {
      await gps.iniciar(imei: trip.imei, tripId: trip.id);
    }
  }

  Future<void> _finalizar(Trip trip) async {
    final repo = ref.read(tripsRepoProvider);
    final gps = ref.read(gpsServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar viaje'),
        content: Text(
          'Confirmas que finalizas el viaje ${trip.id}? '
          'El backend valida que estes en el destino.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      final pos = await gps.ubicacionActual();
      if (pos == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Sin ubicación GPS. Probá de nuevo en unos segundos.'),
          ),
        );
        return;
      }
      // Usamos el Trip que devuelve el response (status=FINISHED,
      // finished_at!=null). NO descartamos el response y dependemos
      // del cache previo — la verdad es la del backend.
      final updatedTrip = await repo.finalizar(
        tripId: trip.id,
        lat: pos.latitude,
        lon: pos.longitude,
      );
      // Pisar el state local con la verdad fresca del backend.
      _future = Future.value(updatedTrip);
      // Detener todo lo que pollea/manda al backend para este trip:
      //  - GPS service (el foreground service tambien queda detenido,
      //    asi como el polling de /messages y /pending-action que
      //    corren dentro de su isolate background).
      //  - El polling foreground de chat / pending-action lo limpian
      //    los Notifiers via ref.onDispose cuando esta pantalla se
      //    desmonta (al pop).
      await gps.detener();
      // Invalidar el state de pending-action para que la siguiente
      // entrada al detalle de un viaje no muestre badges fantasma de
      // alertas que el backend ya auto-ackeo al cerrar el trip.
      ref.invalidate(pendingActionNotifierProvider(trip.id));
      // Idem para el state de pausa: corta los timers y limpia cache.
      ref.invalidate(tripPauseNotifierProvider(trip.id));
      // Avisar a la lista de viajes que tiene que refetchar.
      ref.read(tripsListRefreshProvider.notifier).state++;
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Viaje finalizado')),
      );
      if (context.canPop()) context.pop();
    } on TripFinishProximityException catch (e) {
      // 422: el chofer NO esta en el destino. La UI muestra el detalle
      // estructurado (distancia restante, fuente phone vs device) y
      // ofrece "Reintentar". El viaje sigue ACTIVE — no tocamos state.
      if (!mounted) return;
      final reintentar = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(
            e.detalle.esSinSenalSatelital
                ? Icons.signal_wifi_off
                : e.detalle.esFallaSatelital
                    ? Icons.gps_off
                    : Icons.wrong_location,
            size: 36,
          ),
          title: Text(tituloProximityError(e.detalle)),
          content: Text(mensajeProximityError(e.detalle)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cerrar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
      if (reintentar == true && mounted) {
        await _finalizar(trip);
      }
    } on TripYaCerradoException {
      // 400: el viaje ya estaba cerrado (canceled desde web, o cerrado
      // en otra sesion). NO mostrar error — solo sincronizar y volver
      // al listado. El chofer no necesita saber que su intento de
      // "finalizar" fue redundante; lo importante es que ahora la app
      // refleja el estado real.
      await gps.detener();
      ref.invalidate(pendingActionNotifierProvider(trip.id));
      ref.invalidate(tripPauseNotifierProvider(trip.id));
      ref.read(tripsListRefreshProvider.notifier).state++;
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('El viaje ya estaba cerrado.'),
          duration: Duration(seconds: 3),
        ),
      );
      if (context.canPop()) context.pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si el GpsService detecta 409 desde el endpoint de phone-location
    // (trip ya FINISHED/CANCELLED del lado backend), refrescar la lista
    // de viajes, mostrar un toast informativo, e irnos al listado. El
    // trip ya no esta ACTIVE — quedarnos en su detalle no tiene sentido.
    ref.listen<GpsService>(gpsServiceProvider, (prev, next) {
      if (!next.tripTerminadoRemoto || prev?.tripTerminadoRemoto == true) {
        return;
      }
      next.marcarTerminoRemotoConsumido();
      // Limpiar cache de pending-action para que badges fantasma del
      // listado tampoco aparezcan (el backend ya auto-ackeo todo al
      // cerrar el trip, pero el cache local puede estar stale).
      ref.invalidate(pendingActionNotifierProvider(widget.tripId));
      // Idem para el state de pausa — sin esto los timers seguirian
      // corriendo despues de que el trip dejo de existir.
      ref.invalidate(tripPauseNotifierProvider(widget.tripId));
      ref.read(tripsListRefreshProvider.notifier).state++;
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('El viaje fue finalizado o cancelado.'),
            duration: Duration(seconds: 4),
          ),
        );
      // Volver al listado de viajes. Si por algun motivo no podemos
      // pop (deep-link cold-start), `go` directo.
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
      } else {
        router.go('/viajes');
      }
    });

    // Escuchar el chat: cuando llega un mensaje [LLAMADA · ...] disparar
    // la pantalla fake-call. La logica de detection esta en ChatNotifier.
    ref.listen(chatNotifierProvider(widget.tripId), (prev, next) {
      final call = next.pendingCall;
      if (call == null || call == prev?.pendingCall) return;
      final parsed = parsearPrefijoCascada(call.content);
      if (parsed?.tipo != TipoCascada.llamada) return;
      // Limpiar antes de navegar para no spawner dos veces.
      ref
          .read(chatNotifierProvider(widget.tripId).notifier)
          .marcarLlamadaConsumida();
      context.push(
        '/viaje/${widget.tripId}/fake-call',
        extra: <String, dynamic>{
          'alertId': call.alertId,
          'regla': parsed!.regla,
          'contenido': parsed.contenidoLimpio,
        },
      );
    });

    // Gate del simulador de ubicacion: solo visible para usuarios con
    // rol 'admin' en builds debug. En release builds nunca aparece, da
    // igual el rol — el AND con kDebugMode garantiza que el bundle
    // productivo no exponga la herramienta de QA al chofer normal.
    final esAdmin =
        ref.watch(authNotifierProvider).user?.esAdmin ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripId),
        actions: [
          if (kDebugMode && esAdmin) _BotonSimuladorDebug(),
          _BotonChat(tripId: widget.tripId),
          IconButton(
            onPressed: () => setState(() {
              _future = _cargar();
            }),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Trip>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final trip = snap.data!;
          // Watchdog: si el viaje esta ACTIVE y el GPS no reporta, arrancar
          // automaticamente. Cubre el caso "el chofer cerro la app y volvio".
          _watchdogGpsActivo(trip);
          return Column(
            children: [
              // Banner de viaje en pausa (PARADA_COMER / PARADA_DESCANSAR).
              // Sticky arriba con countdown live. Solo visible cuando hay
              // pausa activa — el provider devuelve `paused: false` cuando
              // no hay y el banner se autocolapsa.
              if (trip.esActivo) TripPauseBanner(tripId: trip.id),
              // Banner persistente de alertas L2/L3 pendientes de
              // acknowledge. Solo visible cuando el viaje esta ACTIVE y
              // hay alertas que requieren accion del chofer.
              if (trip.esActivo) PendingActionBanner(tripId: trip.id),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _future = _cargar();
                    });
                    await _future;
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (trip.esPendiente) ...[
                        ViajePendienteCard(
                          trip: trip,
                          onIniciado: () => setState(() {
                            _future = _cargar();
                          }),
                        ),
                        const SizedBox(height: 16),
                        // MC-022: checklist de salida visible en PENDING.
                        // El boton "Iniciar viaje" del card de arriba
                        // queda bloqueado hasta que esten todos tildados.
                        ChecklistSection(tripId: trip.id),
                        const SizedBox(height: 16),
                        _HojaRutaCard(trip: trip),
                        const SizedBox(height: 16),
                        if (trip.hojaRuta.contactosList.isNotEmpty) ...[
                          _ContactosCard(
                            contactos: trip.hojaRuta.contactosList,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                      if (!trip.esPendiente) ...[
                        _TrackingCard(
                          trip: trip,
                          onToggle: () => _toggleTracking(trip),
                        ),
                        const SizedBox(height: 16),
                        RecorridoSection(
                          tripId: trip.id,
                          hojaRuta: trip.hojaRuta,
                          origenNombre: trip.nombreOrigen,
                          destinoNombre: trip.nombreDestino,
                        ),
                        const SizedBox(height: 16),
                        _HojaRutaCard(trip: trip),
                        const SizedBox(height: 16),
                        // MC-022: checklist tambien visible en ACTIVE
                        // por si el chofer necesita destildar/retildar
                        // algo mid-viaje. En FINISHED/CANCELLED el
                        // backend lo devuelve read-only y el widget
                        // sigue mostrandolo igual sin permitir cambios
                        // (los 409 revierten cualquier toggle).
                        if (trip.esActivo) ...[
                          ChecklistSection(tripId: trip.id),
                          const SizedBox(height: 16),
                        ],
                        if (trip.hojaRuta.contactosList.isNotEmpty) ...[
                          _ContactosCard(
                            contactos: trip.hojaRuta.contactosList,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          'Enviar alerta',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        AlertasPanel(tripId: trip.id),
                        const SizedBox(height: 24),
                        if (trip.esActivo)
                          OutlinedButton.icon(
                            onPressed: () => _finalizar(trip),
                            icon: const Icon(Icons.flag),
                            label: const Text('Finalizar viaje'),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- Tracking card ---

class _TrackingCard extends ConsumerWidget {
  const _TrackingCard({required this.trip, required this.onToggle});

  final Trip trip;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gps = ref.watch(gpsServiceProvider);
    final pos = gps.ultimaPosicion;
    final envio = gps.ultimoEnvio;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  gps.activo ? Icons.phone_android : Icons.phonelink_off,
                  color: gps.activo ? scheme.primary : scheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    gps.activo
                        ? 'Reportando ubicacion del telefono'
                        : 'Reporte de telefono detenido',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // Solo permitimos toggle manual cuando el viaje NO esta
                // activo (estados PENDING, FINISHED, CANCELLED) — durante
                // ACTIVE el reporte es continuo y no se interrumpe a mano.
                if (!trip.esActivo)
                  FilledButton.tonal(
                    onPressed: onToggle,
                    child: Text(gps.activo ? 'Parar' : 'Iniciar'),
                  ),
              ],
            ),
            if (trip.esActivo && !gps.activo) ...[
              const SizedBox(height: 10),
              _BannerGpsCaido(trip: trip),
            ],
            if (trip.esActivo) ...[
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () =>
                    context.push('/viaje/${trip.id}/navegacion'),
                icon: const Icon(Icons.navigation),
                label: const Text('Navegar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ],
            if (gps.overrideActivo) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pin_drop, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      'Ubicacion simulada (debug)',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Tu telefono reporta cada ${gps.enBackground ? 60 : 15}s. '
              'El dispositivo satelital del camion (IMEI ${trip.imei}) '
              'reporta por su cuenta.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
            const SizedBox(height: 8),
            if (pos != null)
              _KV(
                label: 'Ubicacion',
                value:
                    '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
              ),
            if (envio != null)
              _KV(
                label: 'Ultimo envio',
                value: DateFormat('HH:mm:ss').format(envio),
              ),
            if (gps.activo) ...[
              const SizedBox(height: 6),
              _IndicadorPhoneLocation(
                ultimoEnvio: gps.ultimoEnvio,
                ultimoError: gps.ultimoErrorPhone,
                enBackground: gps.enBackground,
              ),
            ],
            if (gps.ultimoError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  // TODO(MC-022-followup): gps.ultimoError contiene el
                  // toString del exception crudo (ej. "TimeoutException
                  // after 0:00:08.000000: Future not completed"). Se
                  // ve feo al chofer durante el cold start del GPS.
                  // Reemplazar por un mensaje legible o ignorar
                  // TimeoutException en gps_service.dart:238.
                  gps.ultimoError!,
                  style: TextStyle(color: scheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Hoja de ruta card ---

class _HojaRutaCard extends StatelessWidget {
  const _HojaRutaCard({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final h = trip.hojaRuta;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hoja de ruta',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (h.vacia)
              Text(
                'Hoja de ruta no disponible',
                style: TextStyle(color: Theme.of(context).hintColor),
              )
            else ...[
              if (h.identification != null)
                _KV(label: 'Nombre', value: h.identification!),
              if (h.referenceCode != null)
                _KV(label: 'Referencia', value: h.referenceCode!),
              if (h.origin != null)
                _KV(label: 'Origen', value: trip.nombreOrigen),
              if (h.destination != null)
                _KV(label: 'Destino', value: trip.nombreDestino),
              if (h.tripTypeId != null)
                _KV(label: 'Tipo', value: h.tripTypeId!),
              if (h.cargoTypeId != null)
                _KV(label: 'Carga', value: h.cargoTypeId!),
              if (h.cargoValue != null)
                _KV(label: 'Valor carga', value: h.cargoValue!),
              if (h.etaStart != null || h.etaEnd != null)
                _KV(
                  label: 'ETA',
                  value: '${h.etaStart ?? '-'} a ${h.etaEnd ?? '-'}',
                ),
              if (h.notes != null && h.notes!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text('Notas', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(h.notes!),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// --- Contactos card ---

class _ContactosCard extends StatelessWidget {
  const _ContactosCard({required this.contactos});
  final List<TripContact> contactos;

  Future<void> _llamar(BuildContext context, String phone) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final uri = Uri(scheme: 'tel', path: phone);
      if (!await canLaunchUrl(uri)) {
        messenger.showSnackBar(
          const SnackBar(content: Text('No se puede iniciar la llamada')),
        );
        return;
      }
      await launchUrl(uri);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contactos',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final c in contactos)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person),
                title: Text(c.name),
                subtitle: Text(
                    '${c.phone}${c.role != null ? ' - ${c.role}' : ''}'),
                trailing: c.phone.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () => _llamar(context, c.phone),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

// --- KV row helper ---

class _KV extends StatelessWidget {
  const _KV({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _KVChild(label: label, child: Text(value));
  }
}

/// Indicador compacto del estado del reporte de ubicacion del telefono
/// (diferente del ingest del camion). Verde si el ultimo ping fue OK,
/// rojo si fallo, gris si aun no hubo envio.
class _IndicadorPhoneLocation extends StatelessWidget {
  const _IndicadorPhoneLocation({
    required this.ultimoEnvio,
    required this.ultimoError,
    required this.enBackground,
  });

  final DateTime? ultimoEnvio;
  final String? ultimoError;
  final bool enBackground;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String texto;
    if (ultimoError != null) {
      color = Theme.of(context).colorScheme.error;
      texto = 'Ultimo reporte fallo';
    } else if (ultimoEnvio == null) {
      color = Theme.of(context).hintColor;
      texto = 'Reportando ubicacion del telefono...';
    } else {
      color = Colors.green;
      final hora = DateFormat('HH:mm:ss').format(ultimoEnvio!);
      texto = 'Reportando ubicacion (telefono) · $hora'
          '${enBackground ? ' · segundo plano' : ''}';
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
      ],
    );
  }
}

/// Variante de _KV que acepta un Widget como valor (para mostrar async
/// resolutions, chips, etc).
class _KVChild extends StatelessWidget {
  const _KVChild({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Banner rojo que aparece cuando el viaje esta ACTIVE pero el GpsService no
/// esta reportando. Indica error de permisos / servicio caido y ofrece
/// reintentar o abrir Configuracion segun el caso.
///
/// Tiene un "warmup" de 1.5s al montarse: durante ese tiempo no se muestra
/// nada. Razon: al entrar al viaje activo, el `_watchdogGpsActivo` dispara
/// `gps.iniciar()` que tarda 1-2s en enganchar el primer fix. Sin warmup,
/// el banner aparece durante esa ventana y desaparece solo — flicker feo.
/// Pasado el warmup, si el GPS sigue inactivo es indicio de un problema
/// real (permisos / servicio off) y ahi si vale mostrarlo.
class _BannerGpsCaido extends ConsumerStatefulWidget {
  const _BannerGpsCaido({required this.trip});
  final Trip trip;

  @override
  ConsumerState<_BannerGpsCaido> createState() => _BannerGpsCaidoState();
}

class _BannerGpsCaidoState extends ConsumerState<_BannerGpsCaido> {
  static const _warmup = Duration(milliseconds: 1500);

  bool _warmupDone = false;
  Timer? _warmupTimer;

  @override
  void initState() {
    super.initState();
    _warmupTimer = Timer(_warmup, () {
      if (!mounted) return;
      setState(() => _warmupDone = true);
    });
  }

  @override
  void dispose() {
    _warmupTimer?.cancel();
    super.dispose();
  }

  Future<void> _reactivar(BuildContext context) async {
    final gps = ref.read(gpsServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final permiso = await gps.pedirPermisoUbicacion();
    if (permiso != PermisoUbicacionResult.ok) {
      if (!context.mounted) return;
      if (permiso == PermisoUbicacionResult.denegadoParaSiempre) {
        await ph.openAppSettings();
        return;
      }
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo reactivar el GPS. Verificá permisos.'),
        ),
      );
      return;
    }
    await gps.iniciar(imei: widget.trip.imei, tripId: widget.trip.id);
    if (!context.mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('GPS reactivado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_warmupDone) return const SizedBox.shrink();
    final gps = ref.watch(gpsServiceProvider);
    final scheme = Theme.of(context).colorScheme;
    final motivo = gps.ultimoError ?? 'GPS no está reportando';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.error.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.gps_off, color: scheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No estás reportando ubicación',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  motivo,
                  style: TextStyle(
                    color: scheme.onErrorContainer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: () => _reactivar(context),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
            child: const Text('Reactivar'),
          ),
        ],
      ),
    );
  }
}

// --- Boton simulador de ubicacion (solo debug, visible en toda la pantalla) ---

class _BotonSimuladorDebug extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overrideActivo =
        ref.watch(gpsServiceProvider.select((s) => s.overrideActivo));
    return IconButton(
      tooltip: 'Simular ubicacion (debug)',
      icon: Icon(
        overrideActivo ? Icons.pin_drop : Icons.pin_drop_outlined,
        color: overrideActivo ? Colors.orange : null,
      ),
      onPressed: () => context.push('/debug/ubicacion'),
    );
  }
}

// --- Boton de chat con badge de mensajes no leidos ---

class _BotonChat extends ConsumerWidget {
  const _BotonChat({required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(
      chatNotifierProvider(tripId).select((s) => s.unreadForDriver),
    );
    return IconButton(
      tooltip: 'Chat con monitoreo',
      onPressed: () => context.push('/viaje/$tripId/chat'),
      icon: unread > 0
          ? Badge.count(
              count: unread,
              child: const Icon(Icons.forum),
            )
          : const Icon(Icons.forum_outlined),
    );
  }
}
