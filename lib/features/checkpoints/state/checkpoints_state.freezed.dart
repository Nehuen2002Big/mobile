// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoints_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckpointsState {
  List<CheckpointInfo> get checkpoints => throw _privateConstructorUsedError;
  int? get nextCheckpointIndex => throw _privateConstructorUsedError;
  int get reachedCount => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get marking => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CheckpointsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointsStateCopyWith<CheckpointsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointsStateCopyWith<$Res> {
  factory $CheckpointsStateCopyWith(
          CheckpointsState value, $Res Function(CheckpointsState) then) =
      _$CheckpointsStateCopyWithImpl<$Res, CheckpointsState>;
  @useResult
  $Res call(
      {List<CheckpointInfo> checkpoints,
      int? nextCheckpointIndex,
      int reachedCount,
      int total,
      bool loading,
      bool marking,
      String? error});
}

/// @nodoc
class _$CheckpointsStateCopyWithImpl<$Res, $Val extends CheckpointsState>
    implements $CheckpointsStateCopyWith<$Res> {
  _$CheckpointsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckpointsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkpoints = null,
    Object? nextCheckpointIndex = freezed,
    Object? reachedCount = null,
    Object? total = null,
    Object? loading = null,
    Object? marking = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      checkpoints: null == checkpoints
          ? _value.checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<CheckpointInfo>,
      nextCheckpointIndex: freezed == nextCheckpointIndex
          ? _value.nextCheckpointIndex
          : nextCheckpointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      reachedCount: null == reachedCount
          ? _value.reachedCount
          : reachedCount // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      marking: null == marking
          ? _value.marking
          : marking // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointsStateImplCopyWith<$Res>
    implements $CheckpointsStateCopyWith<$Res> {
  factory _$$CheckpointsStateImplCopyWith(_$CheckpointsStateImpl value,
          $Res Function(_$CheckpointsStateImpl) then) =
      __$$CheckpointsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CheckpointInfo> checkpoints,
      int? nextCheckpointIndex,
      int reachedCount,
      int total,
      bool loading,
      bool marking,
      String? error});
}

/// @nodoc
class __$$CheckpointsStateImplCopyWithImpl<$Res>
    extends _$CheckpointsStateCopyWithImpl<$Res, _$CheckpointsStateImpl>
    implements _$$CheckpointsStateImplCopyWith<$Res> {
  __$$CheckpointsStateImplCopyWithImpl(_$CheckpointsStateImpl _value,
      $Res Function(_$CheckpointsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckpointsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkpoints = null,
    Object? nextCheckpointIndex = freezed,
    Object? reachedCount = null,
    Object? total = null,
    Object? loading = null,
    Object? marking = null,
    Object? error = freezed,
  }) {
    return _then(_$CheckpointsStateImpl(
      checkpoints: null == checkpoints
          ? _value._checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<CheckpointInfo>,
      nextCheckpointIndex: freezed == nextCheckpointIndex
          ? _value.nextCheckpointIndex
          : nextCheckpointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      reachedCount: null == reachedCount
          ? _value.reachedCount
          : reachedCount // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      marking: null == marking
          ? _value.marking
          : marking // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CheckpointsStateImpl
    with DiagnosticableTreeMixin
    implements _CheckpointsState {
  const _$CheckpointsStateImpl(
      {final List<CheckpointInfo> checkpoints = const [],
      this.nextCheckpointIndex,
      this.reachedCount = 0,
      this.total = 0,
      this.loading = false,
      this.marking = false,
      this.error})
      : _checkpoints = checkpoints;

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
  final int reachedCount;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool marking;
  @override
  final String? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CheckpointsState(checkpoints: $checkpoints, nextCheckpointIndex: $nextCheckpointIndex, reachedCount: $reachedCount, total: $total, loading: $loading, marking: $marking, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CheckpointsState'))
      ..add(DiagnosticsProperty('checkpoints', checkpoints))
      ..add(DiagnosticsProperty('nextCheckpointIndex', nextCheckpointIndex))
      ..add(DiagnosticsProperty('reachedCount', reachedCount))
      ..add(DiagnosticsProperty('total', total))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('marking', marking))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._checkpoints, _checkpoints) &&
            (identical(other.nextCheckpointIndex, nextCheckpointIndex) ||
                other.nextCheckpointIndex == nextCheckpointIndex) &&
            (identical(other.reachedCount, reachedCount) ||
                other.reachedCount == reachedCount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.marking, marking) || other.marking == marking) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_checkpoints),
      nextCheckpointIndex,
      reachedCount,
      total,
      loading,
      marking,
      error);

  /// Create a copy of CheckpointsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointsStateImplCopyWith<_$CheckpointsStateImpl> get copyWith =>
      __$$CheckpointsStateImplCopyWithImpl<_$CheckpointsStateImpl>(
          this, _$identity);
}

abstract class _CheckpointsState implements CheckpointsState {
  const factory _CheckpointsState(
      {final List<CheckpointInfo> checkpoints,
      final int? nextCheckpointIndex,
      final int reachedCount,
      final int total,
      final bool loading,
      final bool marking,
      final String? error}) = _$CheckpointsStateImpl;

  @override
  List<CheckpointInfo> get checkpoints;
  @override
  int? get nextCheckpointIndex;
  @override
  int get reachedCount;
  @override
  int get total;
  @override
  bool get loading;
  @override
  bool get marking;
  @override
  String? get error;

  /// Create a copy of CheckpointsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointsStateImplCopyWith<_$CheckpointsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
