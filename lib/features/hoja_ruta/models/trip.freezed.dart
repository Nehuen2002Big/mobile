// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  String get imei => throw _privateConstructorUsedError;
  String? get routeId => throw _privateConstructorUsedError;
  int? get vehicleId => throw _privateConstructorUsedError;
  String? get driverPersonId => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: TripStatus.unknown)
  TripStatus get status => throw _privateConstructorUsedError;
  double? get thresholdM => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get activeAlerts => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt =>
      throw _privateConstructorUsedError; // Coords del origen/destino (snapshot al crear el viaje).
  double? get originLat => throw _privateConstructorUsedError;
  double? get originLon => throw _privateConstructorUsedError;
  double? get destinationLat => throw _privateConstructorUsedError;
  double? get destinationLon =>
      throw _privateConstructorUsedError; // Progreso acumulado (monotonico) y largo total de la ruta planeada.
  double get maxRouteProgressM => throw _privateConstructorUsedError;
  double? get routeTotalM => throw _privateConstructorUsedError;
  Map<String, dynamic> get params => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call(
      {String id,
      String imei,
      String? routeId,
      int? vehicleId,
      String? driverPersonId,
      @JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus status,
      double? thresholdM,
      int totalPoints,
      int activeAlerts,
      DateTime? createdAt,
      DateTime? startedAt,
      DateTime? finishedAt,
      double? originLat,
      double? originLon,
      double? destinationLat,
      double? destinationLon,
      double maxRouteProgressM,
      double? routeTotalM,
      Map<String, dynamic> params});
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imei = null,
    Object? routeId = freezed,
    Object? vehicleId = freezed,
    Object? driverPersonId = freezed,
    Object? status = null,
    Object? thresholdM = freezed,
    Object? totalPoints = null,
    Object? activeAlerts = null,
    Object? createdAt = freezed,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? originLat = freezed,
    Object? originLon = freezed,
    Object? destinationLat = freezed,
    Object? destinationLon = freezed,
    Object? maxRouteProgressM = null,
    Object? routeTotalM = freezed,
    Object? params = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as int?,
      driverPersonId: freezed == driverPersonId
          ? _value.driverPersonId
          : driverPersonId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      thresholdM: freezed == thresholdM
          ? _value.thresholdM
          : thresholdM // ignore: cast_nullable_to_non_nullable
              as double?,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      originLat: freezed == originLat
          ? _value.originLat
          : originLat // ignore: cast_nullable_to_non_nullable
              as double?,
      originLon: freezed == originLon
          ? _value.originLon
          : originLon // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLat: freezed == destinationLat
          ? _value.destinationLat
          : destinationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLon: freezed == destinationLon
          ? _value.destinationLon
          : destinationLon // ignore: cast_nullable_to_non_nullable
              as double?,
      maxRouteProgressM: null == maxRouteProgressM
          ? _value.maxRouteProgressM
          : maxRouteProgressM // ignore: cast_nullable_to_non_nullable
              as double,
      routeTotalM: freezed == routeTotalM
          ? _value.routeTotalM
          : routeTotalM // ignore: cast_nullable_to_non_nullable
              as double?,
      params: null == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
          _$TripImpl value, $Res Function(_$TripImpl) then) =
      __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imei,
      String? routeId,
      int? vehicleId,
      String? driverPersonId,
      @JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus status,
      double? thresholdM,
      int totalPoints,
      int activeAlerts,
      DateTime? createdAt,
      DateTime? startedAt,
      DateTime? finishedAt,
      double? originLat,
      double? originLon,
      double? destinationLat,
      double? destinationLon,
      double maxRouteProgressM,
      double? routeTotalM,
      Map<String, dynamic> params});
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
      : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imei = null,
    Object? routeId = freezed,
    Object? vehicleId = freezed,
    Object? driverPersonId = freezed,
    Object? status = null,
    Object? thresholdM = freezed,
    Object? totalPoints = null,
    Object? activeAlerts = null,
    Object? createdAt = freezed,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? originLat = freezed,
    Object? originLon = freezed,
    Object? destinationLat = freezed,
    Object? destinationLon = freezed,
    Object? maxRouteProgressM = null,
    Object? routeTotalM = freezed,
    Object? params = null,
  }) {
    return _then(_$TripImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as int?,
      driverPersonId: freezed == driverPersonId
          ? _value.driverPersonId
          : driverPersonId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      thresholdM: freezed == thresholdM
          ? _value.thresholdM
          : thresholdM // ignore: cast_nullable_to_non_nullable
              as double?,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      originLat: freezed == originLat
          ? _value.originLat
          : originLat // ignore: cast_nullable_to_non_nullable
              as double?,
      originLon: freezed == originLon
          ? _value.originLon
          : originLon // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLat: freezed == destinationLat
          ? _value.destinationLat
          : destinationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLon: freezed == destinationLon
          ? _value.destinationLon
          : destinationLon // ignore: cast_nullable_to_non_nullable
              as double?,
      maxRouteProgressM: null == maxRouteProgressM
          ? _value.maxRouteProgressM
          : maxRouteProgressM // ignore: cast_nullable_to_non_nullable
              as double,
      routeTotalM: freezed == routeTotalM
          ? _value.routeTotalM
          : routeTotalM // ignore: cast_nullable_to_non_nullable
              as double?,
      params: null == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TripImpl extends _Trip {
  const _$TripImpl(
      {required this.id,
      this.imei = '',
      this.routeId,
      this.vehicleId,
      this.driverPersonId,
      @JsonKey(unknownEnumValue: TripStatus.unknown)
      this.status = TripStatus.unknown,
      this.thresholdM,
      this.totalPoints = 0,
      this.activeAlerts = 0,
      this.createdAt,
      this.startedAt,
      this.finishedAt,
      this.originLat,
      this.originLon,
      this.destinationLat,
      this.destinationLon,
      this.maxRouteProgressM = 0.0,
      this.routeTotalM,
      final Map<String, dynamic> params = const {}})
      : _params = params,
        super._();

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String imei;
  @override
  final String? routeId;
  @override
  final int? vehicleId;
  @override
  final String? driverPersonId;
  @override
  @JsonKey(unknownEnumValue: TripStatus.unknown)
  final TripStatus status;
  @override
  final double? thresholdM;
  @override
  @JsonKey()
  final int totalPoints;
  @override
  @JsonKey()
  final int activeAlerts;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? finishedAt;
// Coords del origen/destino (snapshot al crear el viaje).
  @override
  final double? originLat;
  @override
  final double? originLon;
  @override
  final double? destinationLat;
  @override
  final double? destinationLon;
// Progreso acumulado (monotonico) y largo total de la ruta planeada.
  @override
  @JsonKey()
  final double maxRouteProgressM;
  @override
  final double? routeTotalM;
  final Map<String, dynamic> _params;
  @override
  @JsonKey()
  Map<String, dynamic> get params {
    if (_params is EqualUnmodifiableMapView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_params);
  }

  @override
  String toString() {
    return 'Trip(id: $id, imei: $imei, routeId: $routeId, vehicleId: $vehicleId, driverPersonId: $driverPersonId, status: $status, thresholdM: $thresholdM, totalPoints: $totalPoints, activeAlerts: $activeAlerts, createdAt: $createdAt, startedAt: $startedAt, finishedAt: $finishedAt, originLat: $originLat, originLon: $originLon, destinationLat: $destinationLat, destinationLon: $destinationLon, maxRouteProgressM: $maxRouteProgressM, routeTotalM: $routeTotalM, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imei, imei) || other.imei == imei) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.driverPersonId, driverPersonId) ||
                other.driverPersonId == driverPersonId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.thresholdM, thresholdM) ||
                other.thresholdM == thresholdM) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.activeAlerts, activeAlerts) ||
                other.activeAlerts == activeAlerts) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.originLat, originLat) ||
                other.originLat == originLat) &&
            (identical(other.originLon, originLon) ||
                other.originLon == originLon) &&
            (identical(other.destinationLat, destinationLat) ||
                other.destinationLat == destinationLat) &&
            (identical(other.destinationLon, destinationLon) ||
                other.destinationLon == destinationLon) &&
            (identical(other.maxRouteProgressM, maxRouteProgressM) ||
                other.maxRouteProgressM == maxRouteProgressM) &&
            (identical(other.routeTotalM, routeTotalM) ||
                other.routeTotalM == routeTotalM) &&
            const DeepCollectionEquality().equals(other._params, _params));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        imei,
        routeId,
        vehicleId,
        driverPersonId,
        status,
        thresholdM,
        totalPoints,
        activeAlerts,
        createdAt,
        startedAt,
        finishedAt,
        originLat,
        originLon,
        destinationLat,
        destinationLon,
        maxRouteProgressM,
        routeTotalM,
        const DeepCollectionEquality().hash(_params)
      ]);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(
      this,
    );
  }
}

