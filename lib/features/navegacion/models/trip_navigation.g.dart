// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripNavigationImpl _$$TripNavigationImplFromJson(Map<String, dynamic> json) =>
    _$TripNavigationImpl(
      tripId: json['trip_id'] as String,
      computedAt: DateTime.parse(json['computed_at'] as String),
      routingEngine: json['routing_engine'] as String? ?? 'osrm',
      totalDistanceM: (json['total_distance_m'] as num?)?.toDouble() ?? 0.0,
      totalDurationS: (json['total_duration_s'] as num?)?.toDouble() ?? 0.0,
      geometry:
          GeoJsonLineString.fromJson(json['geometry'] as Map<String, dynamic>),
      legs: (json['legs'] as List<dynamic>?)
              ?.map((e) => NavigationLeg.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TripNavigationImplToJson(
        _$TripNavigationImpl instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'computed_at': instance.computedAt.toIso8601String(),
      'routing_engine': instance.routingEngine,
      'total_distance_m': instance.totalDistanceM,
      'total_duration_s': instance.totalDurationS,
      'geometry': instance.geometry,
      'legs': instance.legs,
    };

_$GeoJsonLineStringImpl _$$GeoJsonLineStringImplFromJson(
        Map<String, dynamic> json) =>
    _$GeoJsonLineStringImpl(
      type: json['type'] as String? ?? 'LineString',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GeoJsonLineStringImplToJson(
        _$GeoJsonLineStringImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

_$NavigationLegImpl _$$NavigationLegImplFromJson(Map<String, dynamic> json) =>
    _$NavigationLegImpl(
      target: json['target'] as String,
      targetIndex: (json['target_index'] as num?)?.toInt(),
      targetLabel: json['target_label'] as String? ?? '',
      targetLat: (json['target_lat'] as num?)?.toDouble() ?? 0.0,
      targetLon: (json['target_lon'] as num?)?.toDouble() ?? 0.0,
      distanceM: (json['distance_m'] as num?)?.toDouble() ?? 0.0,
      durationS: (json['duration_s'] as num?)?.toDouble() ?? 0.0,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => NavigationStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NavigationLegImplToJson(_$NavigationLegImpl instance) =>
    <String, dynamic>{
      'target': instance.target,
      'target_index': instance.targetIndex,
      'target_label': instance.targetLabel,
      'target_lat': instance.targetLat,
      'target_lon': instance.targetLon,
      'distance_m': instance.distanceM,
      'duration_s': instance.durationS,
      'steps': instance.steps,
    };

_$NavigationStepImpl _$$NavigationStepImplFromJson(Map<String, dynamic> json) =>
    _$NavigationStepImpl(
      distanceM: (json['distance_m'] as num?)?.toDouble() ?? 0.0,
      durationS: (json['duration_s'] as num?)?.toDouble() ?? 0.0,
      roadName: json['road_name'] as String?,
      geometry:
          GeoJsonLineString.fromJson(json['geometry'] as Map<String, dynamic>),
      maneuver:
          NavigationManeuver.fromJson(json['maneuver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NavigationStepImplToJson(
        _$NavigationStepImpl instance) =>
    <String, dynamic>{
      'distance_m': instance.distanceM,
      'duration_s': instance.durationS,
      'road_name': instance.roadName,
      'geometry': instance.geometry,
      'maneuver': instance.maneuver,
    };

_$NavigationManeuverImpl _$$NavigationManeuverImplFromJson(
        Map<String, dynamic> json) =>
    _$NavigationManeuverImpl(
      location: (json['location'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      type: json['type'] as String? ?? '',
      modifier: json['modifier'] as String?,
      bearingBefore: (json['bearing_before'] as num?)?.toDouble() ?? 0.0,
      bearingAfter: (json['bearing_after'] as num?)?.toDouble() ?? 0.0,
      exit: (json['exit'] as num?)?.toInt(),
      instructionEs: json['instruction_es'] as String? ?? '',
    );

Map<String, dynamic> _$$NavigationManeuverImplToJson(
        _$NavigationManeuverImpl instance) =>
    <String, dynamic>{
      'location': instance.location,
      'type': instance.type,
      'modifier': instance.modifier,
      'bearing_before': instance.bearingBefore,
      'bearing_after': instance.bearingAfter,
      'exit': instance.exit,
      'instruction_es': instance.instructionEs,
    };
