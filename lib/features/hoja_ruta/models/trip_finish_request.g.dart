// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_finish_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripFinishRequestImpl _$$TripFinishRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TripFinishRequestImpl(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      maxDistanceM: (json['max_distance_m'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TripFinishRequestImplToJson(
        _$TripFinishRequestImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'max_distance_m': instance.maxDistanceM,
    };
