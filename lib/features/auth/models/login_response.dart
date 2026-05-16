import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LoginResponse({
    required String accessToken,
    required String refreshToken,
    @Default('bearer') String tokenType,
    @Default(900) int expiresIn,
    required AuthUser user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
