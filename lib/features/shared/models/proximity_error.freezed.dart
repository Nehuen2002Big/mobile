// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proximity_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProximityError _$ProximityErrorFromJson(Map<String, dynamic> json) {
  return _ProximityError.fromJson(json);
}

/// @nodoc
mixin _$ProximityError {
  String get error => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  double? get distanceM => throw _privateConstructorUsedError;
  double? get maxDistanceM => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this ProximityError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProximityError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProximityErrorCopyWith<ProximityError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProximityErrorCopyWith<$Res> {
  factory $ProximityErrorCopyWith(
          ProximityError value, $Res Function(ProximityError) then) =
      _$ProximityErrorCopyWithImpl<$Res, ProximityError>;
  @useResult
  $Res call(
      {String error,
      String source,
      double? distanceM,
      double? maxDistanceM,
      String message});
}

/// @nodoc
class _$ProximityErrorCopyWithImpl<$Res, $Val extends ProximityError>
    implements $ProximityErrorCopyWith<$Res> {
  _$ProximityErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProximityError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? source = null,
    Object? distanceM = freezed,
    Object? maxDistanceM = freezed,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      distanceM: freezed == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDistanceM: freezed == maxDistanceM
          ? _value.maxDistanceM
          : maxDistanceM // ignore: cast_nullable_to_non_nullable
              as double?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProximityErrorImplCopyWith<$Res>
    implements $ProximityErrorCopyWith<$Res> {
  factory _$$ProximityErrorImplCopyWith(_$ProximityErrorImpl value,
          $Res Function(_$ProximityErrorImpl) then) =
      __$$ProximityErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String error,
      String source,
      double? distanceM,
      double? maxDistanceM,
      String message});
}

/// @nodoc
class __$$ProximityErrorImplCopyWithImpl<$Res>
    extends _$ProximityErrorCopyWithImpl<$Res, _$ProximityErrorImpl>
    implements _$$ProximityErrorImplCopyWith<$Res> {
  __$$ProximityErrorImplCopyWithImpl(
      _$ProximityErrorImpl _value, $Res Function(_$ProximityErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProximityError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? source = null,
    Object? distanceM = freezed,
    Object? maxDistanceM = freezed,
    Object? message = null,
  }) {
    return _then(_$ProximityErrorImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      distanceM: freezed == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDistanceM: freezed == maxDistanceM
          ? _value.maxDistanceM
          : maxDistanceM // ignore: cast_nullable_to_non_nullable
              as double?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ProximityErrorImpl extends _ProximityError {
  const _$ProximityErrorImpl(
      {this.error = 'unknown',
      this.source = 'unknown',
      this.distanceM,
      this.maxDistanceM,
      this.message = ''})
      : super._();

  factory _$ProximityErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProximityErrorImplFromJson(json);

  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final String source;
  @override
  final double? distanceM;
  @override
  final double? maxDistanceM;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'ProximityError(error: $error, source: $source, distanceM: $distanceM, maxDistanceM: $maxDistanceM, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProximityErrorImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.distanceM, distanceM) ||
                other.distanceM == distanceM) &&
            (identical(other.maxDistanceM, maxDistanceM) ||
                other.maxDistanceM == maxDistanceM) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, error, source, distanceM, maxDistanceM, message);

  /// Create a copy of ProximityError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProximityErrorImplCopyWith<_$ProximityErrorImpl> get copyWith =>
      __$$ProximityErrorImplCopyWithImpl<_$ProximityErrorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProximityErrorImplToJson(
      this,
    );
  }
}

abstract class _ProximityError extends ProximityError {
  const factory _ProximityError(
      {final String error,
      final String source,
      final double? distanceM,
      final double? maxDistanceM,
      final String message}) = _$ProximityErrorImpl;
  const _ProximityError._() : super._();

  factory _ProximityError.fromJson(Map<String, dynamic> json) =
      _$ProximityErrorImpl.fromJson;

  @override
  String get error;
  @override
  String get source;
  @override
  double? get distanceM;
  @override
  double? get maxDistanceM;
  @override
  String get message;

  /// Create a copy of ProximityError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProximityErrorImplCopyWith<_$ProximityErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
