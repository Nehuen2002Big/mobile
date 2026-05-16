import 'package:freezed_annotation/freezed_annotation.dart';

import 'checkpoint_info.dart';

part 'checkpoint_list_response.freezed.dart';
part 'checkpoint_list_response.g.dart';

@freezed
class CheckpointListResponse with _$CheckpointListResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CheckpointListResponse({
    required String tripId,
    @Default([]) List<CheckpointInfo> checkpoints,
    int? nextCheckpointIndex,
    @Default(0) int total,
    @Default(0) int reachedCount,
  }) = _CheckpointListResponse;

  factory CheckpointListResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpointListResponseFromJson(json);
}
