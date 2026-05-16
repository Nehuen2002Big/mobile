import 'package:freezed_annotation/freezed_annotation.dart';

import '../../uploads/models/checkpoint_evidence.dart';

part 'checkpoint_info.freezed.dart';
part 'checkpoint_info.g.dart';

/// action_type en backend: "rest" | "delivery" | "pickup" | "stop" | null
enum CheckpointAction {
  rest,
  delivery,
  pickup,
  stop,
  otro;

  static CheckpointAction? parse(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'rest':
        return CheckpointAction.rest;
      case 'delivery':
        return CheckpointAction.delivery;
      case 'pickup':
        return CheckpointAction.pickup;
      case 'stop':
        return CheckpointAction.stop;
      case null:
      case '':
        return null;
      default:
        return CheckpointAction.otro;
    }
  }

  String get label {
    switch (this) {
      case CheckpointAction.rest:
        return 'Descanso';
      case CheckpointAction.delivery:
        return 'Entrega';
      case CheckpointAction.pickup:
        return 'Retiro';
      case CheckpointAction.stop:
        return 'Parada';
      case CheckpointAction.otro:
        return 'Parada';
    }
  }
}

@freezed
class CheckpointInfo with _$CheckpointInfo {
  const CheckpointInfo._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CheckpointInfo({
    required int index,
    String? name,
    double? lat,
    double? lon,
    String? actionType,
    String? cargoDescription,
    String? notes,
    @Default(false) bool reached,
    DateTime? reachedAt,
    double? reachedLat,
    double? reachedLon,
    double? distanceToCheckpointM,
    String? markedByUserId,
    String? reachNotes,
    @Default([]) List<CheckpointEvidence> reachEvidences,
  }) = _CheckpointInfo;

  CheckpointAction? get accion => CheckpointAction.parse(actionType);

  /// Label del tipo de accion (siempre texto aunque `actionType` sea null).
  String get accionLabel => accion?.label ?? 'Parada';

  factory CheckpointInfo.fromJson(Map<String, dynamic> json) =>
      _$CheckpointInfoFromJson(json);
}
