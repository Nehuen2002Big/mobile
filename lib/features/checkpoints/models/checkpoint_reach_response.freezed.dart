// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoint_reach_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckpointReachResponse _$CheckpointReachResponseFromJson(
    Map<String, dynamic> json) {
  return _CheckpointReachResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckpointReachResponse {
  String get tripId => throw _privateConstructorUsedError;
  int get checkpointIndex => throw _privateConstructorUsedError;
  DateTime get reachedAt => throw _privateConstructorUsedError;
  double get distanceToCheckpointM => throw _privateConstructorUsedError;
  int? get nextCheckpointIndex => throw _privateConstructorUsedError;
  bool get allDone => throw _privateConstructorUsedError;

  /// Serializes this CheckpointReachResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckpointReachResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointReachResponseCopyWith<CheckpointReachResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointReachResponseCopyWith<$Res> {
  factory $CheckpointReachResponseCopyWith(CheckpointReachResponse value,
          $Res Function(CheckpointReachResponse) then) =
      _$CheckpointReachResponseCopyWithImpl<$Res, CheckpointReachResponse>;
  @useResult
  $Res call(
      {String tripId,
      int checkpointIndex,
      DateTime reachedAt,
      double distanceToCheckpointM,
      int? nextCheckpointIndex,
      bool allDone});
}

/// @nodoc
class _$CheckpointReachResponseCopyWithImpl<$Res,
        $Val extends CheckpointReachResponse>
    implements $CheckpointReachResponseCopyWith<$Res> {
  _$CheckpointReachResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckpointReachResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? checkpointIndex = null,
    Object? reachedAt = null,
    Object? distanceToCheckpointM = null,
    Object? nextCheckpointIndex = freezed,
    Object? allDone = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      checkpointIndex: null == checkpointIndex
          ? _value.checkpointIndex
          : checkpointIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reachedAt: null == reachedAt
          ? _value.reachedAt
          : reachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distanceToCheckpointM: null == distanceToCheckpointM
          ? _value.distanceToCheckpointM
          : distanceToCheckpointM // ignore: cast_nullable_to_non_nullable
              as double,
      nextCheckpointIndex: freezed == nextCheckpointIndex
          ? _value.nextCheckpointIndex
          : nextCheckpointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      allDone: null == allDone
          ? _value.allDone
          : allDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointReachResponseImplCopyWith<$Res>
    implements $CheckpointReachResponseCopyWith<$Res> {
  factory _$$CheckpointReachResponseImplCopyWith(
          _$CheckpointReachResponseImpl value,
          $Res Function(_$CheckpointReachResponseImpl) then) =
      __$$CheckpointReachResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tripId,
      int checkpointIndex,
      DateTime reachedAt,
      double distanceToCheckpointM,
      int? nextCheckpointIndex,
      bool allDone});
}

/// @nodoc
class __$$CheckpointReachResponseImplCopyWithImpl<$Res>
    extends _$CheckpointReachResponseCopyWithImpl<$Res,
        _$CheckpointReachResponseImpl>
    implements _$$CheckpointReachResponseImplCopyWith<$Res> {
  __$$CheckpointReachResponseImplCopyWithImpl(
      _$CheckpointReachResponseImpl _value,
      $Res Function(_$CheckpointReachResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckpointReachResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? checkpointIndex = null,
    Object? reachedAt = null,
    Object? distanceToCheckpointM = null,
    Object? nextCheckpointIndex = freezed,
    Object? allDone = null,
  }) {
    return _then(_$CheckpointReachResponseImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      checkpointIndex: null == checkpointIndex
          ? _value.checkpointIndex
          : checkpointIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reachedAt: null == reachedAt
          ? _value.reachedAt
          : reachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distanceToCheckpointM: null == distanceToCheckpointM
          ? _value.distanceToCheckpointM
          : distanceToCheckpointM // ignore: cast_nullable_to_non_nullable
              as double,
      nextCheckpointIndex: freezed == nextCheckpointIndex
          ? _value.nextCheckpointIndex
          : nextCheckpointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      allDone: null == allDone
          ? _value.allDone
          : allDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CheckpointReachResponseImpl implements _CheckpointReachResponse {
  const _$CheckpointReachResponseImpl(
      {required this.tripId,
      required this.checkpointIndex,
      required this.reachedAt,
      required this.distanceToCheckpointM,
      this.nextCheckpointIndex,
      this.allDone = false});

  factory _$CheckpointReachResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckpointReachResponseImplFromJson(json);

  @override
  final String tripId;
  @override
  final int checkpointIndex;
  @override
  final DateTime reachedAt;
  @override
  final double distanceToCheckpointM;
  @override
  final int? nextCheckpointIndex;
  @override
  @JsonKey()
  final bool allDone;

  @override
  String toString() {
    return 'CheckpointReachResponse(tripId: $tripId, checkpointIndex: $checkpointIndex, reachedAt: $reachedAt, distanceToCheckpointM: $distanceToCheckpointM, nextCheckpointIndex: $nextCheckpointIndex, allDone: $allDone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointReachResponseImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.checkpointIndex, checkpointIndex) ||
                other.checkpointIndex == checkpointIndex) &&
            (identical(other.reachedAt, reachedAt) ||
                other.reachedAt == reachedAt) &&
            (identical(other.distanceToCheckpointM, distanceToCheckpointM) ||
                other.distanceToCheckpointM == distanceToCheckpointM) &&
            (identical(other.nextCheckpointIndex, nextCheckpointIndex) ||
                other.nextCheckpointIndex == nextCheckpointIndex) &&
            (identical(other.allDone, allDone) || other.allDone == allDone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tripId, checkpointIndex,
      reachedAt, distanceToCheckpointM, nextCheckpointIndex, allDone);

  /// Create a copy of CheckpointReachResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointReachResponseImplCopyWith<_$CheckpointReachResponseImpl>
      get copyWith => __$$CheckpointReachResponseImplCopyWithImpl<
          _$CheckpointReachResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckpointReachResponseImplToJson(
      this,
    );
  }
}

abstract class _CheckpointReachResponse implements CheckpointReachResponse {
  const factory _CheckpointReachResponse(
      {required final String tripId,
      required final int checkpointIndex,
      required final DateTime reachedAt,
      required final double distanceToCheckpointM,
      final int? nextCheckpointIndex,
      final bool allDone}) = _$CheckpointReachResponseImpl;

  factory _CheckpointReachResponse.fromJson(Map<String, dynamic> json) =
      _$CheckpointReachResponseImpl.fromJson;

  @override
  String get tripId;
  @override
  int get checkpointIndex;
  @override
  DateTime get reachedAt;
  @override
  double get distanceToCheckpointM;
  @override
  int? get nextCheckpointIndex;
  @override
  bool get allDone;

  /// Create a copy of CheckpointReachResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointReachResponseImplCopyWith<_$CheckpointReachResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
