// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageCreateRequestImpl _$$MessageCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageCreateRequestImpl(
      senderRole: json['sender_role'] as String,
      senderName: json['sender_name'] as String?,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$MessageCreateRequestImplToJson(
        _$MessageCreateRequestImpl instance) =>
    <String, dynamic>{
      'sender_role': instance.senderRole,
      'sender_name': instance.senderName,
      'content': instance.content,
    };
