import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permission_handler/permission_handler.dart' as ph;

import '../../../core/providers.dart';
import '../../../core/utils/external_navigation.dart';
import '../../../core/utils/geo.dart';
import '../../hoja_ruta/data/trip_exceptions.dart';
import '../../hoja_ruta/models/trip.dart';
import '../../ingest/service/gps_service.dart';
import '../../shared/ui/proximity_error_helpers.dart';

const double _umbralIniciarM = 100.0;

/// Card que se muestra cuando el viaje esta en estado PENDING.
/// Muestra info del origen, la distancia actual al origen (refrescada cada
/// 5s con el GPS low-accuracy) y el boton para disparar POST /trips/{id}/start.
class ViajePendienteCard extends ConsumerStatefulWidget {
  const ViajePendienteCard({
    super.key,
    required this.trip,
    required this.onIniciado,
  });

  final Trip trip;
  /// Callback que se llama despues del start exitoso para refrescar el
  /// detalle del viaje desde el parent.
  final VoidCallback onIniciado;

  @override
  ConsumerState<ViajePendienteCard> createState() => _ViajePendienteCardState();
}

class _ViajePendienteCardState extends ConsumerState<ViajePendienteCard> {
  Timer? _timer;
  double? _distanciaM;
  double? _latActual;
  double? _lonActual;
  bool _enviando = false;
  bool _buscandoGps = false;