abstract class _Trip extends Trip {
  const factory _Trip(
      {required final String id,
      final String imei,
      final String? routeId,
      final int? vehicleId,
      final String? driverPersonId,
      @JsonKey(unknownEnumValue: TripStatus.unknown) final TripStatus status,
      final double? thresholdM,
      final int totalPoints,
      final int activeAlerts,
      final DateTime? createdAt,
      final DateTime? startedAt,
      final DateTime? finishedAt,
      final double? originLat,
      final double? originLon,
      final double? destinationLat,
      final double? destinationLon,
      final double maxRouteProgressM,
      final double? routeTotalM,
      final Map<String, dynamic> params}) = _$TripImpl;
  const _Trip._() : super._();

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  String get id;
  @override
  String get imei;
  @override
  String? get routeId;
  @override
  int? get vehicleId;
  @override
  String? get driverPersonId;
  @override
  @JsonKey(unknownEnumValue: TripStatus.unknown)
  TripStatus get status;
  @override
  double? get thresholdM;
  @override
  int get totalPoints;
  @override
  int get activeAlerts;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime?
      get finishedAt; // Coords del origen/destino (snapshot al crear el viaje).
  @override
  double? get originLat;
  @override
  double? get originLon;
  @override
  double? get destinationLat;
  @override
  double?
      get destinationLon; // Progreso acumulado (monotonico) y largo total de la ruta planeada.
  @override
  double get maxRouteProgressM;
  @override
  double? get routeTotalM;
  @override
  Map<String, dynamic> get params;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
