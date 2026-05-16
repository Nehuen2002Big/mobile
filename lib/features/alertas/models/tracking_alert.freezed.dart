// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrackingAlert _$TrackingAlertFromJson(Map<String, dynamic> json) {
  return _TrackingAlert.fromJson(json);
}

/// @nodoc
mixin _$TrackingAlert {
  int get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get alertType => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  double? get distToRouteM => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get acknowledgedAt => throw _privateConstructorUsedError;
  List<MessageAlertEvidence> get evidences =>
      throw _privateConstructorUsedError;
  String? get ruleType => throw _privateConstructorUsedError;
  String? get escalationLevel => throw _privateConstructorUsedError;
  DateTime? get escalatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get extra => throw _privateConstructorUsedError;

  /// `true` cuando el operador genero la alerta desde el simulador de
  /// QA (no es trafico real). La app del chofer la renderiza
  /// **identica a una real** (icono + badge + sonido) para que el
  /// flow de UI se pueda testear end-to-end. El flag esta solo por
  /// si en debug local quisieramos filtrar/loggear distinto — la UI
  /// del chofer NO lo expone.
  bool get simulated => throw _privateConstructorUsedError;

  /// Serializes this TrackingAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackingAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackingAlertCopyWith<TrackingAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackingAlertCopyWith<$Res> {
  factory $TrackingAlertCopyWith(
          TrackingAlert value, $Res Function(TrackingAlert) then) =
      _$TrackingAlertCopyWithImpl<$Res, TrackingAlert>;
  @useResult
  $Res call(
      {int id,
      String tripId,
      String alertType,
      double? lat,
      double? lon,
      double? distToRouteM,
      String? message,
      DateTime createdAt,
      DateTime? acknowledgedAt,
      List<MessageAlertEvidence> evidences,
      String? ruleType,
      String? escalationLevel,
      DateTime? escalatedAt,
      Map<String, dynamic>? extra,
      bool simulated});
}

/// @nodoc
class _$TrackingAlertCopyWithImpl<$Res, $Val extends TrackingAlert>
    implements $TrackingAlertCopyWith<$Res> {
  _$TrackingAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackingAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? alertType = null,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? distToRouteM = freezed,
    Object? message = freezed,
    Object? createdAt = null,
    Object? acknowledgedAt = freezed,
    Object? evidences = null,
    Object? ruleType = freezed,
    Object? escalationLevel = freezed,
    Object? escalatedAt = freezed,
    Object? extra = freezed,
    Object? simulated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      distToRouteM: freezed == distToRouteM
          ? _value.distToRouteM
          : distToRouteM // ignore: cast_nullable_to_non_nullable
              as double?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acknowledgedAt: freezed == acknowledgedAt
          ? _value.acknowledgedAt
          : acknowledgedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      evidences: null == evidences
          ? _value.evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<MessageAlertEvidence>,
      ruleType: freezed == ruleType
          ? _value.ruleType
          : ruleType // ignore: cast_nullable_to_non_nullable
              as String?,
      escalationLevel: freezed == escalationLevel
          ? _value.escalationLevel
          : escalationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      escalatedAt: freezed == escalatedAt
          ? _value.escalatedAt
          : escalatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      simulated: null == simulated
          ? _value.simulated
          : simulated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrackingAlertImplCopyWith<$Res>
    implements $TrackingAlertCopyWith<$Res> {
  factory _$$TrackingAlertImplCopyWith(
          _$TrackingAlertImpl value, $Res Function(_$TrackingAlertImpl) then) =
      __$$TrackingAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String tripId,
      String alertType,
      double? lat,
      double? lon,
      double? distToRouteM,
      String? message,
      DateTime createdAt,
      DateTime? acknowledgedAt,
      List<MessageAlertEvidence> evidences,
      String? ruleType,
      String? escalationLevel,
      DateTime? escalatedAt,
      Map<String, dynamic>? extra,
      bool simulated});
}

