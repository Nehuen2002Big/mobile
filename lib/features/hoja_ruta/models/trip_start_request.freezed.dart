// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_start_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripStartRequest _$TripStartRequestFromJson(Map<String, dynamic> json) {
  return _TripStartRequest.fromJson(json);
}

/// @nodoc
mixin _$TripStartRequest {
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;
  double? get maxDistanceM => throw _privateConstructorUsedError;

  /// Serializes this TripStartRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripStartRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripStartRequestCopyWith<TripStartRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripStartRequestCopyWith<$Res> {
  factory $TripStartRequestCopyWith(
          TripStartRequest value, $Res Function(TripStartRequest) then) =
      _$TripStartRequestCopyWithImpl<$Res, TripStartRequest>;
  @useResult
  $Res call({double lat, double lon, double? maxDistanceM});
}

/// @nodoc
class _$TripStartRequestCopyWithImpl<$Res, $Val extends TripStartRequest>
    implements $TripStartRequestCopyWith<$Res> {
  _$TripStartRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripStartRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? maxDistanceM = freezed,
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
      maxDistanceM: freezed == maxDistanceM
          ? _value.maxDistanceM
          : maxDistanceM // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripStartRequestImplCopyWith<$Res>
    implements $TripStartRequestCopyWith<$Res> {
  factory _$$TripStartRequestImplCopyWith(_$TripStartRequestImpl value,
          $Res Function(_$TripStartRequestImpl) then) =
      __$$TripStartRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lon, double? maxDistanceM});
}

/// @nodoc
class __$$TripStartRequestImplCopyWithImpl<$Res>
    extends _$TripStartRequestCopyWithImpl<$Res, _$TripStartRequestImpl>
    implements _$$TripStartRequestImplCopyWith<$Res> {
  __$$TripStartRequestImplCopyWithImpl(_$TripStartRequestImpl _value,
      $Res Function(_$TripStartRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripStartRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? maxDistanceM = freezed,
  }) {
    return _then(_$TripStartRequestImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      maxDistanceM: freezed == maxDistanceM
          ? _value.maxDistanceM
          : maxDistanceM // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TripStartRequestImpl implements _TripStartRequest {
  const _$TripStartRequestImpl(
      {required this.lat, required this.lon, this.maxDistanceM});

  factory _$TripStartRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripStartRequestImplFromJson(json);

  @override
  final double lat;
  @override
  final double lon;
  @override
  final double? maxDistanceM;

  @override
  String toString() {
    return 'TripStartRequest(lat: $lat, lon: $lon, maxDistanceM: $maxDistanceM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripStartRequestImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.maxDistanceM, maxDistanceM) ||
                other.maxDistanceM == maxDistanceM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lon, maxDistanceM);

  /// Create a copy of TripStartRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripStartRequestImplCopyWith<_$TripStartRequestImpl> get copyWith =>
      __$$TripStartRequestImplCopyWithImpl<_$TripStartRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripStartRequestImplToJson(
      this,
    );
  }
}

abstract class _TripStartRequest implements TripStartRequest {
  const factory _TripStartRequest(
      {required final double lat,
      required final double lon,
      final double? maxDistanceM}) = _$TripStartRequestImpl;

  factory _TripStartRequest.fromJson(Map<String, dynamic> json) =
      _$TripStartRequestImpl.fromJson;

  @override
  double get lat;
  @override
  double get lon;
  @override
  double? get maxDistanceM;

  /// Create a copy of TripStartRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripStartRequestImplCopyWith<_$TripStartRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
