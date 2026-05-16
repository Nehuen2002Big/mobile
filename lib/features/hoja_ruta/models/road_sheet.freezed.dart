// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'road_sheet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Checkpoint _$CheckpointFromJson(Map<String, dynamic> json) {
  return _Checkpoint.fromJson(json);
}

/// @nodoc
mixin _$Checkpoint {
  String? get locationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  String? get actionType => throw _privateConstructorUsedError;
  String? get cargoDescription => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Checkpoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Checkpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointCopyWith<Checkpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointCopyWith<$Res> {
  factory $CheckpointCopyWith(
          Checkpoint value, $Res Function(Checkpoint) then) =
      _$CheckpointCopyWithImpl<$Res, Checkpoint>;
  @useResult
  $Res call(
      {String? locationId,
      String name,
      double? lat,
      double? lon,
      String? actionType,
      String? cargoDescription,
      String? notes});
}

/// @nodoc
class _$CheckpointCopyWithImpl<$Res, $Val extends Checkpoint>
    implements $CheckpointCopyWith<$Res> {
  _$CheckpointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Checkpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = freezed,
    Object? name = null,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? actionType = freezed,
    Object? cargoDescription = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoDescription: freezed == cargoDescription
          ? _value.cargoDescription
          : cargoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointImplCopyWith<$Res>
    implements $CheckpointCopyWith<$Res> {
  factory _$$CheckpointImplCopyWith(
          _$CheckpointImpl value, $Res Function(_$CheckpointImpl) then) =
      __$$CheckpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? locationId,
      String name,
      double? lat,
      double? lon,
      String? actionType,
      String? cargoDescription,
      String? notes});
}

/// @nodoc
class __$$CheckpointImplCopyWithImpl<$Res>
    extends _$CheckpointCopyWithImpl<$Res, _$CheckpointImpl>
    implements _$$CheckpointImplCopyWith<$Res> {
  __$$CheckpointImplCopyWithImpl(
      _$CheckpointImpl _value, $Res Function(_$CheckpointImpl) _then)
      : super(_value, _then);

  /// Create a copy of Checkpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = freezed,
    Object? name = null,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? actionType = freezed,
    Object? cargoDescription = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$CheckpointImpl(
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoDescription: freezed == cargoDescription
          ? _value.cargoDescription
          : cargoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckpointImpl implements _Checkpoint {
  const _$CheckpointImpl(
      {this.locationId,
      this.name = '',
      this.lat,
      this.lon,
      this.actionType,
      this.cargoDescription,
      this.notes});

  factory _$CheckpointImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckpointImplFromJson(json);

  @override
  final String? locationId;
  @override
  @JsonKey()
  final String name;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  final String? actionType;
  @override
  final String? cargoDescription;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Checkpoint(locationId: $locationId, name: $name, lat: $lat, lon: $lon, actionType: $actionType, cargoDescription: $cargoDescription, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.cargoDescription, cargoDescription) ||
                other.cargoDescription == cargoDescription) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, locationId, name, lat, lon,
      actionType, cargoDescription, notes);

  /// Create a copy of Checkpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointImplCopyWith<_$CheckpointImpl> get copyWith =>
      __$$CheckpointImplCopyWithImpl<_$CheckpointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckpointImplToJson(
      this,
    );
  }
}

abstract class _Checkpoint implements Checkpoint {
  const factory _Checkpoint(
      {final String? locationId,
      final String name,
      final double? lat,
      final double? lon,
      final String? actionType,
      final String? cargoDescription,
      final String? notes}) = _$CheckpointImpl;

  factory _Checkpoint.fromJson(Map<String, dynamic> json) =
      _$CheckpointImpl.fromJson;

  @override
  String? get locationId;
  @override
  String get name;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  String? get actionType;
  @override
  String? get cargoDescription;
  @override
  String? get notes;

