// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckpointListResponseImpl _$$CheckpointListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckpointListResponseImpl(
      tripId: json['trip_id'] as String,
      checkpoints: (json['checkpoints'] as List<dynamic>?)
              ?.map((e) => CheckpointInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextCheckpointIndex: (json['next_checkpoint_index'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      reachedCount: (json['reached_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CheckpointListResponseImplToJson(
        _$CheckpointListResponseImpl instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'checkpoints': instance.checkpoints,
      'next_checkpoint_index': instance.nextCheckpointIndex,
      'total': instance.total,
      'reached_count': instance.reachedCount,
    };
