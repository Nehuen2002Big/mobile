import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers.dart';
import '../data/alert_styles.dart';
import '../models/tracking_alert.dart';

/// Banner persistente para alertas L2/L3 que requieren acknowledge del
/// chofer. Sticky arriba de la pantalla del viaje activo (y del chat
/// también) hasta que toca "Recibido", o hasta que el backend
/// auto-ackea (ej. el chofer manda un mensaje al chat → cascada cancela
/// del lado server → próximo poll devuelve total=0 y el banner sale).
///
/// Color del banner = mayor severidad de las alertas pendientes:
///   - Hay alguna L3 → rojo profundo.
///   - Solo L2 → ámbar.
///
/// Layout:
///   header      : "Tenés N alerta(s) que requieren tu confirmación"
///   lista       : hasta 3 items compactos (icon + label + L1/L2/L3 +
///                 título breve). "+ M más" si hay más de 3.
///   acciones    : [ Ver detalles ]   [ Recibido ]
///
/// Si alguno de los items es DEVICE_OFFLINE (ruleType), el sub-texto
/// explicativo del helper [alertSubtitle] se muestra debajo de ese
/// item (no debajo de toda la sección — lo más cerca posible del
/// item que aplica).
class PendingActionBanner extends ConsumerWidget {
  const PendingActionBanner({super.key, required this.tripId});

  final String tripId;

