// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navegacion_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NavegacionState {
  /// Payload completo de la ruta computada por el backend.
  TripNavigation? get navigation => throw _privateConstructorUsedError;

  /// Cursor live: en que step estoy y cuanto falta a la proxima maniobra.
  RouteProgressResponse? get progress => throw _privateConstructorUsedError;

  /// Para detectar cuando el backend recomputa: si aumenta vs lo guardado,
  /// re-fetcheamos la nav.
  DateTime? get lastComputedAt => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get reintentando => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavegacionStateCopyWith<NavegacionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavegacionStateCopyWith<$Res> {
  factory $NavegacionStateCopyWith(
          NavegacionState value, $Res Function(NavegacionState) then) =
      _$NavegacionStateCopyWithImpl<$Res, NavegacionState>;
  @useResult
  $Res call(
      {TripNavigation? navigation,
      RouteProgressResponse? progress,
      DateTime? lastComputedAt,
      bool loading,
      bool reintentando,
      String? error});

  $TripNavigationCopyWith<$Res>? get navigation;
  $RouteProgressResponseCopyWith<$Res>? get progress;
}

/// @nodoc
class _$NavegacionStateCopyWithImpl<$Res, $Val extends NavegacionState>
    implements $NavegacionStateCopyWith<$Res> {
  _$NavegacionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navigation = freezed,
    Object? progress = freezed,
    Object? lastComputedAt = freezed,
    Object? loading = null,
    Object? reintentando = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      navigation: freezed == navigation
          ? _value.navigation
          : navigation // ignore: cast_nullable_to_non_nullable
              as TripNavigation?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as RouteProgressResponse?,
      lastComputedAt: freezed == lastComputedAt
          ? _value.lastComputedAt
          : lastComputedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      reintentando: null == reintentando
          ? _value.reintentando
          : reintentando // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripNavigationCopyWith<$Res>? get navigation {
    if (_value.navigation == null) {
      return null;
    }

    return $TripNavigationCopyWith<$Res>(_value.navigation!, (value) {
      return _then(_value.copyWith(navigation: value) as $Val);
    });
  }

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteProgressResponseCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $RouteProgressResponseCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavegacionStateImplCopyWith<$Res>
    implements $NavegacionStateCopyWith<$Res> {
  factory _$$NavegacionStateImplCopyWith(_$NavegacionStateImpl value,
          $Res Function(_$NavegacionStateImpl) then) =
      __$$NavegacionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TripNavigation? navigation,
      RouteProgressResponse? progress,
      DateTime? lastComputedAt,
      bool loading,
      bool reintentando,
      String? error});

  @override
  $TripNavigationCopyWith<$Res>? get navigation;
  @override
  $RouteProgressResponseCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$NavegacionStateImplCopyWithImpl<$Res>
    extends _$NavegacionStateCopyWithImpl<$Res, _$NavegacionStateImpl>
    implements _$$NavegacionStateImplCopyWith<$Res> {
  __$$NavegacionStateImplCopyWithImpl(
      _$NavegacionStateImpl _value, $Res Function(_$NavegacionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navigation = freezed,
    Object? progress = freezed,
    Object? lastComputedAt = freezed,
    Object? loading = null,
    Object? reintentando = null,
    Object? error = freezed,
  }) {
    return _then(_$NavegacionStateImpl(
      navigation: freezed == navigation
          ? _value.navigation
          : navigation // ignore: cast_nullable_to_non_nullable
              as TripNavigation?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as RouteProgressResponse?,
      lastComputedAt: freezed == lastComputedAt
          ? _value.lastComputedAt
          : lastComputedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      reintentando: null == reintentando
          ? _value.reintentando
          : reintentando // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NavegacionStateImpl extends _NavegacionState
    with DiagnosticableTreeMixin {
  const _$NavegacionStateImpl(
      {this.navigation,
      this.progress,
      this.lastComputedAt,
      this.loading = false,
      this.reintentando = false,
      this.error})
      : super._();

  /// Payload completo de la ruta computada por el backend.
  @override
  final TripNavigation? navigation;

  /// Cursor live: en que step estoy y cuanto falta a la proxima maniobra.
  @override
  final RouteProgressResponse? progress;

  /// Para detectar cuando el backend recomputa: si aumenta vs lo guardado,
  /// re-fetcheamos la nav.
  @override
  final DateTime? lastComputedAt;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool reintentando;
  @override
  final String? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NavegacionState(navigation: $navigation, progress: $progress, lastComputedAt: $lastComputedAt, loading: $loading, reintentando: $reintentando, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NavegacionState'))
      ..add(DiagnosticsProperty('navigation', navigation))
      ..add(DiagnosticsProperty('progress', progress))
      ..add(DiagnosticsProperty('lastComputedAt', lastComputedAt))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('reintentando', reintentando))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavegacionStateImpl &&
            (identical(other.navigation, navigation) ||
                other.navigation == navigation) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.lastComputedAt, lastComputedAt) ||
                other.lastComputedAt == lastComputedAt) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.reintentando, reintentando) ||
                other.reintentando == reintentando) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navigation, progress,
      lastComputedAt, loading, reintentando, error);

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavegacionStateImplCopyWith<_$NavegacionStateImpl> get copyWith =>
      __$$NavegacionStateImplCopyWithImpl<_$NavegacionStateImpl>(
          this, _$identity);
}

abstract class _NavegacionState extends NavegacionState {
  const factory _NavegacionState(
      {final TripNavigation? navigation,
      final RouteProgressResponse? progress,
      final DateTime? lastComputedAt,
      final bool loading,
      final bool reintentando,
      final String? error}) = _$NavegacionStateImpl;
  const _NavegacionState._() : super._();

  /// Payload completo de la ruta computada por el backend.
  @override
  TripNavigation? get navigation;

  /// Cursor live: en que step estoy y cuanto falta a la proxima maniobra.
  @override
  RouteProgressResponse? get progress;

  /// Para detectar cuando el backend recomputa: si aumenta vs lo guardado,
  /// re-fetcheamos la nav.
  @override
  DateTime? get lastComputedAt;
  @override
  bool get loading;
  @override
  bool get reintentando;
  @override
  String? get error;

  /// Create a copy of NavegacionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavegacionStateImplCopyWith<_$NavegacionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
