import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_alert_ref.dart';

part 'trip_message.freezed.dart';
part 'trip_message.g.dart';

/// Mensaje de un trip (chat driver <-> monitor).
/// `senderRole` = "DRIVER" | "MONITOR".
///
/// Si `alert` no es null, este mensaje fue auto-posteado por el backend
/// cuando el chofer creo una alerta. En ese caso el render debe mostrar
/// badge + fotos inline.
@freezed
class TripMessage with _$TripMessage {
  const TripMessage._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TripMessage({
    required int id,
    required String tripId,
    required String senderRole,
    String? senderUserId,
    String? senderName,
    required String content,
    required DateTime createdAt,
    DateTime? readAt,
    int? alertId,
    MessageAlertRef? alert,
  }) = _TripMessage;

  bool get esPropio => senderRole.toUpperCase() == 'DRIVER';
  bool get leidoPorElOtro => readAt != null;
  bool get esAlerta => alert != null;

  factory TripMessage.fromJson(Map<String, dynamic> json) =>
      _$TripMessageFromJson(json);
}