  @override
  void initState() {
    super.initState();
    _refrescarDistancia();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refrescarDistancia(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refrescarDistancia() async {
    final origenLat = widget.trip.origenLat;
    final origenLon = widget.trip.origenLon;
    if (origenLat == null || origenLon == null) return;
    if (_buscandoGps) return;
    _buscandoGps = true;
    try {
      final gps = ref.read(gpsServiceProvider);
      final pos = await gps.ubicacionActual();
      if (pos == null) return;
      final dist = haversineMeters(
        pos.latitude,
        pos.longitude,
        origenLat,
        origenLon,
      );
      if (!mounted) return;
      setState(() {
        _distanciaM = dist;
        _latActual = pos.latitude;
        _lonActual = pos.longitude;
      });
    } finally {
      _buscandoGps = false;
    }
  }

  Future<void> _iniciar() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _enviando = true);
    try {
      final gps = ref.read(gpsServiceProvider);

      // 0) Antes que nada, validar permisos GPS. Sin permisos no se puede
      //    iniciar el viaje (el chofer no podria reportar ubicacion).
      final permiso = await gps.pedirPermisoUbicacion();
      if (permiso != PermisoUbicacionResult.ok) {
        if (!mounted) return;
        await _mostrarDialogPermisoFaltante(permiso);
        return;
      }

      final pos = await gps.ubicacionActual();
      if (pos == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Sin ubicacion GPS. Probá de nuevo.')),
        );
        return;
      }
      final repo = ref.read(tripsRepoProvider);
      final tripIniciado = await repo.iniciarViaje(
        tripId: widget.trip.id,
        lat: pos.latitude,
        lon: pos.longitude,
      );
      // Arrancar el loop GPS automaticamente tras start exitoso (ingest del
      // camion y phone-location del chofer en paralelo, cada 15s).
      await gps.iniciar(
        imei: tripIniciado.imei,
        tripId: tripIniciado.id,
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Viaje iniciado')),
      );
      widget.onIniciado();
    } on TripStartProximityException catch (e) {
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
        // El usuario quiere volver a intentar sin tocar el boton principal.
        // Llamamos recursivamente una vez — pero solo una, sin bucle.
        await _iniciar();
        return;
      }
    } on TripEstadoInvalidoException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      // Probablemente ya estaba ACTIVE: refrescar para mostrar la UI activa.
      widget.onIniciado();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  String _formatearDistancia(double m) {
    if (m < 1000) return '${m.toStringAsFixed(0)} m';
    return '${(m / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _mostrarDialogPermisoFaltante(
    PermisoUbicacionResult resultado,
  ) async {
    final scheme = Theme.of(context).colorScheme;
    String titulo;
    String mensaje;
    bool abrirSettings = false;
    switch (resultado) {
      case PermisoUbicacionResult.servicioDesactivado:
        titulo = 'Activá la ubicación';
        mensaje = 'El servicio de ubicación del teléfono está apagado. '
            'Encendelo desde los Ajustes del sistema y volvé a intentar.';
        break;
      case PermisoUbicacionResult.denegadoParaSiempre:
        titulo = 'Permiso de ubicación denegado';
        mensaje = 'El permiso fue rechazado de forma permanente. '
            'Tenés que habilitarlo manualmente desde Configuración → Apps → '
            'IsaTech Conductor → Permisos → Ubicación.';
        abrirSettings = true;
        break;
      case PermisoUbicacionResult.denegado:
      default:
        titulo = 'Necesito permiso de ubicación';
        mensaje = 'Sin permiso de GPS no puedo iniciar el viaje porque no '
            'puedo reportar tu ubicación al monitoreo. Otorgalo y volvé a '
            'tocar Iniciar.';
        break;
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.location_off, size: 36, color: scheme.error),
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          if (abrirSettings)
            FilledButton.icon(
              onPressed: () async {
                Navigator.pop(ctx);
                await ph.openAppSettings();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Abrir Configuración'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trip = widget.trip;
    final origenLat = trip.origenLat;
    final origenLon = trip.origenLon;
    final tieneOrigenCoords = origenLat != null && origenLon != null;
    final cerca = _distanciaM != null && _distanciaM! <= _umbralIniciarM;
    // MC-022: el checklist de salida tambien gatea el inicio. Para
    // viajes sin checklist definido (legacy / operador no agrego items)
    // `permiteIniciar` ya es true y este gate no aplica.
    final checklist = ref
        .watch(tripChecklistNotifierProvider(trip.id))
        .checklist;
    final checklistOk = checklist.permiteIniciar;
    final puedeIniciar =
        tieneOrigenCoords && cerca && checklistOk && !_enviando;
    // MC-020: si el viaje quedo en cola detras de otro, mostrar
    // disclaimer al lado del boton "Llevarme al origen". El chofer
    // puede manejar hacia el proximo origen mientras termina el actual.
    final queuedBehindRaw = trip.params['queued_behind'];
    final queuedBehind =
        queuedBehindRaw is String && queuedBehindRaw.isNotEmpty
            ? queuedBehindRaw
            : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.hourglass_top, color: scheme.tertiary),
                const SizedBox(width: 8),
                Text(
                  'Viaje pendiente',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Para iniciar el viaje debes estar en el origen.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            // Origen
            _Fila(
              icon: Icons.trip_origin,
              label: 'Origen',
              child: Text(
                trip.nombreOrigen,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (tieneOrigenCoords)
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 2),
                child: Text(
                  '${origenLat.toStringAsFixed(5)}, '
                  '${origenLon.toStringAsFixed(5)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ),
            const SizedBox(height: 12),
            // Posicion actual
            _Fila(
              icon: Icons.my_location,
              label: 'Tu posicion',
              child: Text(
                _latActual != null && _lonActual != null
                    ? '${_latActual!.toStringAsFixed(5)}, '
                        '${_lonActual!.toStringAsFixed(5)}'
                    : 'Buscando GPS...',
              ),
            ),
            const SizedBox(height: 12),
            // Distancia
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: cerca
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    cerca ? Icons.check_circle : Icons.location_searching,
                    color: cerca ? scheme.primary : scheme.outline,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      !tieneOrigenCoords
                          ? 'Origen sin coordenadas definidas — no se puede '
                              'validar distancia'
                          : _distanciaM == null
                              ? 'Calculando distancia al origen...'
                              : cerca
                                  ? 'Estas en el origen. Ya podes iniciar.'
                                  : 'Distancia al origen: '
                                      '${_formatearDistancia(_distanciaM!)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cerca
                                ? scheme.onPrimaryContainer
                                : scheme.onSurface,
                            fontWeight:
                                cerca ? FontWeight.w600 : FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // MC-020: deep-link a la app de mapas del SO con el origen
            // del viaje como destino. Visible siempre que haya coords;
            // si no hay, queda disabled con tooltip.
            Tooltip(
              message: tieneOrigenCoords
                  ? ''
                  : 'Sin coordenadas de origen — no se puede abrir el mapa.',
              triggerMode: tieneOrigenCoords
                  ? TooltipTriggerMode.manual
                  : TooltipTriggerMode.tap,
              child: OutlinedButton.icon(
                onPressed: tieneOrigenCoords && !_enviando
                    ? () => abrirNavegacionAOrigen(
                          context,
                          lat: origenLat,
                          lon: origenLon,
                        )
                    : null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Llevarme al origen'),
              ),
            ),
            if (queuedBehind != null) ...[
              const SizedBox(height: 6),
              Text(
                'Vas a poder iniciar este viaje cuando termines el viaje '
                '$queuedBehind.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: puedeIniciar ? _iniciar : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              icon: _enviando
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(
                _enviando
                    ? 'Iniciando...'
                    // MC-022: checklist tiene prioridad sobre el guard
                    // de proximidad — la idea de producto es "primero
                    // verifica, despues te movés al origen".
                    : !checklistOk
                        ? 'Falta completar checklist '
                            '(${checklist.completedCount}/${checklist.totalCount})'
                        : tieneOrigenCoords
                            ? cerca
                                ? 'Iniciar viaje'
                                : _distanciaM == null
                                    ? 'Buscando GPS...'
                                    : 'Acercate al origen (${_formatearDistancia(_distanciaM!)} restantes)'
                            : 'Iniciar viaje',
              ),
            ),
            if (!tieneOrigenCoords) ...[
              const SizedBox(height: 8),
              Text(
                'Nota: como el origen no tiene coordenadas, el backend usara '
                'un fallback. Consulta al operador si no podes iniciar.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).hintColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
              child,
            ],
          ),
        ),
      ],
    );
  }
}
