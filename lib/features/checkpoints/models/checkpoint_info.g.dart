// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckpointInfoImpl _$$CheckpointInfoImplFromJson(Map<String, dynamic> json) =>
    _$CheckpointInfoImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      actionType: json['action_type'] as String?,
      cargoDescription: json['cargo_description'] as String?,
      notes: json['notes'] as String?,
      reached: json['reached'] as bool? ?? false,
      reachedAt: json['reached_at'] == null
          ? null
          : DateTime.parse(json['reached_at'] as String),
      reachedLat: (json['reached_lat'] as num?)?.toDouble(),
      reachedLon: (json['reached_lon'] as num?)?.toDouble(),
      distanceToCheckpointM:
          (json['distance_to_checkpoint_m'] as num?)?.toDouble(),
      markedByUserId: json['marked_by_user_id'] as String?,
      reachNotes: json['reach_notes'] as String?,
      reachEvidences: (json['reach_evidences'] as List<dynamic>?)
              ?.map(
                  (e) => CheckpointEvidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CheckpointInfoImplToJson(
        _$CheckpointInfoImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'action_type': instance.actionType,
      'cargo_description': instance.cargoDescription,
      'notes': instance.notes,
      'reached': instance.reached,
      'reached_at': instance.reachedAt?.toIso8601String(),
      'reached_lat': instance.reachedLat,
      'reached_lon': instance.reachedLon,
      'distance_to_checkpoint_m': instance.distanceToCheckpointM,
      'marked_by_user_id': instance.markedByUserId,
      'reach_notes': instance.reachNotes,
      'reach_evidences': instance.reachEvidences,
    };
