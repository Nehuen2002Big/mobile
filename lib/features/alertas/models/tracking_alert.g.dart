// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackingAlertImpl _$$TrackingAlertImplFromJson(Map<String, dynamic> json) =>
    _$TrackingAlertImpl(
      id: (json['id'] as num).toInt(),
      tripId: json['trip_id'] as String? ?? '',
      alertType: json['alert_type'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      distToRouteM: (json['dist_to_route_m'] as num?)?.toDouble(),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      acknowledgedAt: json['acknowledged_at'] == null
          ? null
          : DateTime.parse(json['acknowledged_at'] as String),
      evidences: (json['evidences'] as List<dynamic>?)
              ?.map((e) =>
                  MessageAlertEvidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ruleType: json['rule_type'] as String?,
      escalationLevel: json['escalation_level'] as String?,
      escalatedAt: json['escalated_at'] == null
          ? null
          : DateTime.parse(json['escalated_at'] as String),
      extra: json['extra'] as Map<String, dynamic>?,
      simulated: json['simulated'] as bool? ?? false,
    );

Map<String, dynamic> _$$TrackingAlertImplToJson(_$TrackingAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trip_id': instance.tripId,
      'alert_type': instance.alertType,
      'lat': instance.lat,
      'lon': instance.lon,
      'dist_to_route_m': instance.distToRouteM,
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
      'acknowledged_at': instance.acknowledgedAt?.toIso8601String(),
      'evidences': instance.evidences,
      'rule_type': instance.ruleType,
      'escalation_level': instance.escalationLevel,
      'escalated_at': instance.escalatedAt?.toIso8601String(),
      'extra': instance.extra,
      'simulated': instance.simulated,
    };

_$PendingActionAlertsResponseImpl _$$PendingActionAlertsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PendingActionAlertsResponseImpl(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TrackingAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PendingActionAlertsResponseImplToJson(
        _$PendingActionAlertsResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
    };
