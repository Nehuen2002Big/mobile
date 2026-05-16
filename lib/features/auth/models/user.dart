import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class AuthUser with _$AuthUser {
  const AuthUser._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthUser({
    required String id,
    @Default('') String email,
    String? username,
    @Default('') String userType,
    @Default([]) List<String> roles,
  }) = _AuthUser;

  bool get esConductor =>
      userType.toUpperCase() == 'DRIVER' ||
      roles.map((r) => r.toLowerCase()).contains('conductor');

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
