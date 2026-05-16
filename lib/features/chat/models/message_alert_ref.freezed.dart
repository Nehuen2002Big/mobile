// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_alert_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageAlertRef _$MessageAlertRefFromJson(Map<String, dynamic> json) {
  return _MessageAlertRef.fromJson(json);
}

/// @nodoc
mixin _$MessageAlertRef {
  int get id => throw _privateConstructorUsedError;
  String get alertType => throw _privateConstructorUsedError;
  List<MessageAlertEvidence> get evidences =>
      throw _privateConstructorUsedError;

  /// Tipo de regla del backend que disparo la alerta (HIGH_SPEED,
  /// LONG_STOP, SCHEDULE_DEVIATION, OFF_ROUTE, DEVICE_OFFLINE).
  /// null para alertas del chofer (TRAFICO/PARADA_COMER/AVERIA/ACCIDENTE).
  String? get ruleType => throw _privateConstructorUsedError;

  /// "L1" | "L2" | "L3" segun el nivel configurado en road sheet.
  String? get escalationLevel => throw _privateConstructorUsedError;
  DateTime? get escalatedAt => throw _privateConstructorUsedError;

  /// Datos extra de contexto: ej. {"speed":120,"limit":80} para HIGH_SPEED.
  Map<String, dynamic>? get extra => throw _privateConstructorUsedError;

  /// `true` si la alerta fue generada por el simulador de QA del
  /// operador. Renderiza identico a una real para validar el flow
  /// end-to-end; solo usar este flag para debug local.
  bool get simulated => throw _privateConstructorUsedError;

  /// Serializes this MessageAlertRef to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageAlertRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageAlertRefCopyWith<MessageAlertRef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageAlertRefCopyWith<$Res> {
  factory $MessageAlertRefCopyWith(
          MessageAlertRef value, $Res Function(MessageAlertRef) then) =
      _$MessageAlertRefCopyWithImpl<$Res, MessageAlertRef>;
  @useResult
  $Res call(
      {int id,
      String alertType,
      List<MessageAlertEvidence> evidences,
      String? ruleType,
      String? escalationLevel,
      DateTime? escalatedAt,
      Map<String, dynamic>? extra,
      bool simulated});
}

/// @nodoc
class _$MessageAlertRefCopyWithImpl<$Res, $Val extends MessageAlertRef>
    implements $MessageAlertRefCopyWith<$Res> {
  _$MessageAlertRefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageAlertRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? alertType = null,
    Object? evidences = null,
    Object? ruleType = freezed,
    Object? escalationLevel = freezed,
    Object? escalatedAt = freezed,
    Object? extra = freezed,
    Object? simulated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      evidences: null == evidences
          ? _value.evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<MessageAlertEvidence>,
      ruleType: freezed == ruleType
          ? _value.ruleType
          : ruleType // ignore: cast_nullable_to_non_nullable
              as String?,
      escalationLevel: freezed == escalationLevel
          ? _value.escalationLevel
          : escalationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      escalatedAt: freezed == escalatedAt
          ? _value.escalatedAt
          : escalatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      simulated: null == simulated
          ? _value.simulated
          : simulated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageAlertRefImplCopyWith<$Res>
    implements $MessageAlertRefCopyWith<$Res> {
  factory _$$MessageAlertRefImplCopyWith(_$MessageAlertRefImpl value,
          $Res Function(_$MessageAlertRefImpl) then) =
      __$$MessageAlertRefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String alertType,
      List<MessageAlertEvidence> evidences,
      String? ruleType,
      String? escalationLevel,
      DateTime? escalatedAt,
      Map<String, dynamic>? extra,
      bool simulated});
}

