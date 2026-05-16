// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthStateData {
  AuthStatus get status => throw _privateConstructorUsedError;
  AuthUser? get user => throw _privateConstructorUsedError;
  Perfil? get perfil => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateDataCopyWith<AuthStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateDataCopyWith<$Res> {
  factory $AuthStateDataCopyWith(
          AuthStateData value, $Res Function(AuthStateData) then) =
      _$AuthStateDataCopyWithImpl<$Res, AuthStateData>;
  @useResult
  $Res call(
      {AuthStatus status,
      AuthUser? user,
      Perfil? perfil,
      String? error,
      bool loading});

  $AuthUserCopyWith<$Res>? get user;
  $PerfilCopyWith<$Res>? get perfil;
}

/// @nodoc
class _$AuthStateDataCopyWithImpl<$Res, $Val extends AuthStateData>
    implements $AuthStateDataCopyWith<$Res> {
  _$AuthStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? user = freezed,
    Object? perfil = freezed,
    Object? error = freezed,
    Object? loading = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser?,
      perfil: freezed == perfil
          ? _value.perfil
          : perfil // ignore: cast_nullable_to_non_nullable
              as Perfil?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $AuthUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerfilCopyWith<$Res>? get perfil {
    if (_value.perfil == null) {
      return null;
    }

    return $PerfilCopyWith<$Res>(_value.perfil!, (value) {
      return _then(_value.copyWith(perfil: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateDataImplCopyWith<$Res>
    implements $AuthStateDataCopyWith<$Res> {
  factory _$$AuthStateDataImplCopyWith(
          _$AuthStateDataImpl value, $Res Function(_$AuthStateDataImpl) then) =
      __$$AuthStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthStatus status,
      AuthUser? user,
      Perfil? perfil,
      String? error,
      bool loading});

  @override
  $AuthUserCopyWith<$Res>? get user;
  @override
  $PerfilCopyWith<$Res>? get perfil;
}

/// @nodoc
class __$$AuthStateDataImplCopyWithImpl<$Res>
    extends _$AuthStateDataCopyWithImpl<$Res, _$AuthStateDataImpl>
    implements _$$AuthStateDataImplCopyWith<$Res> {
  __$$AuthStateDataImplCopyWithImpl(
      _$AuthStateDataImpl _value, $Res Function(_$AuthStateDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? user = freezed,
    Object? perfil = freezed,
    Object? error = freezed,
    Object? loading = null,
  }) {
    return _then(_$AuthStateDataImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser?,
      perfil: freezed == perfil
          ? _value.perfil
          : perfil // ignore: cast_nullable_to_non_nullable
              as Perfil?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthStateDataImpl
    with DiagnosticableTreeMixin
    implements _AuthStateData {
  const _$AuthStateDataImpl(
      {this.status = AuthStatus.desconocido,
      this.user,
      this.perfil,
      this.error,
      this.loading = false});

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  final AuthUser? user;
  @override
  final Perfil? perfil;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool loading;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthStateData(status: $status, user: $user, perfil: $perfil, error: $error, loading: $loading)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthStateData'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('perfil', perfil))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('loading', loading));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateDataImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.perfil, perfil) || other.perfil == perfil) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, user, perfil, error, loading);

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateDataImplCopyWith<_$AuthStateDataImpl> get copyWith =>
      __$$AuthStateDataImplCopyWithImpl<_$AuthStateDataImpl>(this, _$identity);
}

abstract class _AuthStateData implements AuthStateData {
  const factory _AuthStateData(
      {final AuthStatus status,
      final AuthUser? user,
      final Perfil? perfil,
      final String? error,
      final bool loading}) = _$AuthStateDataImpl;

  @override
  AuthStatus get status;
  @override
  AuthUser? get user;
  @override
  Perfil? get perfil;
  @override
  String? get error;
  @override
  bool get loading;

  /// Create a copy of AuthStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateDataImplCopyWith<_$AuthStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
