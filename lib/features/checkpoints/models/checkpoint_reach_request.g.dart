// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_reach_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckpointReachRequestImpl _$$CheckpointReachRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckpointReachRequestImpl(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      notes: json['notes'] as String?,
      evidences: (json['evidences'] as List<dynamic>?)
              ?.map(
                  (e) => CheckpointEvidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      maxDistanceM: (json['max_distance_m'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CheckpointReachRequestImplToJson(
        _$CheckpointReachRequestImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'notes': instance.notes,
      'evidences': instance.evidences,
      'max_distance_m': instance.maxDistanceM,
    };
