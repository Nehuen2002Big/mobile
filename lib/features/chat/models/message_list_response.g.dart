// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageListResponseImpl _$$MessageListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageListResponseImpl(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TripMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      unreadForDriver: (json['unread_for_driver'] as num?)?.toInt() ?? 0,
      unreadForMonitor: (json['unread_for_monitor'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MessageListResponseImplToJson(
        _$MessageListResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'unread_for_driver': instance.unreadForDriver,
      'unread_for_monitor': instance.unreadForMonitor,
    };
