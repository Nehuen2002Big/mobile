// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatState {
  List<TripMessage> get items => throw _privateConstructorUsedError;
  int get unreadForDriver => throw _privateConstructorUsedError;
  int? get lastId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get sending => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Mensaje de tipo `[LLAMADA · ...]` recien recibido que la UI debe
  /// disparar como pantalla fake-call. Una vez consumido, se limpia con
  /// `marcarLlamadaConsumida()`.
  TripMessage? get pendingCall => throw _privateConstructorUsedError;

  /// Map de alertIds que el chofer ya ackeo localmente, junto con el
  /// timestamp del ack. Se usa para:
  /// 1) **Race protection (ventana 5s)**: ignorar mensajes con un
  ///    alertId ya ackeado que llegan en este lapso (estaban en
  ///    vuelo del paso anterior de la cascada y dispararian la
  ///    fake-call por nada). Despues de 5s, los mensajes se
  ///    procesan normal; el alertId queda en el map permanentemente.
  /// 2) **Render visual**: el chat muestra mensajes con `msg.alertId`
  ///    en este map como "✓ Resuelto" durante toda la sesion (sin
  ///    TTL — el chofer ve la confirmacion visual del ack).
  Map<int, DateTime> get alertasAcked => throw _privateConstructorUsedError;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call(
      {List<TripMessage> items,
      int unreadForDriver,
      int? lastId,
      bool loading,
      bool sending,
      String? error,
      TripMessage? pendingCall,
      Map<int, DateTime> alertasAcked});

  $TripMessageCopyWith<$Res>? get pendingCall;
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? unreadForDriver = null,
    Object? lastId = freezed,
    Object? loading = null,
    Object? sending = null,
    Object? error = freezed,
    Object? pendingCall = freezed,
    Object? alertasAcked = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TripMessage>,
      unreadForDriver: null == unreadForDriver
          ? _value.unreadForDriver
          : unreadForDriver // ignore: cast_nullable_to_non_nullable
              as int,
      lastId: freezed == lastId
          ? _value.lastId
          : lastId // ignore: cast_nullable_to_non_nullable
              as int?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: null == sending
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingCall: freezed == pendingCall
          ? _value.pendingCall
          : pendingCall // ignore: cast_nullable_to_non_nullable
              as TripMessage?,
      alertasAcked: null == alertasAcked
          ? _value.alertasAcked
          : alertasAcked // ignore: cast_nullable_to_non_nullable
              as Map<int, DateTime>,
    ) as $Val);
  }

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripMessageCopyWith<$Res>? get pendingCall {
    if (_value.pendingCall == null) {
      return null;
    }

    return $TripMessageCopyWith<$Res>(_value.pendingCall!, (value) {
      return _then(_value.copyWith(pendingCall: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatStateImplCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$$ChatStateImplCopyWith(
          _$ChatStateImpl value, $Res Function(_$ChatStateImpl) then) =
      __$$ChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TripMessage> items,
      int unreadForDriver,
      int? lastId,
      bool loading,
      bool sending,
      String? error,
      TripMessage? pendingCall,
      Map<int, DateTime> alertasAcked});

  @override
  $TripMessageCopyWith<$Res>? get pendingCall;
}

/// @nodoc
class __$$ChatStateImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateImpl>
    implements _$$ChatStateImplCopyWith<$Res> {
  __$$ChatStateImplCopyWithImpl(
      _$ChatStateImpl _value, $Res Function(_$ChatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? unreadForDriver = null,
    Object? lastId = freezed,
    Object? loading = null,
    Object? sending = null,
    Object? error = freezed,
    Object? pendingCall = freezed,
    Object? alertasAcked = null,
  }) {
    return _then(_$ChatStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TripMessage>,
      unreadForDriver: null == unreadForDriver
          ? _value.unreadForDriver
          : unreadForDriver // ignore: cast_nullable_to_non_nullable
              as int,
      lastId: freezed == lastId
          ? _value.lastId
          : lastId // ignore: cast_nullable_to_non_nullable
              as int?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: null == sending
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingCall: freezed == pendingCall
          ? _value.pendingCall
          : pendingCall // ignore: cast_nullable_to_non_nullable
              as TripMessage?,
      alertasAcked: null == alertasAcked
          ? _value._alertasAcked
          : alertasAcked // ignore: cast_nullable_to_non_nullable
              as Map<int, DateTime>,
    ));
  }
}

/// @nodoc

class _$ChatStateImpl with DiagnosticableTreeMixin implements _ChatState {
  const _$ChatStateImpl(
      {final List<TripMessage> items = const [],
      this.unreadForDriver = 0,
      this.lastId,
      this.loading = false,
      this.sending = false,
      this.error,
      this.pendingCall,
      final Map<int, DateTime> alertasAcked = const <int, DateTime>{}})
      : _items = items,
        _alertasAcked = alertasAcked;

  final List<TripMessage> _items;
  @override
  @JsonKey()
  List<TripMessage> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int unreadForDriver;
  @override
  final int? lastId;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool sending;
  @override
  final String? error;

  /// Mensaje de tipo `[LLAMADA · ...]` recien recibido que la UI debe
  /// disparar como pantalla fake-call. Una vez consumido, se limpia con
  /// `marcarLlamadaConsumida()`.
  @override
  final TripMessage? pendingCall;

  /// Map de alertIds que el chofer ya ackeo localmente, junto con el
  /// timestamp del ack. Se usa para:
  /// 1) **Race protection (ventana 5s)**: ignorar mensajes con un
  ///    alertId ya ackeado que llegan en este lapso (estaban en
  ///    vuelo del paso anterior de la cascada y dispararian la
  ///    fake-call por nada). Despues de 5s, los mensajes se
  ///    procesan normal; el alertId queda en el map permanentemente.
  /// 2) **Render visual**: el chat muestra mensajes con `msg.alertId`
  ///    en este map como "✓ Resuelto" durante toda la sesion (sin
  ///    TTL — el chofer ve la confirmacion visual del ack).
  final Map<int, DateTime> _alertasAcked;

  /// Map de alertIds que el chofer ya ackeo localmente, junto con el
  /// timestamp del ack. Se usa para:
  /// 1) **Race protection (ventana 5s)**: ignorar mensajes con un
  ///    alertId ya ackeado que llegan en este lapso (estaban en
  ///    vuelo del paso anterior de la cascada y dispararian la
  ///    fake-call por nada). Despues de 5s, los mensajes se
  ///    procesan normal; el alertId queda en el map permanentemente.
  /// 2) **Render visual**: el chat muestra mensajes con `msg.alertId`
  ///    en este map como "✓ Resuelto" durante toda la sesion (sin
  ///    TTL — el chofer ve la confirmacion visual del ack).
  @override
  @JsonKey()
  Map<int, DateTime> get alertasAcked {
    if (_alertasAcked is EqualUnmodifiableMapView) return _alertasAcked;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_alertasAcked);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ChatState(items: $items, unreadForDriver: $unreadForDriver, lastId: $lastId, loading: $loading, sending: $sending, error: $error, pendingCall: $pendingCall, alertasAcked: $alertasAcked)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ChatState'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('unreadForDriver', unreadForDriver))
      ..add(DiagnosticsProperty('lastId', lastId))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('sending', sending))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('pendingCall', pendingCall))
      ..add(DiagnosticsProperty('alertasAcked', alertasAcked));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.unreadForDriver, unreadForDriver) ||
                other.unreadForDriver == unreadForDriver) &&
            (identical(other.lastId, lastId) || other.lastId == lastId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.sending, sending) || other.sending == sending) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.pendingCall, pendingCall) ||
                other.pendingCall == pendingCall) &&
            const DeepCollectionEquality()
                .equals(other._alertasAcked, _alertasAcked));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      unreadForDriver,
      lastId,
      loading,
      sending,
      error,
      pendingCall,
      const DeepCollectionEquality().hash(_alertasAcked));

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      __$$ChatStateImplCopyWithImpl<_$ChatStateImpl>(this, _$identity);
}

