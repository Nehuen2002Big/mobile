// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      imei: json['imei'] as String? ?? '',
      routeId: json['route_id'] as String?,
      vehicleId: (json['vehicle_id'] as num?)?.toInt(),
      driverPersonId: json['driver_person_id'] as String?,
      status: $enumDecodeNullable(_$TripStatusEnumMap, json['status'],
              unknownValue: TripStatus.unknown) ??
          TripStatus.unknown,
      thresholdM: (json['threshold_m'] as num?)?.toDouble(),
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      activeAlerts: (json['active_alerts'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      finishedAt: json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at'] as String),
      originLat: (json['origin_lat'] as num?)?.toDouble(),
      originLon: (json['origin_lon'] as num?)?.toDouble(),
      destinationLat: (json['destination_lat'] as num?)?.toDouble(),
      destinationLon: (json['destination_lon'] as num?)?.toDouble(),
      maxRouteProgressM:
          (json['max_route_progress_m'] as num?)?.toDouble() ?? 0.0,
      routeTotalM: (json['route_total_m'] as num?)?.toDouble(),
      params: json['params'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imei': instance.imei,
      'route_id': instance.routeId,
      'vehicle_id': instance.vehicleId,
      'driver_person_id': instance.driverPersonId,
      'status': _$TripStatusEnumMap[instance.status]!,
      'threshold_m': instance.thresholdM,
      'total_points': instance.totalPoints,
      'active_alerts': instance.activeAlerts,
      'created_at': instance.createdAt?.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
      'origin_lat': instance.originLat,
      'origin_lon': instance.originLon,
      'destination_lat': instance.destinationLat,
      'destination_lon': instance.destinationLon,
      'max_route_progress_m': instance.maxRouteProgressM,
      'route_total_m': instance.routeTotalM,
      'params': instance.params,
    };

const _$TripStatusEnumMap = {
  TripStatus.pending: 'PENDING',
  TripStatus.active: 'ACTIVE',
  TripStatus.finished: 'FINISHED',
  TripStatus.cancelled: 'CANCELLED',
  TripStatus.unknown: 'unknown',
};
