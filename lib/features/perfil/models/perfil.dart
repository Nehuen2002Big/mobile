import 'package:freezed_annotation/freezed_annotation.dart';

part 'perfil.freezed.dart';
part 'perfil.g.dart';

// --- Persona ---

@freezed
class Persona with _$Persona {
  const Persona._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Persona({
    required String id,
    @Default('') String firstName,
    @Default('') String lastName,
    String? phone,
    String? email,
    String? role,
  }) = _Persona;

  String get nombreCompleto => '$firstName $lastName'.trim();

  factory Persona.fromJson(Map<String, dynamic> json) =>
      _$PersonaFromJson(json);
}

// --- DriverProfile ---

@freezed
class DriverProfile with _$DriverProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DriverProfile({
    String? licenseNumber,
    String? licenseCategory,
    String? licenseExpiry,
    @Default(false) bool active,
    String? emergencyContactPhone,
  }) = _DriverProfile;

  factory DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);
}

// --- PersonContact (contactos personales del chofer) ---

@freezed
class PersonContact with _$PersonContact {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PersonContact({
    String? id,
    String? label,
    String? roleTag,
    @Default('') String name,
    String? phone,
    String? email,
    @Default(true) bool active,
  }) = _PersonContact;

  factory PersonContact.fromJson(Map<String, dynamic> json) =>
      _$PersonContactFromJson(json);
}

// --- Perfil (envelope del GET /me/profile) ---

@freezed
class Perfil with _$Perfil {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Perfil({
    required Persona person,
    DriverProfile? driverProfile,
    @Default([]) List<Map<String, dynamic>> userLinks,
    @Default([]) List<PersonContact> contacts,
  }) = _Perfil;

  factory Perfil.fromJson(Map<String, dynamic> json) =>
      _$PerfilFromJson(json);

  /// Desenvuelve el wrapper { "data": { ... } } que devuelve la API.
  static Perfil fromEnvelope(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    return Perfil.fromJson(data);
  }
}
