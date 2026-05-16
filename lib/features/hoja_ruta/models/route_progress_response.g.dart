// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_progress_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteProgressResponseImpl _$$RouteProgressResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RouteProgressResponseImpl(
      tripId: json['trip_id'] as String,
      routeTotalM: (json['route_total_m'] as num?)?.toDouble(),
      progressM: (json['progress_m'] as num?)?.toDouble() ?? 0.0,
      progressPct: (json['progress_pct'] as num?)?.toDouble() ?? 0.0,
      completedGeometry: (json['completed_geometry'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          const [],
      remainingGeometry: (json['remaining_geometry'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          const [],
      currentLegIndex: (json['current_leg_index'] as num?)?.toInt(),
      currentStepIndex: (json['current_step_index'] as num?)?.toInt(),
      distanceToNextManeuverM:
          (json['distance_to_next_maneuver_m'] as num?)?.toDouble(),
      distanceToCurrentTargetM:
          (json['distance_to_current_target_m'] as num?)?.toDouble(),
      distanceToDestinationM:
          (json['distance_to_destination_m'] as num?)?.toDouble(),
      isOnRoute: json['is_on_route'] as bool?,
    );

Map<String, dynamic> _$$RouteProgressResponseImplToJson(
        _$RouteProgressResponseImpl instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'route_total_m': instance.routeTotalM,
      'progress_m': instance.progressM,
      'progress_pct': instance.progressPct,
      'completed_geometry': instance.completedGeometry,
      'remaining_geometry': instance.remainingGeometry,
      'current_leg_index': instance.currentLegIndex,
      'current_step_index': instance.currentStepIndex,
      'distance_to_next_maneuver_m': instance.distanceToNextManeuverM,
      'distance_to_current_target_m': instance.distanceToCurrentTargetM,
      'distance_to_destination_m': instance.distanceToDestinationM,
      'is_on_route': instance.isOnRoute,
    };
