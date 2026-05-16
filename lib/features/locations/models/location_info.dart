import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_info.freezed.dart';
part 'location_info.g.dart';

/// Ubicacion registrada en isatech_routes. Se usa para resolver los UUIDs
/// que guarda la hoja de ruta en `origin` y `destination`.
@freezed
class LocationInfo with _$LocationInfo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LocationInfo({
    required String id,
    @Default('') String name,
    double? lat,
    double? lon,
  }) = _LocationInfo;

  factory LocationInfo.fromJson(Map<String, dynamic> json) =>
      _$LocationInfoFromJson(json);
}
