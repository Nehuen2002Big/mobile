// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_start_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripStartRequestImpl _$$TripStartRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TripStartRequestImpl(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      maxDistanceM: (json['max_distance_m'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TripStartRequestImplToJson(
        _$TripStartRequestImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'max_distance_m': instance.maxDistanceM,
    };
