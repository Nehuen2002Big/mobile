import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers.dart';
import '../../../core/utils/geo.dart';
import '../../hoja_ruta/models/road_sheet.dart';
import '../../ingest/service/gps_service.dart';
import '../../shared/ui/proximity_error_helpers.dart';
import '../../uploads/models/checkpoint_evidence.dart';
import '../../uploads/ui/evidencia_thumb.dart';
import '../data/checkpoint_exceptions.dart';
import '../models/checkpoint_info.dart';
import 'marcar_checkpoint_sheet.dart';

/// Limite client-side para considerar "cerca" sin llamar al backend. Si se
/// excede se deshabilita el boton. El backend tiene su propio limite (100m
/// por default).
const _umbralCercaniaCliente = 200.0;

class RecorridoSection extends ConsumerWidget {
  const RecorridoSection({
    super.key,
    required this.tripId,
    required this.hojaRuta,
    required this.origenNombre,
    required this.destinoNombre,
  });

  final String tripId;
  final RoadSheet hojaRuta;

  /// Nombre legible del origen ya resuelto del lado backend
  /// (`_resolved.origin_name`). El caller lo deriva de
  /// `trip.nombreOrigen`. Cubre los 3 formatos del road_sheet
  /// (UUID / `new:...` / free-form) sin que esta seccion tenga que
  /// llamar al backend.
  final String origenNombre;

  /// Idem destino — `trip.nombreDestino` del caller.
  final String destinoNombre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(checkpointsNotifierProvider(tripId));
    final gps = ref.watch(gpsServiceProvider);

    if (st.loading && st.checkpoints.isEmpty) {
      return const _Cargando();
    }

    final checkpoints = st.checkpoints;
    final totalCheckpoints = checkpoints.length;
    if (totalCheckpoints == 0) {
      return _Recorrido(
        tripId: tripId,
        hojaRuta: hojaRuta,
        origenNombre: origenNombre,
        destinoNombre: destinoNombre,
        items: const [],
        nextIndex: null,
        totalCheckpoints: 0,
        reachedCount: 0,
        gps: gps,
      );
    }

    return _Recorrido(
      tripId: tripId,
      hojaRuta: hojaRuta,
      origenNombre: origenNombre,
      destinoNombre: destinoNombre,
      items: checkpoints,
      nextIndex: st.nextCheckpointIndex,
      totalCheckpoints: totalCheckpoints,
      reachedCount: st.reachedCount,
      gps: gps,
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Cargando recorrido...'),
          ],
        ),
      ),
    );
  }
}

class _Recorrido extends StatelessWidget {
  const _Recorrido({
    required this.tripId,
    required this.hojaRuta,
    required this.origenNombre,
    required this.destinoNombre,
    required this.items,
    required this.nextIndex,
    required this.totalCheckpoints,
    required this.reachedCount,
    required this.gps,
  });

  final String tripId;
  final RoadSheet hojaRuta;
  final String origenNombre;
  final String destinoNombre;
  final List<CheckpointInfo> items;
  final int? nextIndex;
  final int totalCheckpoints;
  final int reachedCount;
  final GpsService gps;

  CheckpointInfo? get _actual =>
      nextIndex != null && nextIndex! < items.length ? items[nextIndex!] : null;

