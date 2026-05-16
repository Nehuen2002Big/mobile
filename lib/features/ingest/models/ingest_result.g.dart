// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingest_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngestResultImpl _$$IngestResultImplFromJson(Map<String, dynamic> json) =>
    _$IngestResultImpl(
      pointId: (json['point_id'] as num?)?.toInt() ?? 0,
      tripId: json['trip_id'] as String?,
      isOnRoute: json['is_on_route'] as bool? ?? false,
      distToRouteM: (json['dist_to_route_m'] as num?)?.toDouble() ?? 0,
      alertGenerated: json['alert_generated'] as bool? ?? false,
    );

Map<String, dynamic> _$$IngestResultImplToJson(_$IngestResultImpl instance) =>
    <String, dynamic>{
      'point_id': instance.pointId,
      'trip_id': instance.tripId,
      'is_on_route': instance.isOnRoute,
      'dist_to_route_m': instance.distToRouteM,
      'alert_generated': instance.alertGenerated,
    };
