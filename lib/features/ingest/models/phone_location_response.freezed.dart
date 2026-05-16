// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_location_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PhoneLocationResponse _$PhoneLocationResponseFromJson(
    Map<String, dynamic> json) {
  return _PhoneLocationResponse.fromJson(json);
}

/// @nodoc
mixin _$PhoneLocationResponse {
  int get pointId => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this PhoneLocationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhoneLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneLocationResponseCopyWith<PhoneLocationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneLocationResponseCopyWith<$Res> {
  factory $PhoneLocationResponseCopyWith(PhoneLocationResponse value,
          $Res Function(PhoneLocationResponse) then) =
      _$PhoneLocationResponseCopyWithImpl<$Res, PhoneLocationResponse>;
  @useResult
  $Res call({int pointId, String tripId, String source});
}

/// @nodoc
class _$PhoneLocationResponseCopyWithImpl<$Res,
        $Val extends PhoneLocationResponse>
    implements $PhoneLocationResponseCopyWith<$Res> {
  _$PhoneLocationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointId = null,
    Object? tripId = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      pointId: null == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhoneLocationResponseImplCopyWith<$Res>
    implements $PhoneLocationResponseCopyWith<$Res> {
  factory _$$PhoneLocationResponseImplCopyWith(
          _$PhoneLocationResponseImpl value,
          $Res Function(_$PhoneLocationResponseImpl) then) =
      __$$PhoneLocationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pointId, String tripId, String source});
}

/// @nodoc
class __$$PhoneLocationResponseImplCopyWithImpl<$Res>
    extends _$PhoneLocationResponseCopyWithImpl<$Res,
        _$PhoneLocationResponseImpl>
    implements _$$PhoneLocationResponseImplCopyWith<$Res> {
  __$$PhoneLocationResponseImplCopyWithImpl(_$PhoneLocationResponseImpl _value,
      $Res Function(_$PhoneLocationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhoneLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointId = null,
    Object? tripId = null,
    Object? source = null,
  }) {
    return _then(_$PhoneLocationResponseImpl(
      pointId: null == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PhoneLocationResponseImpl implements _PhoneLocationResponse {
  const _$PhoneLocationResponseImpl(
      {this.pointId = 0, required this.tripId, this.source = 'PHONE'});

  factory _$PhoneLocationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneLocationResponseImplFromJson(json);

  @override
  @JsonKey()
  final int pointId;
  @override
  final String tripId;
  @override
  @JsonKey()
  final String source;

  @override
  String toString() {
    return 'PhoneLocationResponse(pointId: $pointId, tripId: $tripId, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneLocationResponseImpl &&
            (identical(other.pointId, pointId) || other.pointId == pointId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pointId, tripId, source);

  /// Create a copy of PhoneLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneLocationResponseImplCopyWith<_$PhoneLocationResponseImpl>
      get copyWith => __$$PhoneLocationResponseImplCopyWithImpl<
          _$PhoneLocationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneLocationResponseImplToJson(
      this,
    );
  }
}

abstract class _PhoneLocationResponse implements PhoneLocationResponse {
  const factory _PhoneLocationResponse(
      {final int pointId,
      required final String tripId,
      final String source}) = _$PhoneLocationResponseImpl;

  factory _PhoneLocationResponse.fromJson(Map<String, dynamic> json) =
      _$PhoneLocationResponseImpl.fromJson;

  @override
  int get pointId;
  @override
  String get tripId;
  @override
  String get source;

  /// Create a copy of PhoneLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneLocationResponseImplCopyWith<_$PhoneLocationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
