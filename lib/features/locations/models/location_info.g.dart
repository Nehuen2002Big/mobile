// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationInfoImpl _$$LocationInfoImplFromJson(Map<String, dynamic> json) =>
    _$LocationInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$LocationInfoImplToJson(_$LocationInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
    };
