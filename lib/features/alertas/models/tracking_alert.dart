import 'package:freezed_annotation/freezed_annotation.dart';

import '../../chat/models/message_alert_ref.dart';

part 'tracking_alert.freezed.dart';
part 'tracking_alert.g.dart';

/// Shape canonico de una alerta del backend de tracking. Lo devuelve
/// `GET /trips/{id}/alerts/pending-action` y `GET /trips/{id}/alerts`.
/// Contiene los nuevos campos de reglas + escalamiento (rule_type,
/// escalation_level, extra) que se introdujeron con el protocolo de
/// alertas L1/L2/L3.
@freezed
class TrackingAlert with _$TrackingAlert {
  const TrackingAlert._();

  /// Defensivo: tripId/alertType pueden venir null del backend (regresion
  /// vista en pending-action). En vez de crashear el ack entero, usamos
  /// default vacio y filtramos arriba.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TrackingAlert({
    required int id,
    @Default('') String tripId,
    @Default('') String alertType,
    double? lat,
    double? lon,
    double? distToRouteM,
    String? message,
    required DateTime createdAt,
    DateTime? acknowledgedAt,
    @Default([]) List<MessageAlertEvidence> evidences,
    String? ruleType,
    String? escalationLevel,
    DateTime? escalatedAt,
    Map<String, dynamic>? extra,
    /// `true` cuando el operador genero la alerta desde el simulador de
    /// QA (no es trafico real). La app del chofer la renderiza
    /// **identica a una real** (icono + badge + sonido) para que el
    /// flow de UI se pueda testear end-to-end. El flag esta solo por
    /// si en debug local quisieramos filtrar/loggear distinto — la UI
    /// del chofer NO lo expone.
    @Default(false) bool simulated,
  }) = _TrackingAlert;

  bool get esL2 => escalationLevel == 'L2';
  bool get esL3 => escalationLevel == 'L3';
  bool get esL2oL3 => esL2 || esL3;
  bool get acknowledged => acknowledgedAt != null;

  factory TrackingAlert.fromJson(Map<String, dynamic> json) =>
      _$TrackingAlertFromJson(json);
}

@freezed
class PendingActionAlertsResponse with _$PendingActionAlertsResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PendingActionAlertsResponse({
    @Default([]) List<TrackingAlert> items,
    @Default(0) int total,
  }) = _PendingActionAlertsResponse;

  factory PendingActionAlertsResponse.fromJson(Map<String, dynamic> json) =>
      _$PendingActionAlertsResponseFromJson(json);
}
