// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_alert_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageAlertRefImpl _$$MessageAlertRefImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageAlertRefImpl(
      id: (json['id'] as num).toInt(),
      alertType: json['alert_type'] as String,
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

Map<String, dynamic> _$$MessageAlertRefImplToJson(
        _$MessageAlertRefImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alert_type': instance.alertType,
      'evidences': instance.evidences,
      'rule_type': instance.ruleType,
      'escalation_level': instance.escalationLevel,
      'escalated_at': instance.escalatedAt?.toIso8601String(),
      'extra': instance.extra,
      'simulated': instance.simulated,
    };

_$MessageAlertEvidenceImpl _$$MessageAlertEvidenceImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageAlertEvidenceImpl(
      id: (json['id'] as num).toInt(),
      evidenceType: json['evidence_type'] as String,
      fileUrl: json['file_url'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MessageAlertEvidenceImplToJson(
        _$MessageAlertEvidenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'evidence_type': instance.evidenceType,
      'file_url': instance.fileUrl,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
    };
