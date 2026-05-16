// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_finish_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripFinishRequest _$TripFinishRequestFromJson(Map<String, dynamic> json) {
  return _TripFinishRequest.fromJson(json);
}

/// @nodoc
mixin _$TripFinishRequest {
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;
  double? get maxDistanceM => throw _privateConstructorUsedError;

  /// Serializes this TripFinishRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripFinishRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripFinishRequestCopyWith<TripFinishRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripFinishRequestCopyWith<$Res> {
  factory $TripFinishRequestCopyWith(
          TripFinishRequest value, $Res Function(TripFinishRequest) then) =
      _$TripFinishRequestCopyWithImpl<$Res, TripFinishRequest>;
  @useResult
  $Res call({double lat, double lon, double? maxDistanceM});
}

/// @nodoc
class _$TripFinishRequestCopyWithImpl<$Res, $Val extends TripFinishRequest>
    implements $TripFinishRequestCopyWith<$Res> {
  _$TripFinishRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripFinishRequest
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
abstract class _$$TripFinishRequestImplCopyWith<$Res>
    implements $TripFinishRequestCopyWith<$Res> {
  factory _$$TripFinishRequestImplCopyWith(_$TripFinishRequestImpl value,
          $Res Function(_$TripFinishRequestImpl) then) =
      __$$TripFinishRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lon, double? maxDistanceM});
}

/// @nodoc
class __$$TripFinishRequestImplCopyWithImpl<$Res>
    extends _$TripFinishRequestCopyWithImpl<$Res, _$TripFinishRequestImpl>
    implements _$$TripFinishRequestImplCopyWith<$Res> {
  __$$TripFinishRequestImplCopyWithImpl(_$TripFinishRequestImpl _value,
      $Res Function(_$TripFinishRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripFinishRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? maxDistanceM = freezed,
  }) {
    return _then(_$TripFinishRequestImpl(
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
class _$TripFinishRequestImpl implements _TripFinishRequest {
  const _$TripFinishRequestImpl(
      {required this.lat, required this.lon, this.maxDistanceM});

  factory _$TripFinishRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripFinishRequestImplFromJson(json);

  @override
  final double lat;
  @override
  final double lon;
  @override
  final double? maxDistanceM;

  @override
  String toString() {
    return 'TripFinishRequest(lat: $lat, lon: $lon, maxDistanceM: $maxDistanceM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripFinishRequestImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.maxDistanceM, maxDistanceM) ||
                other.maxDistanceM == maxDistanceM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lon, maxDistanceM);

  /// Create a copy of TripFinishRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripFinishRequestImplCopyWith<_$TripFinishRequestImpl> get copyWith =>
      __$$TripFinishRequestImplCopyWithImpl<_$TripFinishRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripFinishRequestImplToJson(
      this,
    );
  }
}

abstract class _TripFinishRequest implements TripFinishRequest {
  const factory _TripFinishRequest(
      {required final double lat,
      required final double lon,
      final double? maxDistanceM}) = _$TripFinishRequestImpl;

  factory _TripFinishRequest.fromJson(Map<String, dynamic> json) =
      _$TripFinishRequestImpl.fromJson;

  @override
  double get lat;
  @override
  double get lon;
  @override
  double? get maxDistanceM;

  /// Create a copy of TripFinishRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripFinishRequestImplCopyWith<_$TripFinishRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
