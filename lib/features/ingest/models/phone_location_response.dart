import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_location_response.freezed.dart';
part 'phone_location_response.g.dart';

@freezed
class PhoneLocationResponse with _$PhoneLocationResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PhoneLocationResponse({
    @Default(0) int pointId,
    required String tripId,
    @Default('PHONE') String source,
  }) = _PhoneLocationResponse;

  factory PhoneLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$PhoneLocationResponseFromJson(json);
}