/// @nodoc
class __$$TrackingAlertImplCopyWithImpl<$Res>
    extends _$TrackingAlertCopyWithImpl<$Res, _$TrackingAlertImpl>
    implements _$$TrackingAlertImplCopyWith<$Res> {
  __$$TrackingAlertImplCopyWithImpl(
      _$TrackingAlertImpl _value, $Res Function(_$TrackingAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrackingAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? alertType = null,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? distToRouteM = freezed,
    Object? message = freezed,
    Object? createdAt = null,
    Object? acknowledgedAt = freezed,
    Object? evidences = null,
    Object? ruleType = freezed,
    Object? escalationLevel = freezed,
    Object? escalatedAt = freezed,
    Object? extra = freezed,
    Object? simulated = null,
  }) {
    return _then(_$TrackingAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      distToRouteM: freezed == distToRouteM
          ? _value.distToRouteM
          : distToRouteM // ignore: cast_nullable_to_non_nullable
              as double?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acknowledgedAt: freezed == acknowledgedAt
          ? _value.acknowledgedAt
          : acknowledgedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      evidences: null == evidences
          ? _value._evidences
          : evidences // ignore: cast_nullable_to_non_nullable
              as List<MessageAlertEvidence>,
      ruleType: freezed == ruleType
          ? _value.ruleType
          : ruleType // ignore: cast_nullable_to_non_nullable
              as String?,
      escalationLevel: freezed == escalationLevel
          ? _value.escalationLevel
          : escalationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      escalatedAt: freezed == escalatedAt
          ? _value.escalatedAt
          : escalatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      extra: freezed == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      simulated: null == simulated
          ? _value.simulated
          : simulated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TrackingAlertImpl extends _TrackingAlert {
  const _$TrackingAlertImpl(
      {required this.id,
      this.tripId = '',
      this.alertType = '',
      this.lat,
      this.lon,
      this.distToRouteM,
      this.message,
      required this.createdAt,
      this.acknowledgedAt,
      final List<MessageAlertEvidence> evidences = const [],
      this.ruleType,
      this.escalationLevel,
      this.escalatedAt,
      final Map<String, dynamic>? extra,
      this.simulated = false})
      : _evidences = evidences,
        _extra = extra,
        super._();

  factory _$TrackingAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackingAlertImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String tripId;
  @override
  @JsonKey()
  final String alertType;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  final double? distToRouteM;
  @override
  final String? message;
  @override
  final DateTime createdAt;
  @override
  final DateTime? acknowledgedAt;
  final List<MessageAlertEvidence> _evidences;
  @override
  @JsonKey()
  List<MessageAlertEvidence> get evidences {
    if (_evidences is EqualUnmodifiableListView) return _evidences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidences);
  }

  @override
  final String? ruleType;
  @override
  final String? escalationLevel;
  @override
  final DateTime? escalatedAt;
  final Map<String, dynamic>? _extra;
  @override
  Map<String, dynamic>? get extra {
    final value = _extra;
    if (value == null) return null;
    if (_extra is EqualUnmodifiableMapView) return _extra;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// `true` cuando el operador genero la alerta desde el simulador de
  /// QA (no es trafico real). La app del chofer la renderiza
  /// **identica a una real** (icono + badge + sonido) para que el
  /// flow de UI se pueda testear end-to-end. El flag esta solo por
  /// si en debug local quisieramos filtrar/loggear distinto — la UI
  /// del chofer NO lo expone.
  @override
  @JsonKey()
  final bool simulated;

  @override
  String toString() {
    return 'TrackingAlert(id: $id, tripId: $tripId, alertType: $alertType, lat: $lat, lon: $lon, distToRouteM: $distToRouteM, message: $message, createdAt: $createdAt, acknowledgedAt: $acknowledgedAt, evidences: $evidences, ruleType: $ruleType, escalationLevel: $escalationLevel, escalatedAt: $escalatedAt, extra: $extra, simulated: $simulated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackingAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.distToRouteM, distToRouteM) ||
                other.distToRouteM == distToRouteM) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acknowledgedAt, acknowledgedAt) ||
                other.acknowledgedAt == acknowledgedAt) &&
            const DeepCollectionEquality()
                .equals(other._evidences, _evidences) &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            (identical(other.escalationLevel, escalationLevel) ||
                other.escalationLevel == escalationLevel) &&
            (identical(other.escalatedAt, escalatedAt) ||
                other.escalatedAt == escalatedAt) &&
            const DeepCollectionEquality().equals(other._extra, _extra) &&
            (identical(other.simulated, simulated) ||
                other.simulated == simulated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tripId,
      alertType,
      lat,
      lon,
      distToRouteM,
      message,
      createdAt,
      acknowledgedAt,
      const DeepCollectionEquality().hash(_evidences),
      ruleType,
      escalationLevel,
      escalatedAt,
      const DeepCollectionEquality().hash(_extra),
      simulated);

  /// Create a copy of TrackingAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackingAlertImplCopyWith<_$TrackingAlertImpl> get copyWith =>
      __$$TrackingAlertImplCopyWithImpl<_$TrackingAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackingAlertImplToJson(
      this,
    );
  }
}

abstract class _TrackingAlert extends TrackingAlert {
  const factory _TrackingAlert(
      {required final int id,
      final String tripId,
      final String alertType,
      final double? lat,
      final double? lon,
      final double? distToRouteM,
      final String? message,
      required final DateTime createdAt,
      final DateTime? acknowledgedAt,
      final List<MessageAlertEvidence> evidences,
      final String? ruleType,
      final String? escalationLevel,
      final DateTime? escalatedAt,
      final Map<String, dynamic>? extra,
      final bool simulated}) = _$TrackingAlertImpl;
  const _TrackingAlert._() : super._();