  bool get _todoMarcado => totalCheckpoints > 0 && reachedCount >= totalCheckpoints;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BannerDestino(
              actual: _actual,
              todoMarcado: _todoMarcado,
              destinoFinalNombre: destinoNombre,
              destinoFinalDefinido: hojaRuta.destination != null,
              reachedCount: reachedCount,
              totalCheckpoints: totalCheckpoints,
            ),
            if (items.isNotEmpty || hojaRuta.origin != null) ...[
              const SizedBox(height: 18),
              _Timeline(
                tripId: tripId,
                origenNombre: origenNombre,
                origenDefinido: hojaRuta.origin != null,
                destinoNombre: destinoNombre,
                destinoDefinido: hojaRuta.destination != null,
                items: items,
                nextIndex: nextIndex,
                gps: gps,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BannerDestino extends StatelessWidget {
  const _BannerDestino({
    required this.actual,
    required this.todoMarcado,
    required this.destinoFinalNombre,
    required this.destinoFinalDefinido,
    required this.reachedCount,
    required this.totalCheckpoints,
  });

  final CheckpointInfo? actual;
  final bool todoMarcado;

  /// Nombre legible del destino final (`trip.nombreDestino` del
  /// caller — ya resuelto contra `_resolved.destination_name`).
  final String destinoFinalNombre;

  /// `true` si el road_sheet realmente tiene `destination` definido.
  /// Sirve para diferenciar "destino sin definir" de "destino
  /// definido pero nombre vacio" (este ultimo cae al placeholder).
  final bool destinoFinalDefinido;

  final int reachedCount;
  final int totalCheckpoints;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Widget tituloWidget;
    final String subtitulo;
    final IconData icon;
    final tieneDestino =
        destinoFinalDefinido && destinoFinalNombre.trim().isNotEmpty;
    final tituloStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        );
    if (actual != null) {
      final textoTitulo = actual!.name ?? 'Checkpoint ${actual!.index + 1}';
      tituloWidget = Text(
        textoTitulo,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: tituloStyle,
      );
      final acc = actual!.accionLabel;
      final cargo = actual!.cargoDescription;
      subtitulo = cargo != null && cargo.isNotEmpty ? '$acc · $cargo' : acc;
      icon = Icons.navigation;
    } else if (todoMarcado && tieneDestino) {
      tituloWidget = Text(
        destinoFinalNombre,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: tituloStyle,
      );
      subtitulo = 'Destino final · todos los checkpoints marcados';
      icon = Icons.flag;
    } else if (tieneDestino) {
      tituloWidget = Text(
        destinoFinalNombre,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: tituloStyle,
      );
      subtitulo = 'Destino final';
      icon = Icons.flag;
    } else {
      tituloWidget = Text(
        'Sin destino definido',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
      );
      subtitulo = 'La hoja de ruta no tiene destino';
      icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: scheme.primary,
            child: Icon(icon, color: scheme.onPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Destino actual',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                ),
                const SizedBox(height: 2),
                tituloWidget,
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
          if (totalCheckpoints > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$reachedCount/$totalCheckpoints',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.tripId,
    required this.origenNombre,
    required this.origenDefinido,
    required this.destinoNombre,
    required this.destinoDefinido,
    required this.items,
    required this.nextIndex,
    required this.gps,
  });

  final String tripId;
  final String origenNombre;
  final bool origenDefinido;
  final String destinoNombre;
  final bool destinoDefinido;
  final List<CheckpointInfo> items;
  final int? nextIndex;
  final GpsService gps;

  @override
  Widget build(BuildContext context) {
    final nodos = <Widget>[];

    if (origenDefinido && origenNombre.isNotEmpty) {
      nodos.add(
        _TimelineNodo(
          estado: _EstadoNodo.pasado,
          etiqueta: 'Origen',
          titulo: origenNombre,
          tituloWidget: Text(
            origenNombre,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    for (final cp in items) {
      final estado = cp.reached
          ? _EstadoNodo.pasado
          : (cp.index == nextIndex ? _EstadoNodo.actual : _EstadoNodo.futuro);
      nodos.add(
        _TimelineNodo(
          estado: estado,
          etiqueta: 'Checkpoint ${cp.index + 1}',
          titulo: cp.name ?? '(sin nombre)',
          subtitulo: _buildSubtitulo(cp),
          trailingTop: cp.reached && cp.reachedAt != null
              ? _ChipConfirmado(reachedAt: cp.reachedAt!)
              : null,
          bottomChild: estado == _EstadoNodo.actual
              ? _AccionesCheckpointActual(
                  tripId: tripId,
                  checkpoint: cp,
                  gps: gps,
                )
              : cp.reached && cp.reachEvidences.isNotEmpty
                  ? _EvidenciasStrip(evidencias: cp.reachEvidences)
                  : null,
        ),
      );
    }
    if (destinoDefinido && destinoNombre.isNotEmpty) {
      nodos.add(
        _TimelineNodo(
          estado: _EstadoNodo.futuro,
          etiqueta: 'Destino final',
          titulo: destinoNombre,
          tituloWidget: Text(
            destinoNombre,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          esUltimo: true,
        ),
      );
    }

    if (nodos.isEmpty) return const SizedBox.shrink();

    // Senal al ultimo para no dibujar la linea vertical bajo ese nodo.
    return Column(
      children: [
        for (int i = 0; i < nodos.length; i++)
          (nodos[i] as _TimelineNodo).copyEsUltimo(i == nodos.length - 1),
      ],
    );
  }

  String? _buildSubtitulo(CheckpointInfo cp) {
    final parts = <String>[];
    parts.add(cp.accionLabel);
    if (cp.cargoDescription != null && cp.cargoDescription!.isNotEmpty) {
      parts.add(cp.cargoDescription!);
    }
    if (cp.notes != null && cp.notes!.isNotEmpty) {
      parts.add('"${cp.notes}"');
    }
    return parts.join(' · ');
  }
}

enum _EstadoNodo { pasado, actual, futuro }

class _TimelineNodo extends StatelessWidget {
  const _TimelineNodo({
    required this.estado,
    required this.etiqueta,
    required this.titulo,
    this.tituloWidget,
    this.subtitulo,
    this.trailingTop,
    this.bottomChild,
    this.esUltimo = false,
  });

  final _EstadoNodo estado;
  final String etiqueta;
  final String titulo;

  /// Si se provee, reemplaza el Text(titulo) por el widget dado (para
  /// resolver UUIDs de location a nombre).
  final Widget? tituloWidget;

  final String? subtitulo;
  final Widget? trailingTop;
  final Widget? bottomChild;
  final bool esUltimo;

  _TimelineNodo copyEsUltimo(bool last) => _TimelineNodo(
        estado: estado,
        etiqueta: etiqueta,
        titulo: titulo,
        tituloWidget: tituloWidget,
        subtitulo: subtitulo,
        trailingTop: trailingTop,
        bottomChild: bottomChild,
        esUltimo: last,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    late final Color colorCirculo;
    late final IconData? iconoCirculo;
    late final Color colorLinea;
    switch (estado) {
      case _EstadoNodo.pasado:
        colorCirculo = scheme.primary;
        iconoCirculo = Icons.check;
        colorLinea = scheme.primary.withValues(alpha: 0.6);
        break;
      case _EstadoNodo.actual:
        colorCirculo = scheme.primary;
        iconoCirculo = Icons.navigation;
        colorLinea = scheme.outline;
        break;
      case _EstadoNodo.futuro:
        colorCirculo = scheme.surfaceContainerHighest;
        iconoCirculo = null;
        colorLinea = scheme.outline;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gutter con circulo + linea vertical.
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: colorCirculo,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: estado == _EstadoNodo.actual
                        ? scheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: iconoCirculo != null
                    ? Icon(iconoCirculo, size: 14, color: scheme.onPrimary)
                    : null,
              ),
              if (!esUltimo)
                Expanded(
                  child: Container(
                    width: 2,
                    color: colorLinea,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Contenido.
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: esUltimo ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          etiqueta,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (trailingTop != null) trailingTop!,
                    ],
                  ),
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ) ??
                        const TextStyle(fontWeight: FontWeight.w600),
                    child: tituloWidget ?? Text(titulo),
                  ),
                  if (subtitulo != null && subtitulo!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitulo!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (bottomChild != null) ...[
                    const SizedBox(height: 10),
                    bottomChild!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipConfirmado extends StatelessWidget {
  const _ChipConfirmado({required this.reachedAt});
  final DateTime reachedAt;

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat('HH:mm').format(reachedAt.toLocal());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            hora,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccionesCheckpointActual extends ConsumerStatefulWidget {
  const _AccionesCheckpointActual({
    required this.tripId,
    required this.checkpoint,
    required this.gps,
  });

  final String tripId;
  final CheckpointInfo checkpoint;
  final GpsService gps;

  @override
  ConsumerState<_AccionesCheckpointActual> createState() =>
      _AccionesCheckpointActualState();
}

class _AccionesCheckpointActualState
    extends ConsumerState<_AccionesCheckpointActual> {
  Future<void> _marcar() async {
    final cp = widget.checkpoint;
    final gps = widget.gps;
    final messenger = ScaffoldMessenger.of(context);

    // Flujo segun action_type: delivery/pickup piden foto obligatoria,
    // stop pide motivo obligatorio, rest confirma directo.
    final datos = await showMarcarCheckpointSheet(
      context: context,
      checkpoint: cp,
      tripId: widget.tripId,
    );
    if (datos == null) return;

    // GPS fresco.
    final pos = await gps.ubicacionActual();
    if (pos == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Sin ubicacion disponible')),
      );
      return;
    }

    try {
      final res = await ref
          .read(checkpointsNotifierProvider(widget.tripId).notifier)
          .marcar(
            tripId: widget.tripId,
            index: cp.index,
            lat: pos.latitude,
            lon: pos.longitude,
            notes: datos.notes,
            evidences: datos.evidences,
          );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Checkpoint ${cp.index + 1} confirmado '
            '(${res.distanceToCheckpointM.toStringAsFixed(0)} m)',
          ),
        ),
      );
      if (res.allDone) {
        await _mostrarDialogFinal(context);
      }
    } on CheckpointReachProximityException catch (e) {
      if (!mounted) return;
      await showDialog<void>(
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
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    } on CheckpointYaMarcadoException {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Este checkpoint ya estaba marcado.')),
      );
      await ref
          .read(checkpointsNotifierProvider(widget.tripId).notifier)
          .refrescar(widget.tripId);
    } on CheckpointSinCoordenadasException {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Este checkpoint no tiene coordenadas definidas. Contactar al '
            'operador.',
          ),
        ),
      );
    } on EvidenciaFotoRequeridaException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } on EvidenciaMotivoRequeridoException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _mostrarDialogFinal(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.flag, size: 36),
        title: const Text('Ultimo checkpoint marcado'),
        content: const Text(
          'Ya confirmaste todos los checkpoints. Continua hacia el destino '
          'final del viaje.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(checkpointsNotifierProvider(widget.tripId));
    // Recalcular cada vez que cambie el GPS.
    final gps = ref.watch(gpsServiceProvider);
    final pos = gps.ultimaPosicion;
    final cp = widget.checkpoint;
    double? dist;
    if (cp.lat != null && cp.lon != null && pos != null) {
      dist = haversineMeters(pos.latitude, pos.longitude, cp.lat!, cp.lon!);
    }

    final puedeMarcar =
        dist != null && dist <= _umbralCercaniaCliente && !st.marking;
    final String statusLinea;
    if (dist == null) {
      statusLinea = 'Esperando ubicacion GPS...';
    } else if (dist <= _umbralCercaniaCliente) {
      statusLinea = 'A ${dist.toStringAsFixed(0)} m · podes marcar';
    } else {
      statusLinea = _formatearDistanciaLejos(dist);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (cp.lat != null && cp.lon != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Destino: ${cp.lat!.toStringAsFixed(5)}, ${cp.lon!.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
        Text(
          statusLinea,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: puedeMarcar
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).hintColor,
                fontWeight: puedeMarcar ? FontWeight.w600 : null,
              ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: (puedeMarcar && !st.marking) ? _marcar : null,
          icon: st.marking
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check_circle),
          label: Text(st.marking ? 'Enviando...' : 'Marcar como llegado'),
        ),
      ],
    );
  }

  String _formatearDistanciaLejos(double m) {
    if (m < 1000) return 'Te faltan ${m.toStringAsFixed(0)} m';
    return 'Te faltan ${(m / 1000).toStringAsFixed(1)} km';
  }
}

/// Strip horizontal con los thumbnails de las evidencias (fotos) que se
/// subieron al confirmar un checkpoint. Se muestra debajo del nodo cuando
/// `checkpoint.reachEvidences` tiene al menos una entrada IMAGE.
class _EvidenciasStrip extends StatelessWidget {
  const _EvidenciasStrip({required this.evidencias});

  final List<CheckpointEvidence> evidencias;

  @override
  Widget build(BuildContext context) {
    final imgs = evidencias
        .where((e) => e.evidenceType == 'IMAGE' &&
            (e.fileUrl ?? '').isNotEmpty)
        .toList();
    if (imgs.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 84,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imgs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => EvidenciaThumb(evidence: imgs[i]),
        ),
      ),
    );
  }
}
