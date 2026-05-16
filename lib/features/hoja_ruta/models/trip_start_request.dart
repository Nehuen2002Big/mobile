import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_start_request.freezed.dart';
part 'trip_start_request.g.dart';

@freezed
class TripStartRequest with _$TripStartRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TripStartRequest({
    required double lat,
    required double lon,
    double? maxDistanceM,
  }) = _TripStartRequest;

  factory TripStartRequest.fromJson(Map<String, dynamic> json) =>
      _$TripStartRequestFromJson(json);
}