  /// Create a copy of Checkpoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointImplCopyWith<_$CheckpointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripContact _$TripContactFromJson(Map<String, dynamic> json) {
  return _TripContact.fromJson(json);
}

/// @nodoc
mixin _$TripContact {
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get contactId => throw _privateConstructorUsedError;

  /// Serializes this TripContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripContactCopyWith<TripContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripContactCopyWith<$Res> {
  factory $TripContactCopyWith(
          TripContact value, $Res Function(TripContact) then) =
      _$TripContactCopyWithImpl<$Res, TripContact>;
  @useResult
  $Res call(
      {String name,
      String phone,
      String? role,
      String? description,
      String? contactId});
}

/// @nodoc
class _$TripContactCopyWithImpl<$Res, $Val extends TripContact>
    implements $TripContactCopyWith<$Res> {
  _$TripContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phone = null,
    Object? role = freezed,
    Object? description = freezed,
    Object? contactId = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contactId: freezed == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripContactImplCopyWith<$Res>
    implements $TripContactCopyWith<$Res> {
  factory _$$TripContactImplCopyWith(
          _$TripContactImpl value, $Res Function(_$TripContactImpl) then) =
      __$$TripContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String phone,
      String? role,
      String? description,
      String? contactId});
}

