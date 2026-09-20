// Seccion "Checklist de salida" del viaje (MC-022).
//
// Card con header + progress bar + lista de checkboxes. El chofer
// tilda items para confirmar la verificacion de salida; el boton
// "Iniciar viaje" del ViajePendienteCard queda bloqueado hasta que
// `checklist.completed == true`.
//
// Se renderiza cuando el trip esta PENDIENTE o ACTIVO y el checklist
// tiene al menos un item. Para viajes pre-MC-022 sin checklist
// definido, el snapshot trae `items: []` y la seccion se autocolapsa.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../ui/theme/app_theme.dart' show IsaColors;
import '../models/trip_checklist.dart';
import '../state/trip_checklist_state.dart';

class ChecklistSection extends ConsumerStatefulWidget {
  const ChecklistSection({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<ChecklistSection> createState() => _ChecklistSectionState();
}

class _ChecklistSectionState extends ConsumerState<ChecklistSection> {
  @override
  void initState() {
    super.initState();
    // Mostrar errores de permiso/estado como SnackBar. Errores de red
    // no tocan `state.error` (el toggle se encola silenciosamente).
    ref.listenManual<TripChecklistState>(
      tripChecklistNotifierProvider(widget.tripId),
      (prev, next) {
        final msg = next.error;
        if (msg == null || msg == prev?.error) return;
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripChecklistNotifierProvider(widget.tripId));
    final checklist = state.checklist;

    if (state.loading && checklist.items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Cargando checklist...'),
            ],
          ),
        ),
      );
    }

    if (checklist.isEmpty) {
      // Viaje sin checklist definido (legacy o el operador no agrego items).
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(checklist: checklist),
            const SizedBox(height: 12),
            _ProgressBar(checklist: checklist),
            const SizedBox(height: 4),
            for (final item in checklist.items)
              _ChecklistTile(
                tripId: widget.tripId,
                item: item,
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.checklist});

  final TripChecklist checklist;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.checklist_rtl, color: scheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Checklist de salida',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Text(
          '${checklist.completedCount} / ${checklist.totalCount}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: checklist.completed
                    ? IsaColors.emerald400
                    : scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.checklist});

  final TripChecklist checklist;

  @override
  Widget build(BuildContext context) {
    final fraction = checklist.totalCount == 0
        ? 0.0
        : checklist.completedCount / checklist.totalCount;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: fraction,
        minHeight: 6,
        backgroundColor: IsaColors.zinc800,
        valueColor: AlwaysStoppedAnimation<Color>(
          checklist.completed ? IsaColors.emerald400 : IsaColors.cyan400,
        ),
      ),
    );
  }
}

class _ChecklistTile extends ConsumerWidget {
  const _ChecklistTile({required this.tripId, required this.item});

  final String tripId;
  final ChecklistItem item;

  Future<void> _onToggle(WidgetRef ref) async {
    await HapticFeedback.lightImpact();
    await ref
        .read(tripChecklistNotifierProvider(tripId).notifier)
        .toggle(tripId, item.key);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final relativo = _stampRelativo(item.checkedAt);
    return InkWell(
      onTap: () => _onToggle(ref),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usamos un Checkbox para tener el toggle nativo con
            // ripple/animacion. El tap del Row entero tambien lo
            // dispara (mejor target en mobile con guantes).
            SizedBox(
              height: 28,
              width: 28,
              child: Checkbox(
                value: item.checked,
                onChanged: (_) => _onToggle(ref),
                visualDensity: VisualDensity.compact,
                activeColor: IsaColors.emerald500,
                checkColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: item.checked
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                          fontWeight:
                              item.checked ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                  if (item.checked && relativo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Marcado $relativo',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Devuelve una etiqueta corta como "hace 2 min", "hace 1 h", "ahora".
/// `null` si no hay timestamp.
String? _stampRelativo(DateTime? stampUtc) {
  if (stampUtc == null) return null;
  final delta = DateTime.now().toUtc().difference(stampUtc);
  if (delta.inSeconds < 30) return 'ahora';
  if (delta.inMinutes < 1) return 'hace ${delta.inSeconds} s';
  if (delta.inHours < 1) return 'hace ${delta.inMinutes} min';
  if (delta.inDays < 1) return 'hace ${delta.inHours} h';
  return 'hace ${delta.inDays} d';
}
