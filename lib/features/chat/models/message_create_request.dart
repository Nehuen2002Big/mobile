import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_create_request.freezed.dart';
part 'message_create_request.g.dart';

@freezed
class MessageCreateRequest with _$MessageCreateRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MessageCreateRequest({
    required String senderRole,
    String? senderName,
    required String content,
  }) = _MessageCreateRequest;

  factory MessageCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$MessageCreateRequestFromJson(json);
}
