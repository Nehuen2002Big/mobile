// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_action_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PendingActionState {
  List<TrackingAlert> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  dynamic get acking => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of PendingActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingActionStateCopyWith<PendingActionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingActionStateCopyWith<$Res> {
  factory $PendingActionStateCopyWith(
          PendingActionState value, $Res Function(PendingActionState) then) =
      _$PendingActionStateCopyWithImpl<$Res, PendingActionState>;
  @useResult
  $Res call(
      {List<TrackingAlert> items,
      int total,
      bool loading,
      dynamic acking,
      String? error});
}

/// @nodoc
class _$PendingActionStateCopyWithImpl<$Res, $Val extends PendingActionState>
    implements $PendingActionStateCopyWith<$Res> {
  _$PendingActionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? loading = null,
    Object? acking = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TrackingAlert>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      acking: freezed == acking
          ? _value.acking
          : acking // ignore: cast_nullable_to_non_nullable
              as dynamic,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PendingActionStateImplCopyWith<$Res>
    implements $PendingActionStateCopyWith<$Res> {
  factory _$$PendingActionStateImplCopyWith(_$PendingActionStateImpl value,
          $Res Function(_$PendingActionStateImpl) then) =
      __$$PendingActionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TrackingAlert> items,
      int total,
      bool loading,
      dynamic acking,
      String? error});
}

/// @nodoc
class __$$PendingActionStateImplCopyWithImpl<$Res>
    extends _$PendingActionStateCopyWithImpl<$Res, _$PendingActionStateImpl>
    implements _$$PendingActionStateImplCopyWith<$Res> {
  __$$PendingActionStateImplCopyWithImpl(_$PendingActionStateImpl _value,
      $Res Function(_$PendingActionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PendingActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? loading = null,
    Object? acking = freezed,
    Object? error = freezed,
  }) {
    return _then(_$PendingActionStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TrackingAlert>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      acking: freezed == acking ? _value.acking! : acking,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PendingActionStateImpl extends _PendingActionState
    with DiagnosticableTreeMixin {
  const _$PendingActionStateImpl(
      {final List<TrackingAlert> items = const [],
      this.total = 0,
      this.loading = false,
      this.acking = false,
      this.error})
      : _items = items,
        super._();

  final List<TrackingAlert> _items;
  @override
  @JsonKey()
  List<TrackingAlert> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final dynamic acking;
  @override
  final String? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PendingActionState(items: $items, total: $total, loading: $loading, acking: $acking, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PendingActionState'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('total', total))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('acking', acking))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingActionStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.acking, acking) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      total,
      loading,
      const DeepCollectionEquality().hash(acking),
      error);

  /// Create a copy of PendingActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingActionStateImplCopyWith<_$PendingActionStateImpl> get copyWith =>
      __$$PendingActionStateImplCopyWithImpl<_$PendingActionStateImpl>(
          this, _$identity);
}

abstract class _PendingActionState extends PendingActionState {
  const factory _PendingActionState(
      {final List<TrackingAlert> items,
      final int total,
      final bool loading,
      final dynamic acking,
      final String? error}) = _$PendingActionStateImpl;
  const _PendingActionState._() : super._();

  @override
  List<TrackingAlert> get items;
  @override
  int get total;
  @override
  bool get loading;
  @override
  dynamic get acking;
  @override
  String? get error;

  /// Create a copy of PendingActionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingActionStateImplCopyWith<_$PendingActionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
