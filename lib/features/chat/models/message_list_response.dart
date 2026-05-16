import 'package:freezed_annotation/freezed_annotation.dart';

import 'trip_message.dart';

part 'message_list_response.freezed.dart';
part 'message_list_response.g.dart';

@freezed
class MessageListResponse with _$MessageListResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MessageListResponse({
    @Default([]) List<TripMessage> items,
    @Default(0) int total,
    @Default(0) int unreadForDriver,
    @Default(0) int unreadForMonitor,
  }) = _MessageListResponse;

  factory MessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageListResponseFromJson(json);
}