/// @nodoc
class __$$MessageAlertRefImplCopyWithImpl<$Res>
    extends _$MessageAlertRefCopyWithImpl<$Res, _$MessageAlertRefImpl>
    implements _$$MessageAlertRefImplCopyWith<$Res> {
  __$$MessageAlertRefImplCopyWithImpl(
      _$MessageAlertRefImpl _value, $Res Function(_$MessageAlertRefImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageAlertRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? alertType = null,
    Object? evidences = null,
    Object? ruleType = freezed,
    Object? escalationLevel = freezed,
    Object? escalatedAt = freezed,
    Object? extra = freezed,
    Object? simulated = null,
  }) {
    return _then(_$MessageAlertRefImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      evidences: null == evidences
          ? _value._evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<MessageAlertEvidence>,
      ruleType: freezed == ruleType
          ? _value.ruleType
          : ruleType // ignore: cast_nullable_to_non_nullable
              as String?,
      escalationLevel: freezed == escalationLevel
          ? _value.escalationLevel
          : escalationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      escalatedAt: freezed == escalatedAt
          ? _value.escalatedAt
          : escalatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      extra: freezed == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      simulated: null == simulated
          ? _value.simulated
          : simulated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MessageAlertRefImpl extends _MessageAlertRef {
  const _$MessageAlertRefImpl(
      {required this.id,
      required this.alertType,
      final List<MessageAlertEvidence> evidences = const [],
      this.ruleType,
      this.escalationLevel,
      this.escalatedAt,
      final Map<String, dynamic>? extra,
      this.simulated = false})
      : _evidences = evidences,
        _extra = extra,
        super._();

  factory _$MessageAlertRefImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageAlertRefImplFromJson(json);

  @override
  final int id;
  @override
  final String alertType;
  final List<MessageAlertEvidence> _evidences;
  @override
  @JsonKey()
  List<MessageAlertEvidence> get evidences {
    if (_evidences is EqualUnmodifiableListView) return _evidences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidences);
  }

  /// Tipo de regla del backend que disparo la alerta (HIGH_SPEED,
  /// LONG_STOP, SCHEDULE_DEVIATION, OFF_ROUTE, DEVICE_OFFLINE).
  /// null para alertas del chofer (TRAFICO/PARADA_COMER/AVERIA/ACCIDENTE).
  @override
  final String? ruleType;

  /// "L1" | "L2" | "L3" segun el nivel configurado en road sheet.
  @override
  final String? escalationLevel;
  @override
  final DateTime? escalatedAt;

  /// Datos extra de contexto: ej. {"speed":120,"limit":80} para HIGH_SPEED.
  final Map<String, dynamic>? _extra;

  /// Datos extra de contexto: ej. {"speed":120,"limit":80} para HIGH_SPEED.
  @override
  Map<String, dynamic>? get extra {
    final value = _extra;
    if (value == null) return null;
    if (_extra is EqualUnmodifiableMapView) return _extra;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// `true` si la alerta fue generada por el simulador de QA del
  /// operador. Renderiza identico a una real para validar el flow
  /// end-to-end; solo usar este flag para debug local.
  @override
  @JsonKey()
  final bool simulated;

  @override
  String toString() {
    return 'MessageAlertRef(id: $id, alertType: $alertType, evidences: $evidences, ruleType: $ruleType, escalationLevel: $escalationLevel, escalatedAt: $escalatedAt, extra: $extra, simulated: $simulated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageAlertRefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            const DeepCollectionEquality()
                .equals(other._evidences, _evidences) &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            (identical(other.escalationLevel, escalationLevel) ||
                other.escalationLevel == escalationLevel) &&
            (identical(other.escalatedAt, escalatedAt) ||
                other.escalatedAt == escalatedAt) &&
            const DeepCollectionEquality().equals(other._extra, _extra) &&
            (identical(other.simulated, simulated) ||
                other.simulated == simulated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      alertType,
      const DeepCollectionEquality().hash(_evidences),
      ruleType,
      escalationLevel,
      escalatedAt,
      const DeepCollectionEquality().hash(_extra),
      simulated);

  /// Create a copy of MessageAlertRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageAlertRefImplCopyWith<_$MessageAlertRefImpl> get copyWith =>
      __$$MessageAlertRefImplCopyWithImpl<_$MessageAlertRefImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageAlertRefImplToJson(
      this,
    );
  }
}

abstract class _MessageAlertRef extends MessageAlertRef {
  const factory _MessageAlertRef(
      {required final int id,
      required final String alertType,
      final List<MessageAlertEvidence> evidences,
      final String? ruleType,
      final String? escalationLevel,
      final DateTime? escalatedAt,
      final Map<String, dynamic>? extra,
      final bool simulated}) = _$MessageAlertRefImpl;
  const _MessageAlertRef._() : super._();

  factory _MessageAlertRef.fromJson(Map<String, dynamic> json) =
      _$MessageAlertRefImpl.fromJson;

  @override
  int get id;
  @override
  String get alertType;
  @override
  List<MessageAlertEvidence> get evidences;

  /// Tipo de regla del backend que disparo la alerta (HIGH_SPEED,
  /// LONG_STOP, SCHEDULE_DEVIATION, OFF_ROUTE, DEVICE_OFFLINE).
  /// null para alertas del chofer (TRAFICO/PARADA_COMER/AVERIA/ACCIDENTE).
  @override
  String? get ruleType;

  /// "L1" | "L2" | "L3" segun el nivel configurado en road sheet.
  @override
  String? get escalationLevel;
  @override
  DateTime? get escalatedAt;

  /// Datos extra de contexto: ej. {"speed":120,"limit":80} para HIGH_SPEED.
  @override
  Map<String, dynamic>? get extra;

  /// `true` si la alerta fue generada por el simulador de QA del
  /// operador. Renderiza identico a una real para validar el flow
  /// end-to-end; solo usar este flag para debug local.
  @override
  bool get simulated;

  /// Create a copy of MessageAlertRef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageAlertRefImplCopyWith<_$MessageAlertRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageAlertEvidence _$MessageAlertEvidenceFromJson(Map<String, dynamic> json) {
  return _MessageAlertEvidence.fromJson(json);
}

/// @nodoc
mixin _$MessageAlertEvidence {
  int get id => throw _privateConstructorUsedError;
  String get evidenceType => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MessageAlertEvidence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageAlertEvidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageAlertEvidenceCopyWith<MessageAlertEvidence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageAlertEvidenceCopyWith<$Res> {
  factory $MessageAlertEvidenceCopyWith(MessageAlertEvidence value,
          $Res Function(MessageAlertEvidence) then) =
      _$MessageAlertEvidenceCopyWithImpl<$Res, MessageAlertEvidence>;
  @useResult
  $Res call(
      {int id,
      String evidenceType,
      String? fileUrl,
      String? description,
      DateTime? createdAt});
}

/// @nodoc
class _$MessageAlertEvidenceCopyWithImpl<$Res,
        $Val extends MessageAlertEvidence>
    implements $MessageAlertEvidenceCopyWith<$Res> {
  _$MessageAlertEvidenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageAlertEvidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? evidenceType = null,
    Object? fileUrl = freezed,
    Object? description = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      evidenceType: null == evidenceType
          ? _value.evidenceType
          : evidenceType // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageAlertEvidenceImplCopyWith<$Res>
    implements $MessageAlertEvidenceCopyWith<$Res> {
  factory _$$MessageAlertEvidenceImplCopyWith(_$MessageAlertEvidenceImpl value,
          $Res Function(_$MessageAlertEvidenceImpl) then) =
      __$$MessageAlertEvidenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String evidenceType,
      String? fileUrl,
      String? description,
      DateTime? createdAt});
}

/// @nodoc
class __$$MessageAlertEvidenceImplCopyWithImpl<$Res>
    extends _$MessageAlertEvidenceCopyWithImpl<$Res, _$MessageAlertEvidenceImpl>
    implements _$$MessageAlertEvidenceImplCopyWith<$Res> {
  __$$MessageAlertEvidenceImplCopyWithImpl(_$MessageAlertEvidenceImpl _value,
      $Res Function(_$MessageAlertEvidenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageAlertEvidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? evidenceType = null,
    Object? fileUrl = freezed,
    Object? description = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MessageAlertEvidenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      evidenceType: null == evidenceType
          ? _value.evidenceType
          : evidenceType // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MessageAlertEvidenceImpl extends _MessageAlertEvidence {
  const _$MessageAlertEvidenceImpl(
      {required this.id,
      required this.evidenceType,
      this.fileUrl,
      this.description,
      this.createdAt})
      : super._();

  factory _$MessageAlertEvidenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageAlertEvidenceImplFromJson(json);

  @override
  final int id;
  @override
  final String evidenceType;
  @override
  final String? fileUrl;
  @override
  final String? description;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MessageAlertEvidence(id: $id, evidenceType: $evidenceType, fileUrl: $fileUrl, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageAlertEvidenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.evidenceType, evidenceType) ||
                other.evidenceType == evidenceType) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, evidenceType, fileUrl, description, createdAt);

  /// Create a copy of MessageAlertEvidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageAlertEvidenceImplCopyWith<_$MessageAlertEvidenceImpl>
      get copyWith =>
          __$$MessageAlertEvidenceImplCopyWithImpl<_$MessageAlertEvidenceImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageAlertEvidenceImplToJson(
      this,
    );
  }
}

abstract class _MessageAlertEvidence extends MessageAlertEvidence {
  const factory _MessageAlertEvidence(
      {required final int id,
      required final String evidenceType,
      final String? fileUrl,
      final String? description,
      final DateTime? createdAt}) = _$MessageAlertEvidenceImpl;
  const _MessageAlertEvidence._() : super._();

  factory _MessageAlertEvidence.fromJson(Map<String, dynamic> json) =
      _$MessageAlertEvidenceImpl.fromJson;

  @override
  int get id;
  @override
  String get evidenceType;
  @override
  String? get fileUrl;
  @override
  String? get description;
  @override
  DateTime? get createdAt;

  /// Create a copy of MessageAlertEvidence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageAlertEvidenceImplCopyWith<_$MessageAlertEvidenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}
