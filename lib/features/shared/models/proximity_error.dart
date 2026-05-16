import 'package:freezed_annotation/freezed_annotation.dart';

part 'proximity_error.freezed.dart';
part 'proximity_error.g.dart';

/// Detalle de error 422 cuando una accion que requiere proximidad (POST /start,
/// POST /reach) rechaza al chofer por no estar cerca del punto esperado.
///
/// `source` dice quien fallo:
///   - "phone"  → GPS del telefono (lo que manda la app).
///   - "device" → GPS del satelital del camion (lo que reporta el dispositivo).
///
/// `error` codifica la razon especifica:
///   - phone_too_far_from_origin
///   - phone_too_far_from_checkpoint
///   - device_signal_missing
///   - device_too_far_from_origin
///   - device_too_far_from_checkpoint
@freezed
class ProximityError with _$ProximityError {
  const ProximityError._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProximityError({
    @Default('unknown') String error,
    @Default('unknown') String source,
    double? distanceM,
    double? maxDistanceM,
    @Default('') String message,
  }) = _ProximityError;

  bool get esFallaTelefono => source == 'phone';
  bool get esFallaSatelital => source == 'device';
  bool get esSinSenalSatelital => error == 'device_signal_missing';

  factory ProximityError.fromJson(Map<String, dynamic> json) =>
      _$ProximityErrorFromJson(json);
}
