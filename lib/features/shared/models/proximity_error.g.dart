// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proximity_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProximityErrorImpl _$$ProximityErrorImplFromJson(Map<String, dynamic> json) =>
    _$ProximityErrorImpl(
      error: json['error'] as String? ?? 'unknown',
      source: json['source'] as String? ?? 'unknown',
      distanceM: (json['distance_m'] as num?)?.toDouble(),
      maxDistanceM: (json['max_distance_m'] as num?)?.toDouble(),
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$$ProximityErrorImplToJson(
        _$ProximityErrorImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'source': instance.source,
      'distance_m': instance.distanceM,
      'max_distance_m': instance.maxDistanceM,
      'message': instance.message,
    };
