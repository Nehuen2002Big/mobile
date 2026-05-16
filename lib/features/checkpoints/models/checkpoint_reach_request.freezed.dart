// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoint_reach_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckpointReachRequest _$CheckpointReachRequestFromJson(
    Map<String, dynamic> json) {
  return _CheckpointReachRequest.fromJson(json);
}

/// @nodoc
mixin _$CheckpointReachRequest {
  double get lat => throw _privateConstructorUsedError;
  double get lon => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<CheckpointEvidence> get evidences => throw _privateConstructorUsedError;
  double? get maxDistanceM => throw _privateConstructorUsedError;

  /// Serializes this CheckpointReachRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckpointReachRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointReachRequestCopyWith<CheckpointReachRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointReachRequestCopyWith<$Res> {
  factory $CheckpointReachRequestCopyWith(CheckpointReachRequest value,
          $Res Function(CheckpointReachRequest) then) =
      _$CheckpointReachRequestCopyWithImpl<$Res, CheckpointReachRequest>;
  @useResult
  $Res call(
      {double lat,
      double lon,
      String? notes,
      List<CheckpointEvidence> evidences,
      double? maxDistanceM});
}

/// @nodoc
class _$CheckpointReachRequestCopyWithImpl<$Res,
        $Val extends CheckpointReachRequest>
    implements $CheckpointReachRequestCopyWith<$Res> {
  _$CheckpointReachRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckpointReachRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? notes = freezed,
    Object? evidences = null,
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      evidences: null == evidences
          ? _value.evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<CheckpointEvidence>,
      maxDistanceM: freezed == maxDistanceM
          ? _value.maxDistanceM
          : maxDistanceM // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointReachRequestImplCopyWith<$Res>
    implements $CheckpointReachRequestCopyWith<$Res> {
  factory _$$CheckpointReachRequestImplCopyWith(
          _$CheckpointReachRequestImpl value,
          $Res Function(_$CheckpointReachRequestImpl) then) =
      __$$CheckpointReachRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double lat,
      double lon,
      String? notes,
      List<CheckpointEvidence> evidences,
      double? maxDistanceM});
}

/// @nodoc
class __$$CheckpointReachRequestImplCopyWithImpl<$Res>
    extends _$CheckpointReachRequestCopyWithImpl<$Res,
        _$CheckpointReachRequestImpl>
    implements _$$CheckpointReachRequestImplCopyWith<$Res> {
  __$$CheckpointReachRequestImplCopyWithImpl(
      _$CheckpointReachRequestImpl _value,
      $Res Function(_$CheckpointReachRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckpointReachRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lon = null,
    Object? notes = freezed,
    Object? evidences = null,
    Object? maxDistanceM = freezed,
  }) {
    return _then(_$CheckpointReachRequestImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      evidences: null == evidences
          ? _value._evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<CheckpointEvidence>,
      maxDistanceM: freezed == maxDistanceM
          ? _value.maxDistanceM
          : maxDistanceM // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CheckpointReachRequestImpl implements _CheckpointReachRequest {
  const _$CheckpointReachRequestImpl(
      {required this.lat,
      required this.lon,
      this.notes,
      final List<CheckpointEvidence> evidences = const [],
      this.maxDistanceM})
      : _evidences = evidences;

  factory _$CheckpointReachRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckpointReachRequestImplFromJson(json);

  @override
  final double lat;
  @override
  final double lon;
  @override
  final String? notes;
  final List<CheckpointEvidence> _evidences;
  @override
  @JsonKey()
  List<CheckpointEvidence> get evidences {
    if (_evidences is EqualUnmodifiableListView) return _evidences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidences);
  }

  @override
  final double? maxDistanceM;

  @override
  String toString() {
    return 'CheckpointReachRequest(lat: $lat, lon: $lon, notes: $notes, evidences: $evidences, maxDistanceM: $maxDistanceM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointReachRequestImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._evidences, _evidences) &&
            (identical(other.maxDistanceM, maxDistanceM) ||
                other.maxDistanceM == maxDistanceM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lon, notes,
      const DeepCollectionEquality().hash(_evidences), maxDistanceM);

  /// Create a copy of CheckpointReachRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointReachRequestImplCopyWith<_$CheckpointReachRequestImpl>
      get copyWith => __$$CheckpointReachRequestImplCopyWithImpl<
          _$CheckpointReachRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckpointReachRequestImplToJson(
      this,
    );
  }
}

abstract class _CheckpointReachRequest implements CheckpointReachRequest {
  const factory _CheckpointReachRequest(
      {required final double lat,
      required final double lon,
      final String? notes,
      final List<CheckpointEvidence> evidences,
      final double? maxDistanceM}) = _$CheckpointReachRequestImpl;

  factory _CheckpointReachRequest.fromJson(Map<String, dynamic> json) =
      _$CheckpointReachRequestImpl.fromJson;

  @override
  double get lat;
  @override
  double get lon;
  @override
  String? get notes;
  @override
  List<CheckpointEvidence> get evidences;
  @override
  double? get maxDistanceM;

  /// Create a copy of CheckpointReachRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointReachRequestImplCopyWith<_$CheckpointReachRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
