// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripMessageImpl _$$TripMessageImplFromJson(Map<String, dynamic> json) =>
    _$TripMessageImpl(
      id: (json['id'] as num).toInt(),
      tripId: json['trip_id'] as String,
      senderRole: json['sender_role'] as String,
      senderUserId: json['sender_user_id'] as String?,
      senderName: json['sender_name'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      alertId: (json['alert_id'] as num?)?.toInt(),
      alert: json['alert'] == null
          ? null
          : MessageAlertRef.fromJson(json['alert'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TripMessageImplToJson(_$TripMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'sender_role': instance.senderRole,
      'sender_user_id': instance.senderUserId,
      'sender_name': instance.senderName,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'alert_id': instance.alertId,
      'alert': instance.alert,
    };
