import 'package:freezed_annotation/freezed_annotation.dart';

import '../../uploads/models/checkpoint_evidence.dart';

part 'checkpoint_reach_request.freezed.dart';
part 'checkpoint_reach_request.g.dart';

@freezed
class CheckpointReachRequest with _$CheckpointReachRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CheckpointReachRequest({
    required double lat,
    required double lon,
    String? notes,
    @Default([]) List<CheckpointEvidence> evidences,
    double? maxDistanceM,
  }) = _CheckpointReachRequest;

  factory CheckpointReachRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckpointReachRequestFromJson(json);
}