abstract class _ChatState implements ChatState {
  const factory _ChatState(
      {final List<TripMessage> items,
      final int unreadForDriver,
      final int? lastId,
      final bool loading,
      final bool sending,
      final String? error,
      final TripMessage? pendingCall,
      final Map<int, DateTime> alertasAcked}) = _$ChatStateImpl;

  @override
  List<TripMessage> get items;
  @override
  int get unreadForDriver;
  @override
  int? get lastId;
  @override
  bool get loading;
  @override
  bool get sending;
  @override
  String? get error;

  /// Mensaje de tipo `[LLAMADA · ...]` recien recibido que la UI debe
  /// disparar como pantalla fake-call. Una vez consumido, se limpia con
  /// `marcarLlamadaConsumida()`.
  @override
  TripMessage? get pendingCall;

  /// Map de alertIds que el chofer ya ackeo localmente, junto con el
  /// timestamp del ack. Se usa para:
  /// 1) **Race protection (ventana 5s)**: ignorar mensajes con un
  ///    alertId ya ackeado que llegan en este lapso (estaban en
  ///    vuelo del paso anterior de la cascada y dispararian la
  ///    fake-call por nada). Despues de 5s, los mensajes se
  ///    procesan normal; el alertId queda en el map permanentemente.
  /// 2) **Render visual**: el chat muestra mensajes con `msg.alertId`
  ///    en este map como "✓ Resuelto" durante toda la sesion (sin
  ///    TTL — el chofer ve la confirmacion visual del ack).
  @override
  Map<int, DateTime> get alertasAcked;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
