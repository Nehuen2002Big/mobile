// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_evidence_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadEvidenceResponseImpl _$$UploadEvidenceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UploadEvidenceResponseImpl(
      tripId: json['trip_id'] as String,
      filename: json['filename'] as String,
      sizeBytes: (json['size_bytes'] as num?)?.toInt() ?? 0,
      contentType: json['content_type'] as String? ?? '',
      url: json['url'] as String,
    );

Map<String, dynamic> _$$UploadEvidenceResponseImplToJson(
        _$UploadEvidenceResponseImpl instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'filename': instance.filename,
      'size_bytes': instance.sizeBytes,
      'content_type': instance.contentType,
      'url': instance.url,
    };
