import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/providers.dart';

/// Pantalla de debug: seleccionar una ubicacion tocando el mapa y fijarla
/// como override del GPS real. Mientras este activa, el GpsService devuelve
/// siempre ese punto y el POST /ingest/{imei} manda esas coordenadas fijas.
class SimuladorUbicacionScreen extends ConsumerStatefulWidget {
  const SimuladorUbicacionScreen({super.key});

  @override
  ConsumerState<SimuladorUbicacionScreen> createState() =>
      _SimuladorUbicacionScreenState();
}

class _SimuladorUbicacionScreenState
    extends ConsumerState<SimuladorUbicacionScreen> {
  static const double _zoomMin = 2;
  static const double _zoomMax = 19;
  static const double _zoomInicial = 13;
  static const double _zoomStep = 1.2;

  final _mapCtrl = MapController();
  LatLng? _seleccion;
  double _zoomActual = _zoomInicial;
  StreamSubscription<MapEvent>? _mapEventsSub;

  @override
  void initState() {
    super.initState();
    final gps = ref.read(gpsServiceProvider);
    final actual = gps.ubicacionOverride ?? gps.ultimaPosicion;
    if (actual != null) {
      _seleccion = LatLng(actual.latitude, actual.longitude);
    }
    // Sincronizar _zoomActual con cualquier gesto (pinch, double-tap, scroll).
    _mapEventsSub = _mapCtrl.mapEventStream.listen((event) {
      final z = event.camera.zoom;
      if ((z - _zoomActual).abs() > 0.01) {
        setState(() => _zoomActual = z);
      }
    });
  }

  @override
  void dispose() {
    _mapEventsSub?.cancel();
    _mapCtrl.dispose();
    super.dispose();
  }

  LatLng get _centroInicial {
    if (_seleccion != null) return _seleccion!;
    // Default: Buenos Aires (Obelisco).
    return const LatLng(-34.6037, -58.3816);
  }

  void _fijar() {
    final s = _seleccion;
    if (s == null) return;
    final gps = ref.read(gpsServiceProvider);
    gps.setOverride(s.latitude, s.longitude);
    if (context.canPop()) context.pop();
  }

  Future<void> _limpiarOverride() async {
    final gps = ref.read(gpsServiceProvider);
    await gps.clearOverride();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GPS real restaurado')),
    );
    setState(() {});
  }

  void _zoomIn() {
    final nuevo = (_zoomActual + _zoomStep).clamp(_zoomMin, _zoomMax);
    _mapCtrl.move(_mapCtrl.camera.center, nuevo);
  }

  void _zoomOut() {
    final nuevo = (_zoomActual - _zoomStep).clamp(_zoomMin, _zoomMax);
    _mapCtrl.move(_mapCtrl.camera.center, nuevo);
  }

  Future<void> _irAMiUbicacion() async {
    final gps = ref.read(gpsServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final pos = await gps.ubicacionActual();
    if (pos == null) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Sin ubicacion GPS disponible')),
      );
      return;
    }
    final punto = LatLng(pos.latitude, pos.longitude);
    // Zoom 16 es "barrio": se ve la calle concreta.
    _mapCtrl.move(punto, 16);
    setState(() {
      _seleccion = punto;
      _zoomActual = 16;
    });
  }

  void _centrarEnSeleccion() {
    final s = _seleccion;
    if (s == null) return;
    _mapCtrl.move(s, _zoomActual);
  }

  @override
  Widget build(BuildContext context) {
    final gps = ref.watch(gpsServiceProvider);
    final overrideActivo = gps.overrideActivo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simular ubicacion'),
        actions: [
          if (overrideActivo)
            IconButton(
              tooltip: 'Volver a GPS real',
              icon: const Icon(Icons.gps_fixed),
              onPressed: _limpiarOverride,
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapCtrl,
            options: MapOptions(
              initialCenter: _centroInicial,
              initialZoom: _zoomInicial,
              minZoom: _zoomMin,
              maxZoom: _zoomMax,
              // Habilitar todas las gestures (pinch, double-tap zoom,
              // scroll wheel, rotate, drag). El default ya las trae pero
              // lo dejamos explicito.
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                scrollWheelVelocity: 0.005,
              ),
              onTap: (tapPos, point) {
                setState(() => _seleccion = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'net.isatech.mobile_isatech',
                maxZoom: 19,
              ),
              if (_seleccion != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _seleccion!,
                      width: 40,
                      height: 40,
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Instrucciones arriba + coordenadas + zoom actual.
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            overrideActivo
                                ? 'Override activo (GPS real ignorado)'
                                : 'Toca el mapa para elegir una ubicacion',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'z ${_zoomActual.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    if (_seleccion != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Lat ${_seleccion!.latitude.toStringAsFixed(5)}, '
                        'Lon ${_seleccion!.longitude.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      'Pinch para zoom, doble toque para acercar, '
                      'arrastra para mover.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Controles flotantes a la derecha: +, -, mi ubicacion, centrar marker.
          Positioned(
            right: 12,
            top: 160,
            child: _ControlesMapa(
              onZoomIn:
                  _zoomActual < _zoomMax ? _zoomIn : null,
              onZoomOut:
                  _zoomActual > _zoomMin ? _zoomOut : null,
              onMiUbicacion: _irAMiUbicacion,
              onCentrarMarker: _seleccion != null ? _centrarEnSeleccion : null,
            ),
          ),
          // Botones abajo.
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                if (overrideActivo)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _limpiarOverride,
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text('GPS real'),
                    ),
                  ),
                if (overrideActivo) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _seleccion != null ? _fijar : null,
                    icon: const Icon(Icons.push_pin),
                    label: const Text('Fijar aqui'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Columna vertical de botones flotantes: zoom in/out, centrar en mi ubicacion
/// real, centrar en el marker seleccionado.
class _ControlesMapa extends StatelessWidget {
  const _ControlesMapa({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMiUbicacion,
    required this.onCentrarMarker,
  });

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMiUbicacion;
  final VoidCallback? onCentrarMarker;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BotonCuadrado(
          icon: Icons.add,
          tooltip: 'Acercar',
          onPressed: onZoomIn,
        ),
        const SizedBox(height: 8),
        _BotonCuadrado(
          icon: Icons.remove,
          tooltip: 'Alejar',
          onPressed: onZoomOut,
        ),
        const SizedBox(height: 16),
        _BotonCuadrado(
          icon: Icons.my_location,
          tooltip: 'Ir a mi ubicacion actual',
          onPressed: onMiUbicacion,
        ),
        const SizedBox(height: 8),
        _BotonCuadrado(
          icon: Icons.center_focus_strong,
          tooltip: 'Centrar en el marker',
          onPressed: onCentrarMarker,
        ),
      ],
    );
  }
}

class _BotonCuadrado extends StatelessWidget {
  const _BotonCuadrado({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              icon,
              color: onPressed != null
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).disabledColor,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
