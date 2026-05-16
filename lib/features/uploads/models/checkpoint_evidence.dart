import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkpoint_evidence.freezed.dart';
part 'checkpoint_evidence.g.dart';

/// Evidencia adjunta a un checkpoint (o a una alerta). Tipo "IMAGE" lleva
/// `fileUrl` relativo (ej. "/api/v1/uploads/evidence/{trip_id}/xxx.jpg"),
/// tipo "TEXT" lleva `description`.
@freezed
class CheckpointEvidence with _$CheckpointEvidence {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CheckpointEvidence({
    required String evidenceType,
    String? fileUrl,
    String? description,
  }) = _CheckpointEvidence;

  factory CheckpointEvidence.fromJson(Map<String, dynamic> json) =>
      _$CheckpointEvidenceFromJson(json);
}
