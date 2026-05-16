// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_location_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PhoneLocationRequest _$PhoneLocationRequestFromJson(Map<String, dynamic> json) {
  return _PhoneLocationRequest.fromJson(json);
}

/// @nodoc
mixin _$PhoneLocationRequest {
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;
  double? get speedKmh => throw _privateConstructorUsedError;
  DateTime? get recordedAt => throw _privateConstructorUsedError;

  /// Serializes this PhoneLocationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhoneLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneLocationRequestCopyWith<PhoneLocationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneLocationRequestCopyWith<$Res> {
  factory $PhoneLocationRequestCopyWith(PhoneLocationRequest value,
          $Res Function(PhoneLocationRequest) then) =
      _$PhoneLocationRequestCopyWithImpl<$Res, PhoneLocationRequest>;
  @useResult
  $Res call({double lat, double lon, double? speedKmh, DateTime? recordedAt});
}

/// @nodoc
class _$PhoneLocationRequestCopyWithImpl<$Res,
        $Val extends PhoneLocationRequest>
    implements $PhoneLocationRequestCopyWith<$Res> {
  _$PhoneLocationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? speedKmh = freezed,
    Object? recordedAt = freezed,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      speedKmh: freezed == speedKmh
          ? _value.speedKmh
          : speedKmh // ignore: cast_nullable_to_non_nullable
              as double?,
      recordedAt: freezed == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhoneLocationRequestImplCopyWith<$Res>
    implements $PhoneLocationRequestCopyWith<$Res> {
  factory _$$PhoneLocationRequestImplCopyWith(_$PhoneLocationRequestImpl value,
          $Res Function(_$PhoneLocationRequestImpl) then) =
      __$$PhoneLocationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lon, double? speedKmh, DateTime? recordedAt});
}

/// @nodoc
class __$$PhoneLocationRequestImplCopyWithImpl<$Res>
    extends _$PhoneLocationRequestCopyWithImpl<$Res, _$PhoneLocationRequestImpl>
    implements _$$PhoneLocationRequestImplCopyWith<$Res> {
  __$$PhoneLocationRequestImplCopyWithImpl(_$PhoneLocationRequestImpl _value,
      $Res Function(_$PhoneLocationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhoneLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? speedKmh = freezed,
    Object? recordedAt = freezed,
  }) {
    return _then(_$PhoneLocationRequestImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      speedKmh: freezed == speedKmh
          ? _value.speedKmh
          : speedKmh // ignore: cast_nullable_to_non_nullable
              as double?,
      recordedAt: freezed == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PhoneLocationRequestImpl implements _PhoneLocationRequest {
  const _$PhoneLocationRequestImpl(
      {required this.lat, required this.lon, this.speedKmh, this.recordedAt});

  factory _$PhoneLocationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneLocationRequestImplFromJson(json);

  @override
  final double lat;
  @override
  final double lon;
  @override
  final double? speedKmh;
  @override
  final DateTime? recordedAt;

  @override
  String toString() {
    return 'PhoneLocationRequest(lat: $lat, lon: $lon, speedKmh: $speedKmh, recordedAt: $recordedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneLocationRequestImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.speedKmh, speedKmh) ||
                other.speedKmh == speedKmh) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lon, speedKmh, recordedAt);

  /// Create a copy of PhoneLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneLocationRequestImplCopyWith<_$PhoneLocationRequestImpl>
      get copyWith =>
          __$$PhoneLocationRequestImplCopyWithImpl<_$PhoneLocationRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneLocationRequestImplToJson(
      this,
    );
  }
}

abstract class _PhoneLocationRequest implements PhoneLocationRequest {
  const factory _PhoneLocationRequest(
      {required final double lat,
      required final double lon,
      final double? speedKmh,
      final DateTime? recordedAt}) = _$PhoneLocationRequestImpl;

  factory _PhoneLocationRequest.fromJson(Map<String, dynamic> json) =
      _$PhoneLocationRequestImpl.fromJson;

  @override
  double get lat;
  @override
  double get lon;
  @override
  double? get speedKmh;
  @override
  DateTime? get recordedAt;

  /// Create a copy of PhoneLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneLocationRequestImplCopyWith<_$PhoneLocationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