  static const int _maxItems = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingActionNotifierProvider(tripId));
    if (!state.hayPendientes) return const SizedBox.shrink();

    final items = state.items;
    final total = items.length;
    final cantidadVisible = total > _maxItems ? _maxItems : total;
    final restantes = total - cantidadVisible;
    final hayL3 = items.any((a) => a.esL3);
    // Color por severidad: rojo si alguna L3, ámbar si solo L2.
    final bannerColor = hayL3 ? Colors.red.shade700 : Colors.amber.shade800;

    final orderedItems = _ordenarPorSeveridad(items);

    return Material(
      color: bannerColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(total: total),
              const SizedBox(height: 10),
              for (final a in orderedItems.take(_maxItems)) ...[
                _ItemFila(alert: a),
                const SizedBox(height: 6),
              ],
              if (restantes > 0) ...[
                const SizedBox(height: 2),
                Text(
                  '+ $restantes más',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              _Acciones(
                tripId: tripId,
                items: items,
                bannerColor: bannerColor,
                acking: state.acking,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ordena con prioridad L3 > L2, después por más reciente.
  static List<TrackingAlert> _ordenarPorSeveridad(List<TrackingAlert> items) {
    int rank(TrackingAlert a) {
      if (a.esL3) return 0;
      if (a.esL2) return 1;
      return 2;
    }
    final copia = [...items];
    copia.sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      if (r != 0) return r;
      return b.createdAt.compareTo(a.createdAt);
    });
    return copia;
  }
}

/// Línea de header del banner: ⚠️ + texto principal con count.
class _Header extends StatelessWidget {
  const _Header({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) {
    final plural = total == 1 ? '' : 's';
    final verb = total == 1 ? 'requiere' : 'requieren';
    return Row(
      children: [
        const Icon(Icons.warning_amber, color: Colors.white, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Tenés $total alerta$plural que $verb tu confirmación',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

/// Fila compacta de una alerta dentro del banner. Layout:
///
///   [ICON] [LABEL · BADGE] título corto
///                          (subtexto DEVICE_OFFLINE si aplica)
class _ItemFila extends StatelessWidget {
  const _ItemFila({required this.alert});

  final TrackingAlert alert;

  @override
  Widget build(BuildContext context) {
    final tipoStyle = alertHeaderStyle(
      alertType: alert.alertType,
      ruleType: alert.ruleType,
    );
    final nivelStyle = escalationStyle(alert.escalationLevel);
    final subtitulo = alertSubtitle(
      alertType: alert.alertType,
      ruleType: alert.ruleType,
      extra: alert.extra,
    );
    final titulo = _tituloCorto(alert);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(tipoStyle.icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    tipoStyle.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (nivelStyle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        nivelStyle.label,
                        style: TextStyle(
                          color: nivelStyle.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  Text(
                    DateFormat('HH:mm').format(alert.createdAt.toLocal()),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              if (titulo.isNotEmpty)
                Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 12,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (subtitulo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitulo,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      height: 1.25,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fila final del banner con los dos botones. "Ver detalles" abre un
/// bottom-sheet con la lista completa (cuando hay mas de 3 items o el
/// chofer quiere ver mas info por alerta). "Recibido" ackea todos los
/// items visibles del state.
///
/// Caso especial MC-016: si entre los items hay alguno
/// `MOVEMENT_DURING_PAUSE`, mostramos arriba un sub-card con los 2
/// botones especificos ("¿Fuiste vos?" / "No fui yo — alertar") que
/// ackea solo esas alertas. La fila estandar abajo sigue ackeando
/// las restantes.
class _Acciones extends ConsumerWidget {
  const _Acciones({
    required this.tripId,
    required this.items,
    required this.bannerColor,
    required this.acking,
  });

  final String tripId;
  final List<TrackingAlert> items;
  final Color bannerColor;
  final bool acking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementIds = items
        .where((a) => isMovementDuringPause(
              alertType: a.alertType,
              ruleType: a.ruleType,
            ))
        .map((a) => a.id)
        .toList();
    final otherIds = items
        .where((a) => !isMovementDuringPause(
              alertType: a.alertType,
              ruleType: a.ruleType,
            ))
        .map((a) => a.id)
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (movementIds.isNotEmpty) ...[
          _MovementDuringPauseCta(
            tripId: tripId,
            movementIds: movementIds,
            acking: acking,
          ),
          if (otherIds.isNotEmpty) const SizedBox(height: 10),
        ],
        if (otherIds.isNotEmpty)
          _AccionesEstandar(
            tripId: tripId,
            ids: otherIds,
            // Para "Ver detalles" pasamos la lista completa (con
            // movement incluidos) — el sheet ya muestra cada item con
            // su render distintivo y un boton "Recibido" propio que
            // tambien ackea solo `otherIds`.
            allItems: items,
            bannerColor: bannerColor,
            acking: acking,
          ),
      ],
    );
  }
}

/// Sub-card con los 2 botones especificos para
/// `SIN_SENAL + MOVEMENT_DURING_PAUSE` (MC-016). Texto: "¿Fuiste vos
/// manejando?". Botones:
///   - "Sí, fui yo" → ack simple, cierra cascada.
///   - "No fui yo — alertar" → ack + posteo `[CHOFER · ALERTA ROBO]`
///     al chat para que el operador reciba la alerta de robo.
class _MovementDuringPauseCta extends ConsumerWidget {
  const _MovementDuringPauseCta({
    required this.tripId,
    required this.movementIds,
    required this.acking,
  });

  final String tripId;
  final List<int> movementIds;
  final bool acking;

  Future<void> _responder(
    BuildContext context,
    WidgetRef ref, {
    required bool fueElChofer,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref
        .read(pendingActionNotifierProvider(tripId).notifier)
        .acknowledgeMovementDuringPause(
          tripId,
          movementIds,
          fueElChofer: fueElChofer,
        );
    if (!context.mounted) return;
    if (ok) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            fueElChofer
                ? 'Pausa cerrada. Seguí tu viaje.'
                : 'Avisamos al operador. Quedate a la espera.',
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'No pudimos confirmar — verificá tu conexión y reintentá',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '¿Fuiste vos manejando el camión?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Si fuiste vos, cerramos la pausa. Si no, avisamos al '
            'operador como movimiento no autorizado.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: acking
                      ? null
                      : () => _responder(context, ref, fueElChofer: true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Sí, fui yo'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: acking
                      ? null
                      : () => _responder(context, ref, fueElChofer: false),
                  icon: const Icon(Icons.report, size: 18),
                  label: const Text('No fui yo — alertar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fila estandar "Ver detalles" + "Recibido" para alertas no-movement.
/// Es el comportamiento previo a MC-016 — extraido para coexistir con
/// el sub-card de movement-during-pause.
class _AccionesEstandar extends ConsumerWidget {
  const _AccionesEstandar({
    required this.tripId,
    required this.ids,
    required this.allItems,
    required this.bannerColor,
    required this.acking,
  });

  final String tripId;
  final List<int> ids;
  final List<TrackingAlert> allItems;
  final Color bannerColor;
  final bool acking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cantidad = ids.length;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: acking
                ? null
                : () => _verDetalles(context, allItems),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text('Ver detalles'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: acking
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final ok = await ref
                        .read(pendingActionNotifierProvider(tripId).notifier)
                        .acknowledge(tripId, ids);
                    if (!context.mounted) return;
                    if (ok) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            cantidad == 1
                                ? 'Alerta marcada como atendida'
                                : '$cantidad alertas marcadas como atendidas',
                          ),
                        ),
                      );
                    } else {
                      // El POST fallo y el state se restauro al snapshot
                      // anterior — el banner reaparecio. Avisamos para
                      // que el chofer entienda que tiene que reintentar.
                      messenger.showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'No pudimos confirmar — verificá tu conexión y reintentá',
                          ),
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: bannerColor,
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: acking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Recibido'),
          ),
        ),
      ],
    );
  }

  Future<void> _verDetalles(
    BuildContext context,
    List<TrackingAlert> items,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DetallesSheet(tripId: tripId, items: items),
    );
  }
}

/// Bottom sheet con la lista completa de alertas L2/L3 pendientes.
/// Para cada una muestra: icon + label + nivel + título descriptivo +
/// mensaje del backend (si lo hay) + sub-texto explicativo + timestamp
/// completo. Es el detalle "completo" que el banner del top no muestra
/// por límite de espacio. El botón inferior es el mismo "Recibido"
/// que ackea todo.
class _DetallesSheet extends ConsumerWidget {
  const _DetallesSheet({required this.tripId, required this.items});

  final String tripId;
  final List<TrackingAlert> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingActionNotifierProvider(tripId));
    final theme = Theme.of(context);
    // El "Recibido" del sheet ackea solo las que NO son
    // movement-during-pause — para esas el chofer responde con los
    // botones especificos en el banner principal (MC-016). El sheet
    // sigue mostrando todas las alertas con su render distintivo.
    final otherIds = items
        .where((a) => !isMovementDuringPause(
              alertType: a.alertType,
              ruleType: a.ruleType,
            ))
        .map((a) => a.id)
        .toList();
    final hayMovement = otherIds.length != items.length;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                'Alertas pendientes (${items.length})',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 24),
                itemBuilder: (_, i) => _DetalleAlerta(alert: items[i]),
              ),
            ),
            if (hayMovement) ...[
              const SizedBox(height: 12),
              Text(
                'Las alertas de "Movimiento en pausa" se confirman desde '
                'el banner principal (¿Fuiste vos? / No fui yo).',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 14),
            if (otherIds.isNotEmpty)
              FilledButton.icon(
                onPressed: state.acking
                    ? null
                    : () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        final ok = await ref
                            .read(pendingActionNotifierProvider(tripId)
                                .notifier)
                            .acknowledge(tripId, otherIds);
                        if (!context.mounted) return;
                        navigator.pop();
                        if (ok) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                otherIds.length == 1
                                    ? 'Alerta marcada como atendida'
                                    : '${otherIds.length} alertas marcadas como atendidas',
                              ),
                            ),
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'No pudimos confirmar — verificá tu conexión y reintentá',
                              ),
                            ),
                          );
                        }
                      },
                icon: state.acking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  state.acking
                      ? 'Confirmando...'
                      : (otherIds.length == 1
                          ? 'Recibido — atender alerta'
                          : 'Recibido — atender ${otherIds.length} alertas'),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Una entrada del bottom-sheet de detalles. Más detallada que la fila
