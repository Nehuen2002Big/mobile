import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_location_request.freezed.dart';
part 'phone_location_request.g.dart';

/// Body para POST /api/v1/trips/{trip_id}/phone-location.
/// Reporta la ubicacion del TELEFONO del chofer (distinta del dispositivo
/// satelital del camion). No dispara alertas ni cuenta para progreso.
@freezed
class PhoneLocationRequest with _$PhoneLocationRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PhoneLocationRequest({
    required double lat,
    required double lon,
    double? speedKmh,
    DateTime? recordedAt,
  }) = _PhoneLocationRequest;

  factory PhoneLocationRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneLocationRequestFromJson(json);
}
