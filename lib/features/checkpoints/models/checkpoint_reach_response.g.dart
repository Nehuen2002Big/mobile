// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_reach_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckpointReachResponseImpl _$$CheckpointReachResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckpointReachResponseImpl(
      tripId: json['trip_id'] as String,
      checkpointIndex: (json['checkpoint_index'] as num).toInt(),
      reachedAt: DateTime.parse(json['reached_at'] as String),
      distanceToCheckpointM:
          (json['distance_to_checkpoint_m'] as num).toDouble(),
      nextCheckpointIndex: (json['next_checkpoint_index'] as num?)?.toInt(),
      allDone: json['all_done'] as bool? ?? false,
    );

Map<String, dynamic> _$$CheckpointReachResponseImplToJson(
        _$CheckpointReachResponseImpl instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'checkpoint_index': instance.checkpointIndex,
      'reached_at': instance.reachedAt.toIso8601String(),
      'distance_to_checkpoint_m': instance.distanceToCheckpointM,
      'next_checkpoint_index': instance.nextCheckpointIndex,
      'all_done': instance.allDone,
    };