/// del banner: incluye `message` del backend completo + timestamp
/// formateado largo.
class _DetalleAlerta extends StatelessWidget {
  const _DetalleAlerta({required this.alert});
  final TrackingAlert alert;

  @override
  Widget build(BuildContext context) {
    final tipoStyle = alertHeaderStyle(
      alertType: alert.alertType,
      ruleType: alert.ruleType,
    );
    final nivelStyle = escalationStyle(alert.escalationLevel);
    final subtitulo = alertSubtitle(
      alertType: alert.alertType,
      ruleType: alert.ruleType,
      extra: alert.extra,
    );
    final titulo = _tituloCorto(alert);
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tipoStyle.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(tipoStyle.icon, color: tipoStyle.color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    tipoStyle.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (nivelStyle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: nivelStyle.color.withValues(alpha: 0.15),
                        border: Border.all(
                          color: nivelStyle.color.withValues(alpha: 0.55),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${nivelStyle.label} · ${nivelStyle.descripcion}',
                        style: TextStyle(
                          color: nivelStyle.color,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              if (titulo.isNotEmpty)
                Text(
                  titulo,
                  style: theme.textTheme.bodyMedium,
                ),
              if (alert.message != null && alert.message!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  alert.message!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
              if (subtitulo != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    subtitulo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                DateFormat('dd/MM HH:mm').format(alert.createdAt.toLocal()),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Título corto y descriptivo de una alerta, parseando `extra` cuando
/// está disponible para mostrar contexto numérico (velocidad, minutos
/// detenido, distancia fuera de ruta). Devuelve string vacío si el
/// helper no tiene un texto especifico para el tipo — el caller usa el
/// `tipoStyle.label` como fallback.
String _tituloCorto(TrackingAlert a) {
  final extra = a.extra ?? const {};
  switch (a.alertType.toUpperCase()) {
    case 'EXCESO_VELOCIDAD':
      final speed = extra['speed'];
      final limit = extra['limit'];
      if (speed != null && limit != null) {
        return '${_int(speed)} km/h (límite ${_int(limit)})';
      }
      return '';
    case 'DETENCION_PROLONGADA':
      final mins = extra['minutes'] ?? extra['duration_min'];
      return mins != null ? '${_int(mins)} min sin movimiento' : '';
    case 'DESVIO_HORARIO':
      return 'Atraso del horario planificado';
    case 'DESVIO':
      final dist = a.distToRouteM;
      return dist != null ? '${_int(dist)} m fuera del trazado' : '';
    case 'SIN_SENAL':
      return 'Sin reporte del rastreador satelital';
    case 'TRAFICO':
      return 'Tráfico / incidente reportado';
    case 'PARADA_COMER':
      return 'Parada para comer';
    case 'AVERIA':
      return 'Avería del vehículo';
    case 'ACCIDENTE':
      return 'Accidente';
    default:
      return '';
  }
}

String _int(Object value) {
  if (value is num) return value.round().toString();
  return value.toString();
}
