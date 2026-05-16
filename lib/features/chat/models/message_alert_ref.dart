import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_alert_ref.freezed.dart';
part 'message_alert_ref.g.dart';

/// Referencia a la alerta que auto-posteo este mensaje en el chat. Viene
/// embebida cuando el mensaje tiene `alert_id != null`.
@freezed
class MessageAlertRef with _$MessageAlertRef {
  const MessageAlertRef._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MessageAlertRef({
    required int id,
    required String alertType,
    @Default([]) List<MessageAlertEvidence> evidences,
    /// Tipo de regla del backend que disparo la alerta (HIGH_SPEED,
    /// LONG_STOP, SCHEDULE_DEVIATION, OFF_ROUTE, DEVICE_OFFLINE).
    /// null para alertas del chofer (TRAFICO/PARADA_COMER/AVERIA/ACCIDENTE).
    String? ruleType,
    /// "L1" | "L2" | "L3" segun el nivel configurado en road sheet.
    String? escalationLevel,
    DateTime? escalatedAt,
    /// Datos extra de contexto: ej. {"speed":120,"limit":80} para HIGH_SPEED.
    Map<String, dynamic>? extra,
    /// `true` si la alerta fue generada por el simulador de QA del
    /// operador. Renderiza identico a una real para validar el flow
    /// end-to-end; solo usar este flag para debug local.
    @Default(false) bool simulated,
  }) = _MessageAlertRef;

  bool get esL1 => escalationLevel == 'L1';
  bool get esL2 => escalationLevel == 'L2';
  bool get esL3 => escalationLevel == 'L3';

  factory MessageAlertRef.fromJson(Map<String, dynamic> json) =>
      _$MessageAlertRefFromJson(json);
}

/// Evidencia adjunta a la alerta (IMAGE o TEXT). Las IMAGE llevan `fileUrl`
/// relativo (ej. "/api/v1/uploads/evidence/{trip_id}/xxx.jpg").
@freezed
class MessageAlertEvidence with _$MessageAlertEvidence {
  const MessageAlertEvidence._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MessageAlertEvidence({
    required int id,
    required String evidenceType,
    String? fileUrl,
    String? description,
    DateTime? createdAt,
  }) = _MessageAlertEvidence;

  bool get esImagen =>
      evidenceType == 'IMAGE' && (fileUrl != null && fileUrl!.isNotEmpty);

  factory MessageAlertEvidence.fromJson(Map<String, dynamic> json) =>
      _$MessageAlertEvidenceFromJson(json);
}
