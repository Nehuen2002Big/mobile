// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perfil.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Persona _$PersonaFromJson(Map<String, dynamic> json) {
  return _Persona.fromJson(json);
}

/// @nodoc
mixin _$Persona {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;

  /// Serializes this Persona to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaCopyWith<Persona> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaCopyWith<$Res> {
  factory $PersonaCopyWith(Persona value, $Res Function(Persona) then) =
      _$PersonaCopyWithImpl<$Res, Persona>;
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String? phone,
      String? email,
      String? role});
}

/// @nodoc
class _$PersonaCopyWithImpl<$Res, $Val extends Persona>
    implements $PersonaCopyWith<$Res> {
  _$PersonaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaImplCopyWith<$Res> implements $PersonaCopyWith<$Res> {
  factory _$$PersonaImplCopyWith(
          _$PersonaImpl value, $Res Function(_$PersonaImpl) then) =
      __$$PersonaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String? phone,
      String? email,
      String? role});
}

/// @nodoc
class __$$PersonaImplCopyWithImpl<$Res>
    extends _$PersonaCopyWithImpl<$Res, _$PersonaImpl>
    implements _$$PersonaImplCopyWith<$Res> {
  __$$PersonaImplCopyWithImpl(
      _$PersonaImpl _value, $Res Function(_$PersonaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? role = freezed,
  }) {
    return _then(_$PersonaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PersonaImpl extends _Persona {
  const _$PersonaImpl(
      {required this.id,
      this.firstName = '',
      this.lastName = '',
      this.phone,
      this.email,
      this.role})
      : super._();

  factory _$PersonaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? role;

  @override
  String toString() {
    return 'Persona(id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, firstName, lastName, phone, email, role);

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      __$$PersonaImplCopyWithImpl<_$PersonaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaImplToJson(
      this,
    );
  }
}

abstract class _Persona extends Persona {
  const factory _Persona(
      {required final String id,
      final String firstName,
      final String lastName,
      final String? phone,
      final String? email,
      final String? role}) = _$PersonaImpl;
  const _Persona._() : super._();

  factory _Persona.fromJson(Map<String, dynamic> json) = _$PersonaImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get role;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) {
  return _DriverProfile.fromJson(json);
}

/// @nodoc
mixin _$DriverProfile {
  String? get licenseNumber => throw _privateConstructorUsedError;
  String? get licenseCategory => throw _privateConstructorUsedError;
  String? get licenseExpiry => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  String? get emergencyContactPhone => throw _privateConstructorUsedError;

  /// Serializes this DriverProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverProfileCopyWith<DriverProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverProfileCopyWith<$Res> {
  factory $DriverProfileCopyWith(
          DriverProfile value, $Res Function(DriverProfile) then) =
      _$DriverProfileCopyWithImpl<$Res, DriverProfile>;
  @useResult
  $Res call(
      {String? licenseNumber,
      String? licenseCategory,
      String? licenseExpiry,
      bool active,
      String? emergencyContactPhone});
}

/// @nodoc
class _$DriverProfileCopyWithImpl<$Res, $Val extends DriverProfile>
    implements $DriverProfileCopyWith<$Res> {
  _$DriverProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseNumber = freezed,
    Object? licenseCategory = freezed,
    Object? licenseExpiry = freezed,
    Object? active = null,
    Object? emergencyContactPhone = freezed,
  }) {
    return _then(_value.copyWith(
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseCategory: freezed == licenseCategory
          ? _value.licenseCategory
          : licenseCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseExpiry: freezed == licenseExpiry
          ? _value.licenseExpiry
          : licenseExpiry // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DriverProfileImplCopyWith<$Res>
    implements $DriverProfileCopyWith<$Res> {
  factory _$$DriverProfileImplCopyWith(
          _$DriverProfileImpl value, $Res Function(_$DriverProfileImpl) then) =
      __$$DriverProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? licenseNumber,
      String? licenseCategory,
      String? licenseExpiry,
      bool active,
      String? emergencyContactPhone});
}

/// @nodoc
class __$$DriverProfileImplCopyWithImpl<$Res>
    extends _$DriverProfileCopyWithImpl<$Res, _$DriverProfileImpl>
    implements _$$DriverProfileImplCopyWith<$Res> {
  __$$DriverProfileImplCopyWithImpl(
      _$DriverProfileImpl _value, $Res Function(_$DriverProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseNumber = freezed,
    Object? licenseCategory = freezed,
    Object? licenseExpiry = freezed,
    Object? active = null,
    Object? emergencyContactPhone = freezed,
  }) {
    return _then(_$DriverProfileImpl(
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseCategory: freezed == licenseCategory
          ? _value.licenseCategory
          : licenseCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseExpiry: freezed == licenseExpiry
          ? _value.licenseExpiry
          : licenseExpiry // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$DriverProfileImpl implements _DriverProfile {
  const _$DriverProfileImpl(
      {this.licenseNumber,
      this.licenseCategory,
      this.licenseExpiry,
      this.active = false,
      this.emergencyContactPhone});

  factory _$DriverProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverProfileImplFromJson(json);

  @override
  final String? licenseNumber;
  @override
  final String? licenseCategory;
  @override
  final String? licenseExpiry;
  @override
  @JsonKey()
  final bool active;
  @override
  final String? emergencyContactPhone;

  @override
  String toString() {
    return 'DriverProfile(licenseNumber: $licenseNumber, licenseCategory: $licenseCategory, licenseExpiry: $licenseExpiry, active: $active, emergencyContactPhone: $emergencyContactPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverProfileImpl &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.licenseCategory, licenseCategory) ||
                other.licenseCategory == licenseCategory) &&
            (identical(other.licenseExpiry, licenseExpiry) ||
                other.licenseExpiry == licenseExpiry) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, licenseNumber, licenseCategory,
      licenseExpiry, active, emergencyContactPhone);

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverProfileImplCopyWith<_$DriverProfileImpl> get copyWith =>
      __$$DriverProfileImplCopyWithImpl<_$DriverProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverProfileImplToJson(
      this,
    );
  }
}

abstract class _DriverProfile implements DriverProfile {
  const factory _DriverProfile(
      {final String? licenseNumber,
      final String? licenseCategory,
      final String? licenseExpiry,
      final bool active,
      final String? emergencyContactPhone}) = _$DriverProfileImpl;

  factory _DriverProfile.fromJson(Map<String, dynamic> json) =
      _$DriverProfileImpl.fromJson;

  @override
  String? get licenseNumber;
  @override
  String? get licenseCategory;
  @override
  String? get licenseExpiry;
  @override
  bool get active;
  @override
  String? get emergencyContactPhone;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverProfileImplCopyWith<_$DriverProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonContact _$PersonContactFromJson(Map<String, dynamic> json) {
  return _PersonContact.fromJson(json);
}

/// @nodoc
mixin _$PersonContact {
  String? get id => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  String? get roleTag => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;

  /// Serializes this PersonContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonContactCopyWith<PersonContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonContactCopyWith<$Res> {
  factory $PersonContactCopyWith(
          PersonContact value, $Res Function(PersonContact) then) =
      _$PersonContactCopyWithImpl<$Res, PersonContact>;
  @useResult
  $Res call(
      {String? id,
      String? label,
      String? roleTag,
      String name,
      String? phone,
      String? email,
      bool active});
}

/// @nodoc
class _$PersonContactCopyWithImpl<$Res, $Val extends PersonContact>
    implements $PersonContactCopyWith<$Res> {
  _$PersonContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? roleTag = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? active = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      roleTag: freezed == roleTag
          ? _value.roleTag
          : roleTag // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonContactImplCopyWith<$Res>
    implements $PersonContactCopyWith<$Res> {
  factory _$$PersonContactImplCopyWith(
          _$PersonContactImpl value, $Res Function(_$PersonContactImpl) then) =
      __$$PersonContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? label,
      String? roleTag,
      String name,
      String? phone,
      String? email,
      bool active});
}

/// @nodoc
class __$$PersonContactImplCopyWithImpl<$Res>
    extends _$PersonContactCopyWithImpl<$Res, _$PersonContactImpl>
    implements _$$PersonContactImplCopyWith<$Res> {
  __$$PersonContactImplCopyWithImpl(
      _$PersonContactImpl _value, $Res Function(_$PersonContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? roleTag = freezed,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? active = null,
  }) {
    return _then(_$PersonContactImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      roleTag: freezed == roleTag
          ? _value.roleTag
          : roleTag // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PersonContactImpl implements _PersonContact {
  const _$PersonContactImpl(
      {this.id,
      this.label,
      this.roleTag,
      this.name = '',
      this.phone,
      this.email,
      this.active = true});

  factory _$PersonContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonContactImplFromJson(json);

  @override
  final String? id;
  @override
  final String? label;
  @override
  final String? roleTag;
  @override
  @JsonKey()
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  @JsonKey()
  final bool active;

  @override
  String toString() {
    return 'PersonContact(id: $id, label: $label, roleTag: $roleTag, name: $name, phone: $phone, email: $email, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.roleTag, roleTag) || other.roleTag == roleTag) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, label, roleTag, name, phone, email, active);

  /// Create a copy of PersonContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonContactImplCopyWith<_$PersonContactImpl> get copyWith =>
      __$$PersonContactImplCopyWithImpl<_$PersonContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonContactImplToJson(
      this,
    );
  }
}

abstract class _PersonContact implements PersonContact {
  const factory _PersonContact(
      {final String? id,
      final String? label,
      final String? roleTag,
      final String name,
      final String? phone,
      final String? email,
      final bool active}) = _$PersonContactImpl;

  factory _PersonContact.fromJson(Map<String, dynamic> json) =
      _$PersonContactImpl.fromJson;

  @override
  String? get id;
  @override
  String? get label;
  @override
  String? get roleTag;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  bool get active;

  /// Create a copy of PersonContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonContactImplCopyWith<_$PersonContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Perfil _$PerfilFromJson(Map<String, dynamic> json) {
  return _Perfil.fromJson(json);
}

/// @nodoc
mixin _$Perfil {
  Persona get person => throw _privateConstructorUsedError;
  DriverProfile? get driverProfile => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get userLinks =>
      throw _privateConstructorUsedError;
  List<PersonContact> get contacts => throw _privateConstructorUsedError;

  /// Serializes this Perfil to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerfilCopyWith<Perfil> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilCopyWith<$Res> {
  factory $PerfilCopyWith(Perfil value, $Res Function(Perfil) then) =
      _$PerfilCopyWithImpl<$Res, Perfil>;
  @useResult
  $Res call(
      {Persona person,
      DriverProfile? driverProfile,
      List<Map<String, dynamic>> userLinks,
      List<PersonContact> contacts});

  $PersonaCopyWith<$Res> get person;
  $DriverProfileCopyWith<$Res>? get driverProfile;
}

/// @nodoc
class _$PerfilCopyWithImpl<$Res, $Val extends Perfil>
    implements $PerfilCopyWith<$Res> {
  _$PerfilCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? person = null,
    Object? driverProfile = freezed,
    Object? userLinks = null,
    Object? contacts = null,
  }) {
    return _then(_value.copyWith(
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Persona,
      driverProfile: freezed == driverProfile
          ? _value.driverProfile
          : driverProfile // ignore: cast_nullable_to_non_nullable
              as DriverProfile?,
      userLinks: null == userLinks
          ? _value.userLinks
          : userLinks // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      contacts: null == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<PersonContact>,
    ) as $Val);
  }

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonaCopyWith<$Res> get person {
    return $PersonaCopyWith<$Res>(_value.person, (value) {
      return _then(_value.copyWith(person: value) as $Val);
    });
  }

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DriverProfileCopyWith<$Res>? get driverProfile {
    if (_value.driverProfile == null) {
      return null;
    }

    return $DriverProfileCopyWith<$Res>(_value.driverProfile!, (value) {
      return _then(_value.copyWith(driverProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PerfilImplCopyWith<$Res> implements $PerfilCopyWith<$Res> {
  factory _$$PerfilImplCopyWith(
          _$PerfilImpl value, $Res Function(_$PerfilImpl) then) =
      __$$PerfilImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Persona person,
      DriverProfile? driverProfile,
      List<Map<String, dynamic>> userLinks,
      List<PersonContact> contacts});

  @override
  $PersonaCopyWith<$Res> get person;
  @override
  $DriverProfileCopyWith<$Res>? get driverProfile;
}

/// @nodoc
class __$$PerfilImplCopyWithImpl<$Res>
    extends _$PerfilCopyWithImpl<$Res, _$PerfilImpl>
    implements _$$PerfilImplCopyWith<$Res> {
  __$$PerfilImplCopyWithImpl(
      _$PerfilImpl _value, $Res Function(_$PerfilImpl) _then)
      : super(_value, _then);

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? person = null,
    Object? driverProfile = freezed,
    Object? userLinks = null,
    Object? contacts = null,
  }) {
    return _then(_$PerfilImpl(
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Persona,
      driverProfile: freezed == driverProfile
          ? _value.driverProfile
          : driverProfile // ignore: cast_nullable_to_non_nullable
              as DriverProfile?,
      userLinks: null == userLinks
          ? _value._userLinks
          : userLinks // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      contacts: null == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<PersonContact>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PerfilImpl implements _Perfil {
  const _$PerfilImpl(
      {required this.person,
      this.driverProfile,
      final List<Map<String, dynamic>> userLinks = const [],
      final List<PersonContact> contacts = const []})
      : _userLinks = userLinks,
        _contacts = contacts;

  factory _$PerfilImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerfilImplFromJson(json);

  @override
  final Persona person;
  @override
  final DriverProfile? driverProfile;
  final List<Map<String, dynamic>> _userLinks;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get userLinks {
    if (_userLinks is EqualUnmodifiableListView) return _userLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userLinks);
  }

  final List<PersonContact> _contacts;
  @override
  @JsonKey()
  List<PersonContact> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  @override
  String toString() {
    return 'Perfil(person: $person, driverProfile: $driverProfile, userLinks: $userLinks, contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilImpl &&
            (identical(other.person, person) || other.person == person) &&
            (identical(other.driverProfile, driverProfile) ||
                other.driverProfile == driverProfile) &&
            const DeepCollectionEquality()
                .equals(other._userLinks, _userLinks) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      person,
      driverProfile,
      const DeepCollectionEquality().hash(_userLinks),
      const DeepCollectionEquality().hash(_contacts));

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilImplCopyWith<_$PerfilImpl> get copyWith =>
      __$$PerfilImplCopyWithImpl<_$PerfilImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerfilImplToJson(
      this,
    );
  }
}

abstract class _Perfil implements Perfil {
  const factory _Perfil(
      {required final Persona person,
      final DriverProfile? driverProfile,
      final List<Map<String, dynamic>> userLinks,
      final List<PersonContact> contacts}) = _$PerfilImpl;

  factory _Perfil.fromJson(Map<String, dynamic> json) = _$PerfilImpl.fromJson;

  @override
  Persona get person;
  @override
  DriverProfile? get driverProfile;
  @override
  List<Map<String, dynamic>> get userLinks;
  @override
  List<PersonContact> get contacts;

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerfilImplCopyWith<_$PerfilImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
