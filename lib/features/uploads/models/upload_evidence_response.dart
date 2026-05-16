import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_evidence_response.freezed.dart';
part 'upload_evidence_response.g.dart';

@freezed
class UploadEvidenceResponse with _$UploadEvidenceResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UploadEvidenceResponse({
    required String tripId,
    required String filename,
    @Default(0) int sizeBytes,
    @Default('') String contentType,
    /// URL RELATIVO al host (ej. "/api/v1/uploads/evidence/TRIP/xxx.jpg").
    /// Para construir URL absoluta hay que anteponer `config.trackingBaseUrl`.
    required String url,
  }) = _UploadEvidenceResponse;

  factory UploadEvidenceResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadEvidenceResponseFromJson(json);
}
