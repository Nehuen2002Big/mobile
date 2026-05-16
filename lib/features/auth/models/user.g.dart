// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String?,
      userType: json['user_type'] as String? ?? '',
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'user_type': instance.userType,
      'roles': instance.roles,
    };
