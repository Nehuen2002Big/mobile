import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_progress_response.freezed.dart';
part 'route_progress_response.g.dart';

@freezed
class RouteProgressResponse with _$RouteProgressResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RouteProgressResponse({
    required String tripId,
    double? routeTotalM,
    @Default(0.0) double progressM,
    @Default(0.0) double progressPct,
    @Default([]) List<List<double>> completedGeometry,
    @Default([]) List<List<double>> remainingGeometry,
    // Campos de turn-by-turn (null si no hay nav computado).
    int? currentLegIndex,
    int? currentStepIndex,
    double? distanceToNextManeuverM,
    double? distanceToCurrentTargetM,
    double? distanceToDestinationM,
    bool? isOnRoute,
  }) = _RouteProgressResponse;

  factory RouteProgressResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteProgressResponseFromJson(json);
}
