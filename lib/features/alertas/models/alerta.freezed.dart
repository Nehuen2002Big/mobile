// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlertaPayload _$AlertaPayloadFromJson(Map<String, dynamic> json) {
  return _AlertaPayload.fromJson(json);
}

/// @nodoc
mixin _$AlertaPayload {
  String get alertType => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  List<CheckpointEvidence> get evidences => throw _privateConstructorUsedError;

  /// Serializes this AlertaPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertaPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertaPayloadCopyWith<AlertaPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertaPayloadCopyWith<$Res> {
  factory $AlertaPayloadCopyWith(
          AlertaPayload value, $Res Function(AlertaPayload) then) =
      _$AlertaPayloadCopyWithImpl<$Res, AlertaPayload>;
  @useResult
  $Res call(
      {String alertType,
      double lat,
      double lon,
      String? message,
      List<CheckpointEvidence> evidences});
}

/// @nodoc
class _$AlertaPayloadCopyWithImpl<$Res, $Val extends AlertaPayload>
    implements $AlertaPayloadCopyWith<$Res> {
  _$AlertaPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertaPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertType = null,
    Object? lat = null,
    Object? lon = null,
    Object? message = freezed,
    Object? evidences = null,
  }) {
    return _then(_value.copyWith(
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      evidences: null == evidences
          ? _value.evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<CheckpointEvidence>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertaPayloadImplCopyWith<$Res>
    implements $AlertaPayloadCopyWith<$Res> {
  factory _$$AlertaPayloadImplCopyWith(
          _$AlertaPayloadImpl value, $Res Function(_$AlertaPayloadImpl) then) =
      __$$AlertaPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String alertType,
      double lat,
      double lon,
      String? message,
      List<CheckpointEvidence> evidences});
}

/// @nodoc
class __$$AlertaPayloadImplCopyWithImpl<$Res>
    extends _$AlertaPayloadCopyWithImpl<$Res, _$AlertaPayloadImpl>
    implements _$$AlertaPayloadImplCopyWith<$Res> {
  __$$AlertaPayloadImplCopyWithImpl(
      _$AlertaPayloadImpl _value, $Res Function(_$AlertaPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertaPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertType = null,
    Object? lat = null,
    Object? lon = null,
    Object? message = freezed,
    Object? evidences = null,
  }) {
    return _then(_$AlertaPayloadImpl(
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      evidences: null == evidences
          ? _value._evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<CheckpointEvidence>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$AlertaPayloadImpl implements _AlertaPayload {
  const _$AlertaPayloadImpl(
      {required this.alertType,
      required this.lat,
      required this.lon,
      this.message,
      final List<CheckpointEvidence> evidences = const []})
      : _evidences = evidences;

  factory _$AlertaPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertaPayloadImplFromJson(json);

  @override
  final String alertType;
  @override
  final double lat;
  @override
  final double lon;
  @override
  final String? message;
  final List<CheckpointEvidence> _evidences;
  @override
  @JsonKey()
  List<CheckpointEvidence> get evidences {
    if (_evidences is EqualUnmodifiableListView) return _evidences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidences);
  }

  @override
  String toString() {
    return 'AlertaPayload(alertType: $alertType, lat: $lat, lon: $lon, message: $message, evidences: $evidences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertaPayloadImpl &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._evidences, _evidences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, alertType, lat, lon, message,
      const DeepCollectionEquality().hash(_evidences));

  /// Create a copy of AlertaPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertaPayloadImplCopyWith<_$AlertaPayloadImpl> get copyWith =>
      __$$AlertaPayloadImplCopyWithImpl<_$AlertaPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertaPayloadImplToJson(
      this,
    );
  }
}

abstract class _AlertaPayload implements AlertaPayload {
  const factory _AlertaPayload(
      {required final String alertType,
      required final double lat,
      required final double lon,
      final String? message,
      final List<CheckpointEvidence> evidences}) = _$AlertaPayloadImpl;

  factory _AlertaPayload.fromJson(Map<String, dynamic> json) =
      _$AlertaPayloadImpl.fromJson;

  @override
  String get alertType;
  @override
  double get lat;
  @override
  double get lon;
  @override
  String? get message;
  @override
  List<CheckpointEvidence> get evidences;

  /// Create a copy of AlertaPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertaPayloadImplCopyWith<_$AlertaPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
