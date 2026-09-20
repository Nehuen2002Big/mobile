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

  /// `true` si el user tiene rol `admin` en la lista de roles del JWT.
  /// Lo usamos para gatear features de debug/QA (ej. el simulador de
  /// ubicacion en el AppBar del viaje activo) sin exponerlas al chofer
  /// normal. El admin sigue siendo un chofer real (pasa la validacion
  /// de `driver_profile` en bootstrap); el rol es un add-on, no un
  /// reemplazo.
  bool get esAdmin =>
      roles.map((r) => r.toLowerCase()).contains('admin');

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
