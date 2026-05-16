import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_finish_request.freezed.dart';
part 'trip_finish_request.g.dart';

@freezed
class TripFinishRequest with _$TripFinishRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TripFinishRequest({
    required double lat,
    required double lon,
    double? maxDistanceM,
  }) = _TripFinishRequest;

  factory TripFinishRequest.fromJson(Map<String, dynamic> json) =>
      _$TripFinishRequestFromJson(json);
}
