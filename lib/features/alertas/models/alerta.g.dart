// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertaPayloadImpl _$$AlertaPayloadImplFromJson(Map<String, dynamic> json) =>
    _$AlertaPayloadImpl(
      alertType: json['alert_type'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      message: json['message'] as String?,
      evidences: (json['evidences'] as List<dynamic>?)
              ?.map(
                  (e) => CheckpointEvidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AlertaPayloadImplToJson(_$AlertaPayloadImpl instance) =>
    <String, dynamic>{
      'alert_type': instance.alertType,
      'lat': instance.lat,
      'lon': instance.lon,
      'message': instance.message,
      'evidences': instance.evidences,
    };
