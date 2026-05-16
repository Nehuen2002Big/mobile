// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_evidence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckpointEvidenceImpl _$$CheckpointEvidenceImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckpointEvidenceImpl(
      evidenceType: json['evidence_type'] as String,
      fileUrl: json['file_url'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$CheckpointEvidenceImplToJson(
        _$CheckpointEvidenceImpl instance) =>
    <String, dynamic>{
      'evidence_type': instance.evidenceType,
      'file_url': instance.fileUrl,
      'description': instance.description,
    };
