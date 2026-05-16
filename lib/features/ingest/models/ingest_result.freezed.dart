// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingest_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IngestResult _$IngestResultFromJson(Map<String, dynamic> json) {
  return _IngestResult.fromJson(json);
}

/// @nodoc
mixin _$IngestResult {
  int get pointId => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  bool get isOnRoute => throw _privateConstructorUsedError;
  double get distToRouteM => throw _privateConstructorUsedError;
  bool get alertGenerated => throw _privateConstructorUsedError;

  /// Serializes this IngestResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IngestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngestResultCopyWith<IngestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngestResultCopyWith<$Res> {
  factory $IngestResultCopyWith(
          IngestResult value, $Res Function(IngestResult) then) =
      _$IngestResultCopyWithImpl<$Res, IngestResult>;
  @useResult
  $Res call(
      {int pointId,
      String? tripId,
      bool isOnRoute,
      double distToRouteM,
      bool alertGenerated});
}

/// @nodoc
class _$IngestResultCopyWithImpl<$Res, $Val extends IngestResult>
    implements $IngestResultCopyWith<$Res> {
  _$IngestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IngestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointId = null,
    Object? tripId = freezed,
    Object? isOnRoute = null,
    Object? distToRouteM = null,
    Object? alertGenerated = null,
  }) {
    return _then(_value.copyWith(
      pointId: null == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnRoute: null == isOnRoute
          ? _value.isOnRoute
          : isOnRoute // ignore: cast_nullable_to_non_nullable
              as bool,
      distToRouteM: null == distToRouteM
          ? _value.distToRouteM
          : distToRouteM // ignore: cast_nullable_to_non_nullable
              as double,
      alertGenerated: null == alertGenerated
          ? _value.alertGenerated
          : alertGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IngestResultImplCopyWith<$Res>
    implements $IngestResultCopyWith<$Res> {
  factory _$$IngestResultImplCopyWith(
          _$IngestResultImpl value, $Res Function(_$IngestResultImpl) then) =
      __$$IngestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pointId,
      String? tripId,
      bool isOnRoute,
      double distToRouteM,
      bool alertGenerated});
}

/// @nodoc
class __$$IngestResultImplCopyWithImpl<$Res>
    extends _$IngestResultCopyWithImpl<$Res, _$IngestResultImpl>
    implements _$$IngestResultImplCopyWith<$Res> {
  __$$IngestResultImplCopyWithImpl(
      _$IngestResultImpl _value, $Res Function(_$IngestResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of IngestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointId = null,
    Object? tripId = freezed,
    Object? isOnRoute = null,
    Object? distToRouteM = null,
    Object? alertGenerated = null,
  }) {
    return _then(_$IngestResultImpl(
      pointId: null == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnRoute: null == isOnRoute
          ? _value.isOnRoute
          : isOnRoute // ignore: cast_nullable_to_non_nullable
              as bool,
      distToRouteM: null == distToRouteM
          ? _value.distToRouteM
          : distToRouteM // ignore: cast_nullable_to_non_nullable
              as double,
      alertGenerated: null == alertGenerated
          ? _value.alertGenerated
          : alertGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$IngestResultImpl implements _IngestResult {
  const _$IngestResultImpl(
      {this.pointId = 0,
      this.tripId,
      this.isOnRoute = false,
      this.distToRouteM = 0,
      this.alertGenerated = false});

  factory _$IngestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngestResultImplFromJson(json);

  @override
  @JsonKey()
  final int pointId;
  @override
  final String? tripId;
  @override
  @JsonKey()
  final bool isOnRoute;
  @override
  @JsonKey()
  final double distToRouteM;
  @override
  @JsonKey()
  final bool alertGenerated;

  @override
  String toString() {
    return 'IngestResult(pointId: $pointId, tripId: $tripId, isOnRoute: $isOnRoute, distToRouteM: $distToRouteM, alertGenerated: $alertGenerated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngestResultImpl &&
            (identical(other.pointId, pointId) || other.pointId == pointId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.isOnRoute, isOnRoute) ||
                other.isOnRoute == isOnRoute) &&
            (identical(other.distToRouteM, distToRouteM) ||
                other.distToRouteM == distToRouteM) &&
            (identical(other.alertGenerated, alertGenerated) ||
                other.alertGenerated == alertGenerated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, pointId, tripId, isOnRoute, distToRouteM, alertGenerated);

  /// Create a copy of IngestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngestResultImplCopyWith<_$IngestResultImpl> get copyWith =>
      __$$IngestResultImplCopyWithImpl<_$IngestResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IngestResultImplToJson(
      this,
    );
  }
}

abstract class _IngestResult implements IngestResult {
  const factory _IngestResult(
      {final int pointId,
      final String? tripId,
      final bool isOnRoute,
      final double distToRouteM,
      final bool alertGenerated}) = _$IngestResultImpl;

  factory _IngestResult.fromJson(Map<String, dynamic> json) =
      _$IngestResultImpl.fromJson;

  @override
  int get pointId;
  @override
  String? get tripId;
  @override
  bool get isOnRoute;
  @override
  double get distToRouteM;
  @override
  bool get alertGenerated;

  /// Create a copy of IngestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngestResultImplCopyWith<_$IngestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