/// @nodoc
class __$$TripContactImplCopyWithImpl<$Res>
    extends _$TripContactCopyWithImpl<$Res, _$TripContactImpl>
    implements _$$TripContactImplCopyWith<$Res> {
  __$$TripContactImplCopyWithImpl(
      _$TripContactImpl _value, $Res Function(_$TripContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phone = null,
    Object? role = freezed,
    Object? description = freezed,
    Object? contactId = freezed,
  }) {
    return _then(_$TripContactImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contactId: freezed == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripContactImpl implements _TripContact {
  const _$TripContactImpl(
      {this.name = '',
      this.phone = '',
      this.role,
      this.description,
      this.contactId});

  factory _$TripContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripContactImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String phone;
  @override
  final String? role;
  @override
  final String? description;
  @override
  final String? contactId;

  @override
  String toString() {
    return 'TripContact(name: $name, phone: $phone, role: $role, description: $description, contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripContactImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, phone, role, description, contactId);

  /// Create a copy of TripContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripContactImplCopyWith<_$TripContactImpl> get copyWith =>
      __$$TripContactImplCopyWithImpl<_$TripContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripContactImplToJson(
      this,
    );
  }
}

abstract class _TripContact implements TripContact {
  const factory _TripContact(
      {final String name,
      final String phone,
      final String? role,
      final String? description,
      final String? contactId}) = _$TripContactImpl;

  factory _TripContact.fromJson(Map<String, dynamic> json) =
      _$TripContactImpl.fromJson;

  @override
  String get name;
  @override
  String get phone;
  @override
  String? get role;
  @override
  String? get description;
  @override
  String? get contactId;

  /// Create a copy of TripContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripContactImplCopyWith<_$TripContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactsWrapper _$ContactsWrapperFromJson(Map<String, dynamic> json) {
  return _ContactsWrapper.fromJson(json);
}

/// @nodoc
mixin _$ContactsWrapper {
  List<TripContact> get entries => throw _privateConstructorUsedError;
  String? get receiverSchedule => throw _privateConstructorUsedError;
  bool get receptionValidated => throw _privateConstructorUsedError;
  bool get needsEvidence => throw _privateConstructorUsedError;

  /// Serializes this ContactsWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactsWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactsWrapperCopyWith<ContactsWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactsWrapperCopyWith<$Res> {
  factory $ContactsWrapperCopyWith(
          ContactsWrapper value, $Res Function(ContactsWrapper) then) =
      _$ContactsWrapperCopyWithImpl<$Res, ContactsWrapper>;
  @useResult
  $Res call(
      {List<TripContact> entries,
      String? receiverSchedule,
      bool receptionValidated,
      bool needsEvidence});
}

/// @nodoc
class _$ContactsWrapperCopyWithImpl<$Res, $Val extends ContactsWrapper>
    implements $ContactsWrapperCopyWith<$Res> {
  _$ContactsWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactsWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? receiverSchedule = freezed,
    Object? receptionValidated = null,
    Object? needsEvidence = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<TripContact>,
      receiverSchedule: freezed == receiverSchedule
          ? _value.receiverSchedule
          : receiverSchedule // ignore: cast_nullable_to_non_nullable
              as String?,
      receptionValidated: null == receptionValidated
          ? _value.receptionValidated
          : receptionValidated // ignore: cast_nullable_to_non_nullable
              as bool,
      needsEvidence: null == needsEvidence
          ? _value.needsEvidence
          : needsEvidence // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactsWrapperImplCopyWith<$Res>
    implements $ContactsWrapperCopyWith<$Res> {
  factory _$$ContactsWrapperImplCopyWith(_$ContactsWrapperImpl value,
          $Res Function(_$ContactsWrapperImpl) then) =
      __$$ContactsWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TripContact> entries,
      String? receiverSchedule,
      bool receptionValidated,
      bool needsEvidence});
}

/// @nodoc
class __$$ContactsWrapperImplCopyWithImpl<$Res>
    extends _$ContactsWrapperCopyWithImpl<$Res, _$ContactsWrapperImpl>
    implements _$$ContactsWrapperImplCopyWith<$Res> {
  __$$ContactsWrapperImplCopyWithImpl(
      _$ContactsWrapperImpl _value, $Res Function(_$ContactsWrapperImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactsWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? receiverSchedule = freezed,
    Object? receptionValidated = null,
    Object? needsEvidence = null,
  }) {
    return _then(_$ContactsWrapperImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<TripContact>,
      receiverSchedule: freezed == receiverSchedule
          ? _value.receiverSchedule
          : receiverSchedule // ignore: cast_nullable_to_non_nullable
              as String?,
      receptionValidated: null == receptionValidated
          ? _value.receptionValidated
          : receptionValidated // ignore: cast_nullable_to_non_nullable
              as bool,
      needsEvidence: null == needsEvidence
          ? _value.needsEvidence
          : needsEvidence // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactsWrapperImpl implements _ContactsWrapper {
  const _$ContactsWrapperImpl(
      {final List<TripContact> entries = const [],
      this.receiverSchedule,
      this.receptionValidated = false,
      this.needsEvidence = false})
      : _entries = entries;

  factory _$ContactsWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactsWrapperImplFromJson(json);

  final List<TripContact> _entries;
  @override
  @JsonKey()
  List<TripContact> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final String? receiverSchedule;
  @override
  @JsonKey()
  final bool receptionValidated;
  @override
  @JsonKey()
  final bool needsEvidence;

  @override
  String toString() {
    return 'ContactsWrapper(entries: $entries, receiverSchedule: $receiverSchedule, receptionValidated: $receptionValidated, needsEvidence: $needsEvidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactsWrapperImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.receiverSchedule, receiverSchedule) ||
                other.receiverSchedule == receiverSchedule) &&
            (identical(other.receptionValidated, receptionValidated) ||
                other.receptionValidated == receptionValidated) &&
            (identical(other.needsEvidence, needsEvidence) ||
                other.needsEvidence == needsEvidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      receiverSchedule,
      receptionValidated,
      needsEvidence);

  /// Create a copy of ContactsWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactsWrapperImplCopyWith<_$ContactsWrapperImpl> get copyWith =>
      __$$ContactsWrapperImplCopyWithImpl<_$ContactsWrapperImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactsWrapperImplToJson(
      this,
    );
  }
}

abstract class _ContactsWrapper implements ContactsWrapper {
  const factory _ContactsWrapper(
      {final List<TripContact> entries,
      final String? receiverSchedule,
      final bool receptionValidated,
      final bool needsEvidence}) = _$ContactsWrapperImpl;

  factory _ContactsWrapper.fromJson(Map<String, dynamic> json) =
      _$ContactsWrapperImpl.fromJson;

  @override
  List<TripContact> get entries;
  @override
  String? get receiverSchedule;
  @override
  bool get receptionValidated;
  @override
  bool get needsEvidence;

  /// Create a copy of ContactsWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactsWrapperImplCopyWith<_$ContactsWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) {
  return _RouteInfo.fromJson(json);
}

/// @nodoc
mixin _$RouteInfo {
  String? get mode => throw _privateConstructorUsedError;
  String? get routeId => throw _privateConstructorUsedError;
  double? get toleranceKm => throw _privateConstructorUsedError;
  String? get etaStart => throw _privateConstructorUsedError;
  String? get etaEnd => throw _privateConstructorUsedError;
  List<List<double>> get geometry => throw _privateConstructorUsedError;
  int? get distanceMeters => throw _privateConstructorUsedError;
  int? get durationSeconds => throw _privateConstructorUsedError;

  /// Serializes this RouteInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteInfoCopyWith<RouteInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteInfoCopyWith<$Res> {
  factory $RouteInfoCopyWith(RouteInfo value, $Res Function(RouteInfo) then) =
      _$RouteInfoCopyWithImpl<$Res, RouteInfo>;
  @useResult
  $Res call(
      {String? mode,
      String? routeId,
      double? toleranceKm,
      String? etaStart,
      String? etaEnd,
      List<List<double>> geometry,
      int? distanceMeters,
      int? durationSeconds});
}

/// @nodoc
class _$RouteInfoCopyWithImpl<$Res, $Val extends RouteInfo>
    implements $RouteInfoCopyWith<$Res> {
  _$RouteInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = freezed,
    Object? routeId = freezed,
    Object? toleranceKm = freezed,
    Object? etaStart = freezed,
    Object? etaEnd = freezed,
    Object? geometry = null,
    Object? distanceMeters = freezed,
    Object? durationSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      toleranceKm: freezed == toleranceKm
          ? _value.toleranceKm
          : toleranceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      etaStart: freezed == etaStart
          ? _value.etaStart
          : etaStart // ignore: cast_nullable_to_non_nullable
              as String?,
      etaEnd: freezed == etaEnd
          ? _value.etaEnd
          : etaEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      distanceMeters: freezed == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      durationSeconds: freezed == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteInfoImplCopyWith<$Res>
    implements $RouteInfoCopyWith<$Res> {
  factory _$$RouteInfoImplCopyWith(
          _$RouteInfoImpl value, $Res Function(_$RouteInfoImpl) then) =
      __$$RouteInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? mode,
      String? routeId,
      double? toleranceKm,
      String? etaStart,
      String? etaEnd,
      List<List<double>> geometry,
      int? distanceMeters,
      int? durationSeconds});
}

/// @nodoc
class __$$RouteInfoImplCopyWithImpl<$Res>
    extends _$RouteInfoCopyWithImpl<$Res, _$RouteInfoImpl>
    implements _$$RouteInfoImplCopyWith<$Res> {
  __$$RouteInfoImplCopyWithImpl(
      _$RouteInfoImpl _value, $Res Function(_$RouteInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = freezed,
    Object? routeId = freezed,
    Object? toleranceKm = freezed,
    Object? etaStart = freezed,
    Object? etaEnd = freezed,
    Object? geometry = null,
    Object? distanceMeters = freezed,
    Object? durationSeconds = freezed,
  }) {
    return _then(_$RouteInfoImpl(
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      toleranceKm: freezed == toleranceKm
          ? _value.toleranceKm
          : toleranceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      etaStart: freezed == etaStart
          ? _value.etaStart
          : etaStart // ignore: cast_nullable_to_non_nullable
              as String?,
      etaEnd: freezed == etaEnd
          ? _value.etaEnd
          : etaEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      geometry: null == geometry
          ? _value._geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      distanceMeters: freezed == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      durationSeconds: freezed == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteInfoImpl implements _RouteInfo {
  const _$RouteInfoImpl(
      {this.mode,
      this.routeId,
      this.toleranceKm,
      this.etaStart,
      this.etaEnd,
      final List<List<double>> geometry = const [],
      this.distanceMeters,
      this.durationSeconds})
      : _geometry = geometry;

  factory _$RouteInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteInfoImplFromJson(json);

  @override
  final String? mode;
  @override
  final String? routeId;
  @override
  final double? toleranceKm;
  @override
  final String? etaStart;
  @override
  final String? etaEnd;
  final List<List<double>> _geometry;
  @override
  @JsonKey()
  List<List<double>> get geometry {
    if (_geometry is EqualUnmodifiableListView) return _geometry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geometry);
  }

  @override
  final int? distanceMeters;
  @override
  final int? durationSeconds;

  @override
  String toString() {
    return 'RouteInfo(mode: $mode, routeId: $routeId, toleranceKm: $toleranceKm, etaStart: $etaStart, etaEnd: $etaEnd, geometry: $geometry, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteInfoImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.toleranceKm, toleranceKm) ||
                other.toleranceKm == toleranceKm) &&
            (identical(other.etaStart, etaStart) ||
                other.etaStart == etaStart) &&
            (identical(other.etaEnd, etaEnd) || other.etaEnd == etaEnd) &&
            const DeepCollectionEquality().equals(other._geometry, _geometry) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      routeId,
      toleranceKm,
      etaStart,
      etaEnd,
      const DeepCollectionEquality().hash(_geometry),
      distanceMeters,
      durationSeconds);

  /// Create a copy of RouteInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteInfoImplCopyWith<_$RouteInfoImpl> get copyWith =>
      __$$RouteInfoImplCopyWithImpl<_$RouteInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteInfoImplToJson(
      this,
    );
  }
}

abstract class _RouteInfo implements RouteInfo {
  const factory _RouteInfo(
      {final String? mode,
      final String? routeId,
      final double? toleranceKm,
      final String? etaStart,
      final String? etaEnd,
      final List<List<double>> geometry,
      final int? distanceMeters,
      final int? durationSeconds}) = _$RouteInfoImpl;

  factory _RouteInfo.fromJson(Map<String, dynamic> json) =
      _$RouteInfoImpl.fromJson;

  @override
  String? get mode;
  @override
  String? get routeId;
  @override
  double? get toleranceKm;
  @override
  String? get etaStart;
  @override
  String? get etaEnd;
  @override
  List<List<double>> get geometry;
  @override
  int? get distanceMeters;
  @override
  int? get durationSeconds;

  /// Create a copy of RouteInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteInfoImplCopyWith<_$RouteInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoadSheet _$RoadSheetFromJson(Map<String, dynamic> json) {
  return _RoadSheet.fromJson(json);
}

/// @nodoc
mixin _$RoadSheet {
  String? get identification => throw _privateConstructorUsedError;
  String? get origin => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  String? get referenceCode => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get tripTypeId => throw _privateConstructorUsedError;
  String? get cargoTypeId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toStringOrNull)
  String? get cargoValue => throw _privateConstructorUsedError;
  List<Checkpoint> get checkpoints => throw _privateConstructorUsedError;
  ContactsWrapper? get contacts => throw _privateConstructorUsedError;
  RouteInfo? get route => throw _privateConstructorUsedError;

  /// Serializes this RoadSheet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoadSheetCopyWith<RoadSheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadSheetCopyWith<$Res> {
  factory $RoadSheetCopyWith(RoadSheet value, $Res Function(RoadSheet) then) =
      _$RoadSheetCopyWithImpl<$Res, RoadSheet>;
  @useResult
  $Res call(
      {String? identification,
      String? origin,
      String? destination,
      String? referenceCode,
      String? notes,
      String? tripTypeId,
      String? cargoTypeId,
      @JsonKey(fromJson: _toStringOrNull) String? cargoValue,
      List<Checkpoint> checkpoints,
      ContactsWrapper? contacts,
      RouteInfo? route});

  $ContactsWrapperCopyWith<$Res>? get contacts;
  $RouteInfoCopyWith<$Res>? get route;
}

/// @nodoc
class _$RoadSheetCopyWithImpl<$Res, $Val extends RoadSheet>
    implements $RoadSheetCopyWith<$Res> {
  _$RoadSheetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = freezed,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? referenceCode = freezed,
    Object? notes = freezed,
    Object? tripTypeId = freezed,
    Object? cargoTypeId = freezed,
    Object? cargoValue = freezed,
    Object? checkpoints = null,
    Object? contacts = freezed,
    Object? route = freezed,
  }) {
    return _then(_value.copyWith(
      identification: freezed == identification
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceCode: freezed == referenceCode
          ? _value.referenceCode
          : referenceCode // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tripTypeId: freezed == tripTypeId
          ? _value.tripTypeId
          : tripTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoTypeId: freezed == cargoTypeId
          ? _value.cargoTypeId
          : cargoTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoValue: freezed == cargoValue
          ? _value.cargoValue
          : cargoValue // ignore: cast_nullable_to_non_nullable
              as String?,
      checkpoints: null == checkpoints
          ? _value.checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<Checkpoint>,
      contacts: freezed == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as ContactsWrapper?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as RouteInfo?,
    ) as $Val);
  }

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactsWrapperCopyWith<$Res>? get contacts {
    if (_value.contacts == null) {
      return null;
    }

    return $ContactsWrapperCopyWith<$Res>(_value.contacts!, (value) {
      return _then(_value.copyWith(contacts: value) as $Val);
    });
  }

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteInfoCopyWith<$Res>? get route {
    if (_value.route == null) {
      return null;
    }

    return $RouteInfoCopyWith<$Res>(_value.route!, (value) {
      return _then(_value.copyWith(route: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoadSheetImplCopyWith<$Res>
    implements $RoadSheetCopyWith<$Res> {
  factory _$$RoadSheetImplCopyWith(
          _$RoadSheetImpl value, $Res Function(_$RoadSheetImpl) then) =
      __$$RoadSheetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? identification,
      String? origin,
      String? destination,
      String? referenceCode,
      String? notes,
      String? tripTypeId,
      String? cargoTypeId,
      @JsonKey(fromJson: _toStringOrNull) String? cargoValue,
      List<Checkpoint> checkpoints,
      ContactsWrapper? contacts,
      RouteInfo? route});

  @override
  $ContactsWrapperCopyWith<$Res>? get contacts;
  @override
  $RouteInfoCopyWith<$Res>? get route;
}

/// @nodoc
class __$$RoadSheetImplCopyWithImpl<$Res>
    extends _$RoadSheetCopyWithImpl<$Res, _$RoadSheetImpl>
    implements _$$RoadSheetImplCopyWith<$Res> {
  __$$RoadSheetImplCopyWithImpl(
      _$RoadSheetImpl _value, $Res Function(_$RoadSheetImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = freezed,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? referenceCode = freezed,
    Object? notes = freezed,
    Object? tripTypeId = freezed,
    Object? cargoTypeId = freezed,
    Object? cargoValue = freezed,
    Object? checkpoints = null,
    Object? contacts = freezed,
    Object? route = freezed,
  }) {
    return _then(_$RoadSheetImpl(
      identification: freezed == identification
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceCode: freezed == referenceCode
          ? _value.referenceCode
          : referenceCode // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tripTypeId: freezed == tripTypeId
          ? _value.tripTypeId
          : tripTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoTypeId: freezed == cargoTypeId
          ? _value.cargoTypeId
          : cargoTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoValue: freezed == cargoValue
          ? _value.cargoValue
          : cargoValue // ignore: cast_nullable_to_non_nullable
              as String?,
      checkpoints: null == checkpoints
          ? _value._checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<Checkpoint>,
      contacts: freezed == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as ContactsWrapper?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as RouteInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadSheetImpl extends _RoadSheet {
  const _$RoadSheetImpl(
      {this.identification,
      this.origin,
      this.destination,
      this.referenceCode,
      this.notes,
      this.tripTypeId,
      this.cargoTypeId,
      @JsonKey(fromJson: _toStringOrNull) this.cargoValue,
      final List<Checkpoint> checkpoints = const [],
      this.contacts,
      this.route})
      : _checkpoints = checkpoints,
        super._();

  factory _$RoadSheetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadSheetImplFromJson(json);

  @override
  final String? identification;
  @override
  final String? origin;
  @override
  final String? destination;
  @override
  final String? referenceCode;
  @override
  final String? notes;
  @override
  final String? tripTypeId;
  @override
  final String? cargoTypeId;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  final String? cargoValue;
  final List<Checkpoint> _checkpoints;
  @override
  @JsonKey()
  List<Checkpoint> get checkpoints {
    if (_checkpoints is EqualUnmodifiableListView) return _checkpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checkpoints);
  }

  @override
  final ContactsWrapper? contacts;
  @override
  final RouteInfo? route;

  @override
  String toString() {
    return 'RoadSheet(identification: $identification, origin: $origin, destination: $destination, referenceCode: $referenceCode, notes: $notes, tripTypeId: $tripTypeId, cargoTypeId: $cargoTypeId, cargoValue: $cargoValue, checkpoints: $checkpoints, contacts: $contacts, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadSheetImpl &&
            (identical(other.identification, identification) ||
                other.identification == identification) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.referenceCode, referenceCode) ||
                other.referenceCode == referenceCode) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.tripTypeId, tripTypeId) ||
                other.tripTypeId == tripTypeId) &&
            (identical(other.cargoTypeId, cargoTypeId) ||
                other.cargoTypeId == cargoTypeId) &&
            (identical(other.cargoValue, cargoValue) ||
                other.cargoValue == cargoValue) &&
            const DeepCollectionEquality()
                .equals(other._checkpoints, _checkpoints) &&
            (identical(other.contacts, contacts) ||
                other.contacts == contacts) &&
            (identical(other.route, route) || other.route == route));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      identification,
      origin,
      destination,
      referenceCode,
      notes,
      tripTypeId,
      cargoTypeId,
      cargoValue,
      const DeepCollectionEquality().hash(_checkpoints),
      contacts,
      route);

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadSheetImplCopyWith<_$RoadSheetImpl> get copyWith =>
      __$$RoadSheetImplCopyWithImpl<_$RoadSheetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadSheetImplToJson(
      this,
    );
  }
}

abstract class _RoadSheet extends RoadSheet {
  const factory _RoadSheet(
      {final String? identification,
      final String? origin,
      final String? destination,
      final String? referenceCode,
      final String? notes,
      final String? tripTypeId,
      final String? cargoTypeId,
      @JsonKey(fromJson: _toStringOrNull) final String? cargoValue,
      final List<Checkpoint> checkpoints,
      final ContactsWrapper? contacts,
      final RouteInfo? route}) = _$RoadSheetImpl;
  const _RoadSheet._() : super._();

  factory _RoadSheet.fromJson(Map<String, dynamic> json) =
      _$RoadSheetImpl.fromJson;

  @override
  String? get identification;
  @override
  String? get origin;
  @override
  String? get destination;
  @override
  String? get referenceCode;
  @override
  String? get notes;
  @override
  String? get tripTypeId;
  @override
  String? get cargoTypeId;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  String? get cargoValue;
  @override
  List<Checkpoint> get checkpoints;
  @override
  ContactsWrapper? get contacts;
  @override
  RouteInfo? get route;

  /// Create a copy of RoadSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoadSheetImplCopyWith<_$RoadSheetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
