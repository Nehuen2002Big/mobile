// Modelo plano del checklist de salida (MC-022).
//
// El backend lo expone via:
//   GET  /trips/{id}/checklist
//   POST /trips/{id}/checklist/items/{key}/check
//   POST /trips/{id}/checklist/items/{key}/uncheck
//
// Se mantiene plano (no @freezed) para evitar pasar por build_runner,
// siguiendo el patron de TripPauseStatus / OperatorDirective.

import 'package:flutter/foundation.dart';

/// Un item del checklist de salida. `key` lo arma el operador al crear
/// la hoja de ruta y es el identificador estable que la app usa para
/// llamar a /check y /uncheck. `label` es el texto visible al chofer.
@immutable
class ChecklistItem {
  const ChecklistItem({
    required this.key,
    required this.label,
    required this.checked,
    this.checkedAt,
    this.checkedBy,
  });

  /// Identificador estable del item (ej. "docs", "secure-cargo").
  final String key;

  /// Texto visible al chofer (ej. "Documentacion", "Carga asegurada").
  final String label;

  /// `true` si el chofer ya tildo este item.
  final bool checked;

  /// Cuando se tildo (UTC). `null` cuando `checked == false`.
  final DateTime? checkedAt;

  /// person_id del chofer que tildo. `null` cuando `checked == false`.
  /// Hoy solo se usa para mostrar timestamps relativos; el server ya
  /// gatea que solo el chofer asignado pueda tildar.
  final String? checkedBy;

  ChecklistItem copyWith({
    bool? checked,
    DateTime? checkedAt,
    String? checkedBy,
    bool clearMeta = false,
  }) {
    return ChecklistItem(
      key: key,
      label: label,
      checked: checked ?? this.checked,
      checkedAt: clearMeta ? null : (checkedAt ?? this.checkedAt),
      checkedBy: clearMeta ? null : (checkedBy ?? this.checkedBy),
    );
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? raw) {
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw)?.toUtc();
      }
      return null;
    }

    return ChecklistItem(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      checked: json['checked'] as bool? ?? false,
      checkedAt: parseDate(json['checked_at']),
      checkedBy: json['checked_by'] as String?,
    );
  }
}

/// Snapshot completo del checklist de un viaje. Es la respuesta del
/// GET /trips/{id}/checklist y la fuente de verdad inicial para la UI.
/// Una vez cargado, el notifier mantiene `items` actualizado y
/// recalcula `completed/_count` localmente despues de cada toggle.
@immutable
class TripChecklist {
  const TripChecklist({
    required this.tripId,
    required this.items,
    required this.completed,
    required this.completedCount,
    required this.totalCount,
  });

  final String tripId;
  final List<ChecklistItem> items;
  final bool completed;
  final int completedCount;
  final int totalCount;

  /// Checklist sin items definidos. Tratamos `totalCount == 0` como
  /// "no hay checklist" → no bloquea iniciar el viaje y la seccion no
  /// se renderiza. Cubre el caso de viajes viejos pre-MC-022 que el
  /// backend devuelve con items vacios.
  bool get isEmpty => totalCount == 0;

  /// `true` cuando hay items y todos estan tildados. El boton "Iniciar
  /// viaje" se desbloquea con esta bandera. Para viajes sin checklist
  /// definido tambien devuelve `true` (no debe bloquear nada).
  bool get permiteIniciar => isEmpty || completed;

  TripChecklist copyWithItems(List<ChecklistItem> nuevos) {
    final done = nuevos.where((it) => it.checked).length;
    return TripChecklist(
      tripId: tripId,
      items: nuevos,
      completedCount: done,
      totalCount: nuevos.length,
      completed: nuevos.isNotEmpty && done == nuevos.length,
    );
  }

  /// Reemplaza un item por su key y recalcula contadores.
  TripChecklist withItem(ChecklistItem nuevo) {
    final nuevos = [
      for (final it in items)
        if (it.key == nuevo.key) nuevo else it,
    ];
    return copyWithItems(nuevos);
  }

  factory TripChecklist.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = (rawItems is List)
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ChecklistItem.fromJson)
            .toList()
        : <ChecklistItem>[];
    final completedCount = json['completed_count'] as int? ??
        items.where((it) => it.checked).length;
    final totalCount = json['total_count'] as int? ?? items.length;
    final completed = json['completed'] as bool? ??
        (items.isNotEmpty && completedCount == totalCount);
    return TripChecklist(
      tripId: json['trip_id'] as String? ?? '',
      items: items,
      completed: completed,
      completedCount: completedCount,
      totalCount: totalCount,
    );
  }

  /// Checklist vacio. Util como estado inicial del notifier antes del
  /// primer fetch y como "no hay checklist" para viajes viejos.
  factory TripChecklist.empty(String tripId) => TripChecklist(
        tripId: tripId,
        items: const [],
        completed: false,
        completedCount: 0,
        totalCount: 0,
      );
}