  factory _TrackingAlert.fromJson(Map<String, dynamic> json) =
      _$TrackingAlertImpl.fromJson;

  @override
  int get id;
  @override
  String get tripId;
  @override
  String get alertType;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  double? get distToRouteM;
  @override
  String? get message;
  @override
  DateTime get createdAt;
  @override
  DateTime? get acknowledgedAt;
  @override
  List<MessageAlertEvidence> get evidences;
  @override
  String? get ruleType;
  @override
  String? get escalationLevel;
  @override
  DateTime? get escalatedAt;
  @override
  Map<String, dynamic>? get extra;

  /// `true` cuando el operador genero la alerta desde el simulador de
  /// QA (no es trafico real). La app del chofer la renderiza
  /// **identica a una real** (icono + badge + sonido) para que el
  /// flow de UI se pueda testear end-to-end. El flag esta solo por
  /// si en debug local quisieramos filtrar/loggear distinto — la UI
  /// del chofer NO lo expone.
  @override
  bool get simulated;

  /// Create a copy of TrackingAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackingAlertImplCopyWith<_$TrackingAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PendingActionAlertsResponse _$PendingActionAlertsResponseFromJson(
    Map<String, dynamic> json) {
  return _PendingActionAlertsResponse.fromJson(json);
}

/// @nodoc
mixin _$PendingActionAlertsResponse {
  List<TrackingAlert> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this PendingActionAlertsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PendingActionAlertsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingActionAlertsResponseCopyWith<PendingActionAlertsResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingActionAlertsResponseCopyWith<$Res> {
  factory $PendingActionAlertsResponseCopyWith(
          PendingActionAlertsResponse value,
          $Res Function(PendingActionAlertsResponse) then) =
      _$PendingActionAlertsResponseCopyWithImpl<$Res,
          PendingActionAlertsResponse>;
  @useResult
  $Res call({List<TrackingAlert> items, int total});
}

/// @nodoc
class _$PendingActionAlertsResponseCopyWithImpl<$Res,
        $Val extends PendingActionAlertsResponse>
    implements $PendingActionAlertsResponseCopyWith<$Res> {
  _$PendingActionAlertsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingActionAlertsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PendingActionAlertsResponseImplCopyWith<$Res>
    implements $PendingActionAlertsResponseCopyWith<$Res> {
  factory _$$PendingActionAlertsResponseImplCopyWith(
          _$PendingActionAlertsResponseImpl value,
          $Res Function(_$PendingActionAlertsResponseImpl) then) =
      __$$PendingActionAlertsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TrackingAlert> items, int total});
}

/// @nodoc
class __$$PendingActionAlertsResponseImplCopyWithImpl<$Res>
    extends _$PendingActionAlertsResponseCopyWithImpl<$Res,
        _$PendingActionAlertsResponseImpl>
    implements _$$PendingActionAlertsResponseImplCopyWith<$Res> {
  __$$PendingActionAlertsResponseImplCopyWithImpl(
      _$PendingActionAlertsResponseImpl _value,
      $Res Function(_$PendingActionAlertsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PendingActionAlertsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
  }) {
    return _then(_$PendingActionAlertsResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TrackingAlert>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PendingActionAlertsResponseImpl
    implements _PendingActionAlertsResponse {
  const _$PendingActionAlertsResponseImpl(
      {final List<TrackingAlert> items = const [], this.total = 0})
      : _items = items;

  factory _$PendingActionAlertsResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PendingActionAlertsResponseImplFromJson(json);

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
  String toString() {
    return 'PendingActionAlertsResponse(items: $items, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingActionAlertsResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), total);

  /// Create a copy of PendingActionAlertsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingActionAlertsResponseImplCopyWith<_$PendingActionAlertsResponseImpl>
      get copyWith => __$$PendingActionAlertsResponseImplCopyWithImpl<
          _$PendingActionAlertsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingActionAlertsResponseImplToJson(
      this,
    );
  }
}

abstract class _PendingActionAlertsResponse
    implements PendingActionAlertsResponse {
  const factory _PendingActionAlertsResponse(
      {final List<TrackingAlert> items,
      final int total}) = _$PendingActionAlertsResponseImpl;

  factory _PendingActionAlertsResponse.fromJson(Map<String, dynamic> json) =
      _$PendingActionAlertsResponseImpl.fromJson;

  @override
  List<TrackingAlert> get items;
  @override
  int get total;

  /// Create a copy of PendingActionAlertsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingActionAlertsResponseImplCopyWith<_$PendingActionAlertsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
