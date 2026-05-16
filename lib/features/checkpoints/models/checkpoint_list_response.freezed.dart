// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoint_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckpointListResponse _$CheckpointListResponseFromJson(
    Map<String, dynamic> json) {
  return _CheckpointListResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckpointListResponse {
  String get tripId => throw _privateConstructorUsedError;
  List<CheckpointInfo> get checkpoints => throw _privateConstructorUsedError;
  int? get nextCheckpointIndex => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get reachedCount => throw _privateConstructorUsedError;

  /// Serializes this CheckpointListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckpointListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointListResponseCopyWith<CheckpointListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointListResponseCopyWith<$Res> {
  factory $CheckpointListResponseCopyWith(CheckpointListResponse value,
          $Res Function(CheckpointListResponse) then) =
      _$CheckpointListResponseCopyWithImpl<$Res, CheckpointListResponse>;
  @useResult
  $Res call(
      {String tripId,
      List<CheckpointInfo> checkpoints,
      int? nextCheckpointIndex,
      int total,
      int reachedCount});
}

/// @nodoc
class _$CheckpointListResponseCopyWithImpl<$Res,
        $Val extends CheckpointListResponse>
    implements $CheckpointListResponseCopyWith<$Res> {
  _$CheckpointListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckpointListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? checkpoints = null,
    Object? nextCheckpointIndex = freezed,
    Object? total = null,
    Object? reachedCount = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      checkpoints: null == checkpoints
          ? _value.checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<CheckpointInfo>,
      nextCheckpointIndex: freezed == nextCheckpointIndex
          ? _value.nextCheckpointIndex
          : nextCheckpointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      reachedCount: null == reachedCount
          ? _value.reachedCount
          : reachedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointListResponseImplCopyWith<$Res>
    implements $CheckpointListResponseCopyWith<$Res> {
  factory _$$CheckpointListResponseImplCopyWith(
          _$CheckpointListResponseImpl value,
          $Res Function(_$CheckpointListResponseImpl) then) =
      __$$CheckpointListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tripId,
      List<CheckpointInfo> checkpoints,
      int? nextCheckpointIndex,
      int total,
      int reachedCount});
}

/// @nodoc
class __$$CheckpointListResponseImplCopyWithImpl<$Res>
    extends _$CheckpointListResponseCopyWithImpl<$Res,
        _$CheckpointListResponseImpl>
    implements _$$CheckpointListResponseImplCopyWith<$Res> {
  __$$CheckpointListResponseImplCopyWithImpl(
      _$CheckpointListResponseImpl _value,
      $Res Function(_$CheckpointListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckpointListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? checkpoints = null,
    Object? nextCheckpointIndex = freezed,
    Object? total = null,
    Object? reachedCount = null,
  }) {
    return _then(_$CheckpointListResponseImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      checkpoints: null == checkpoints
          ? _value._checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<CheckpointInfo>,
      nextCheckpointIndex: freezed == nextCheckpointIndex
          ? _value.nextCheckpointIndex
          : nextCheckpointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      reachedCount: null == reachedCount
          ? _value.reachedCount
          : reachedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CheckpointListResponseImpl implements _CheckpointListResponse {
  const _$CheckpointListResponseImpl(
      {required this.tripId,
      final List<CheckpointInfo> checkpoints = const [],
      this.nextCheckpointIndex,
      this.total = 0,
      this.reachedCount = 0})
      : _checkpoints = checkpoints;

  factory _$CheckpointListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckpointListResponseImplFromJson(json);

  @override
  final String tripId;
  final List<CheckpointInfo> _checkpoints;
  @override
  @JsonKey()
  List<CheckpointInfo> get checkpoints {
    if (_checkpoints is EqualUnmodifiableListView) return _checkpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checkpoints);
  }

  @override
  final int? nextCheckpointIndex;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int reachedCount;

  @override
  String toString() {
    return 'CheckpointListResponse(tripId: $tripId, checkpoints: $checkpoints, nextCheckpointIndex: $nextCheckpointIndex, total: $total, reachedCount: $reachedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointListResponseImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            const DeepCollectionEquality()
                .equals(other._checkpoints, _checkpoints) &&
            (identical(other.nextCheckpointIndex, nextCheckpointIndex) ||
                other.nextCheckpointIndex == nextCheckpointIndex) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.reachedCount, reachedCount) ||
                other.reachedCount == reachedCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tripId,
      const DeepCollectionEquality().hash(_checkpoints),
      nextCheckpointIndex,
      total,
      reachedCount);

  /// Create a copy of CheckpointListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointListResponseImplCopyWith<_$CheckpointListResponseImpl>
      get copyWith => __$$CheckpointListResponseImplCopyWithImpl<
          _$CheckpointListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckpointListResponseImplToJson(
      this,
    );
  }
}

abstract class _CheckpointListResponse implements CheckpointListResponse {
  const factory _CheckpointListResponse(
      {required final String tripId,
      final List<CheckpointInfo> checkpoints,
      final int? nextCheckpointIndex,
      final int total,
      final int reachedCount}) = _$CheckpointListResponseImpl;

  factory _CheckpointListResponse.fromJson(Map<String, dynamic> json) =
      _$CheckpointListResponseImpl.fromJson;

  @override
  String get tripId;
  @override
  List<CheckpointInfo> get checkpoints;
  @override
  int? get nextCheckpointIndex;
  @override
  int get total;
  @override
  int get reachedCount;

  /// Create a copy of CheckpointListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointListResponseImplCopyWith<_$CheckpointListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
