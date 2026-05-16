import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingest_result.freezed.dart';
part 'ingest_result.g.dart';

@freezed
class IngestResult with _$IngestResult {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory IngestResult({
    @Default(0) int pointId,
    String? tripId,
    @Default(false) bool isOnRoute,
    @Default(0) double distToRouteM,
    @Default(false) bool alertGenerated,
  }) = _IngestResult;

  factory IngestResult.fromJson(Map<String, dynamic> json) =>
      _$IngestResultFromJson(json);
}
