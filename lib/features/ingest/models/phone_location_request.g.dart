// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_location_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneLocationRequestImpl _$$PhoneLocationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PhoneLocationRequestImpl(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      speedKmh: (json['speed_kmh'] as num?)?.toDouble(),
      recordedAt: json['recorded_at'] == null
          ? null
          : DateTime.parse(json['recorded_at'] as String),
    );

Map<String, dynamic> _$$PhoneLocationRequestImplToJson(
        _$PhoneLocationRequestImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'speed_kmh': instance.speedKmh,
      'recorded_at': instance.recordedAt?.toIso8601String(),
    };
