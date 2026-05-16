// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneLocationResponseImpl _$$PhoneLocationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PhoneLocationResponseImpl(
      pointId: (json['point_id'] as num?)?.toInt() ?? 0,
      tripId: json['trip_id'] as String,
      source: json['source'] as String? ?? 'PHONE',
    );

Map<String, dynamic> _$$PhoneLocationResponseImplToJson(
        _$PhoneLocationResponseImpl instance) =>
    <String, dynamic>{
      'point_id': instance.pointId,
      'trip_id': instance.tripId,
      'source': instance.source,
    };
