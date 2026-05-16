import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkpoint_reach_response.freezed.dart';
part 'checkpoint_reach_response.g.dart';

@freezed
class CheckpointReachResponse with _$CheckpointReachResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CheckpointReachResponse({
    required String tripId,
    required int checkpointIndex,
    required DateTime reachedAt,
    required double distanceToCheckpointM,
    int? nextCheckpointIndex,
    @Default(false) bool allDone,
  }) = _CheckpointReachResponse;

  factory CheckpointReachResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpointReachResponseFromJson(json);
}
