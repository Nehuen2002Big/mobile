// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_navigation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripNavigation _$TripNavigationFromJson(Map<String, dynamic> json) {
  return _TripNavigation.fromJson(json);
}

/// @nodoc
mixin _$TripNavigation {
  String get tripId => throw _privateConstructorUsedError;
  DateTime get computedAt => throw _privateConstructorUsedError;
  String get routingEngine => throw _privateConstructorUsedError;
  double get totalDistanceM => throw _privateConstructorUsedError;
  double get totalDurationS => throw _privateConstructorUsedError;
  GeoJsonLineString get geometry => throw _privateConstructorUsedError;
  List<NavigationLeg> get legs => throw _privateConstructorUsedError;

  /// Serializes this TripNavigation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripNavigation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripNavigationCopyWith<TripNavigation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripNavigationCopyWith<$Res> {
  factory $TripNavigationCopyWith(
          TripNavigation value, $Res Function(TripNavigation) then) =
      _$TripNavigationCopyWithImpl<$Res, TripNavigation>;
  @useResult
  $Res call(
      {String tripId,
      DateTime computedAt,
      String routingEngine,
      double totalDistanceM,
      double totalDurationS,
      GeoJsonLineString geometry,
      List<NavigationLeg> legs});

  $GeoJsonLineStringCopyWith<$Res> get geometry;
}

/// @nodoc
class _$TripNavigationCopyWithImpl<$Res, $Val extends TripNavigation>
    implements $TripNavigationCopyWith<$Res> {
  _$TripNavigationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripNavigation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? computedAt = null,
    Object? routingEngine = null,
    Object? totalDistanceM = null,
    Object? totalDurationS = null,
    Object? geometry = null,
    Object? legs = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      computedAt: null == computedAt
          ? _value.computedAt
          : computedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      routingEngine: null == routingEngine
          ? _value.routingEngine
          : routingEngine // ignore: cast_nullable_to_non_nullable
              as String,
      totalDistanceM: null == totalDistanceM
          ? _value.totalDistanceM
          : totalDistanceM // ignore: cast_nullable_to_non_nullable
              as double,
      totalDurationS: null == totalDurationS
          ? _value.totalDurationS
          : totalDurationS // ignore: cast_nullable_to_non_nullable
              as double,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as GeoJsonLineString,
      legs: null == legs
          ? _value.legs
          : legs // ignore: cast_nullable_to_non_nullable
              as List<NavigationLeg>,
    ) as $Val);
  }

  /// Create a copy of TripNavigation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoJsonLineStringCopyWith<$Res> get geometry {
    return $GeoJsonLineStringCopyWith<$Res>(_value.geometry, (value) {
      return _then(_value.copyWith(geometry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripNavigationImplCopyWith<$Res>
    implements $TripNavigationCopyWith<$Res> {
  factory _$$TripNavigationImplCopyWith(_$TripNavigationImpl value,
          $Res Function(_$TripNavigationImpl) then) =
      __$$TripNavigationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tripId,
      DateTime computedAt,
      String routingEngine,
      double totalDistanceM,
      double totalDurationS,
      GeoJsonLineString geometry,
      List<NavigationLeg> legs});

  @override
  $GeoJsonLineStringCopyWith<$Res> get geometry;
}

/// @nodoc
class __$$TripNavigationImplCopyWithImpl<$Res>
    extends _$TripNavigationCopyWithImpl<$Res, _$TripNavigationImpl>
    implements _$$TripNavigationImplCopyWith<$Res> {
  __$$TripNavigationImplCopyWithImpl(
      _$TripNavigationImpl _value, $Res Function(_$TripNavigationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripNavigation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? computedAt = null,
    Object? routingEngine = null,
    Object? totalDistanceM = null,
    Object? totalDurationS = null,
    Object? geometry = null,
    Object? legs = null,
  }) {
    return _then(_$TripNavigationImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      computedAt: null == computedAt
          ? _value.computedAt
          : computedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      routingEngine: null == routingEngine
          ? _value.routingEngine
          : routingEngine // ignore: cast_nullable_to_non_nullable
              as String,
      totalDistanceM: null == totalDistanceM
          ? _value.totalDistanceM
          : totalDistanceM // ignore: cast_nullable_to_non_nullable
              as double,
      totalDurationS: null == totalDurationS
          ? _value.totalDurationS
          : totalDurationS // ignore: cast_nullable_to_non_nullable
              as double,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as GeoJsonLineString,
      legs: null == legs
          ? _value._legs
          : legs // ignore: cast_nullable_to_non_nullable
              as List<NavigationLeg>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TripNavigationImpl implements _TripNavigation {
  const _$TripNavigationImpl(
      {required this.tripId,
      required this.computedAt,
      this.routingEngine = 'osrm',
      this.totalDistanceM = 0.0,
      this.totalDurationS = 0.0,
      required this.geometry,
      final List<NavigationLeg> legs = const []})
      : _legs = legs;

  factory _$TripNavigationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripNavigationImplFromJson(json);

  @override
  final String tripId;
  @override
  final DateTime computedAt;
  @override
  @JsonKey()
  final String routingEngine;
  @override
  @JsonKey()
  final double totalDistanceM;
  @override
  @JsonKey()
  final double totalDurationS;
  @override
  final GeoJsonLineString geometry;
  final List<NavigationLeg> _legs;
  @override
  @JsonKey()
  List<NavigationLeg> get legs {
    if (_legs is EqualUnmodifiableListView) return _legs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_legs);
  }

  @override
  String toString() {
    return 'TripNavigation(tripId: $tripId, computedAt: $computedAt, routingEngine: $routingEngine, totalDistanceM: $totalDistanceM, totalDurationS: $totalDurationS, geometry: $geometry, legs: $legs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripNavigationImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.computedAt, computedAt) ||
                other.computedAt == computedAt) &&
            (identical(other.routingEngine, routingEngine) ||
                other.routingEngine == routingEngine) &&
            (identical(other.totalDistanceM, totalDistanceM) ||
                other.totalDistanceM == totalDistanceM) &&
            (identical(other.totalDurationS, totalDurationS) ||
                other.totalDurationS == totalDurationS) &&
            (identical(other.geometry, geometry) ||
                other.geometry == geometry) &&
            const DeepCollectionEquality().equals(other._legs, _legs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tripId,
      computedAt,
      routingEngine,
      totalDistanceM,
      totalDurationS,
      geometry,
      const DeepCollectionEquality().hash(_legs));

  /// Create a copy of TripNavigation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripNavigationImplCopyWith<_$TripNavigationImpl> get copyWith =>
      __$$TripNavigationImplCopyWithImpl<_$TripNavigationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripNavigationImplToJson(
      this,
    );
  }
}

abstract class _TripNavigation implements TripNavigation {
  const factory _TripNavigation(
      {required final String tripId,
      required final DateTime computedAt,
      final String routingEngine,
      final double totalDistanceM,
      final double totalDurationS,
      required final GeoJsonLineString geometry,
      final List<NavigationLeg> legs}) = _$TripNavigationImpl;

  factory _TripNavigation.fromJson(Map<String, dynamic> json) =
      _$TripNavigationImpl.fromJson;

  @override
  String get tripId;
  @override
  DateTime get computedAt;
  @override
  String get routingEngine;
  @override
  double get totalDistanceM;
  @override
  double get totalDurationS;
  @override
  GeoJsonLineString get geometry;
  @override
  List<NavigationLeg> get legs;

  /// Create a copy of TripNavigation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripNavigationImplCopyWith<_$TripNavigationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeoJsonLineString _$GeoJsonLineStringFromJson(Map<String, dynamic> json) {
  return _GeoJsonLineString.fromJson(json);
}

/// @nodoc
mixin _$GeoJsonLineString {
  String get type => throw _privateConstructorUsedError;
  List<List<double>> get coordinates => throw _privateConstructorUsedError;

  /// Serializes this GeoJsonLineString to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoJsonLineString
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoJsonLineStringCopyWith<GeoJsonLineString> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoJsonLineStringCopyWith<$Res> {
  factory $GeoJsonLineStringCopyWith(
          GeoJsonLineString value, $Res Function(GeoJsonLineString) then) =
      _$GeoJsonLineStringCopyWithImpl<$Res, GeoJsonLineString>;
  @useResult
  $Res call({String type, List<List<double>> coordinates});
}

/// @nodoc
class _$GeoJsonLineStringCopyWithImpl<$Res, $Val extends GeoJsonLineString>
    implements $GeoJsonLineStringCopyWith<$Res> {
  _$GeoJsonLineStringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoJsonLineString
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeoJsonLineStringImplCopyWith<$Res>
    implements $GeoJsonLineStringCopyWith<$Res> {
  factory _$$GeoJsonLineStringImplCopyWith(_$GeoJsonLineStringImpl value,
          $Res Function(_$GeoJsonLineStringImpl) then) =
      __$$GeoJsonLineStringImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<List<double>> coordinates});
}

/// @nodoc
class __$$GeoJsonLineStringImplCopyWithImpl<$Res>
    extends _$GeoJsonLineStringCopyWithImpl<$Res, _$GeoJsonLineStringImpl>
    implements _$$GeoJsonLineStringImplCopyWith<$Res> {
  __$$GeoJsonLineStringImplCopyWithImpl(_$GeoJsonLineStringImpl _value,
      $Res Function(_$GeoJsonLineStringImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeoJsonLineString
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
  }) {
    return _then(_$GeoJsonLineStringImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoJsonLineStringImpl implements _GeoJsonLineString {
  const _$GeoJsonLineStringImpl(
      {this.type = 'LineString',
      final List<List<double>> coordinates = const []})
      : _coordinates = coordinates;

  factory _$GeoJsonLineStringImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoJsonLineStringImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  final List<List<double>> _coordinates;
  @override
  @JsonKey()
  List<List<double>> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  String toString() {
    return 'GeoJsonLineString(type: $type, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoJsonLineStringImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_coordinates));

  /// Create a copy of GeoJsonLineString
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoJsonLineStringImplCopyWith<_$GeoJsonLineStringImpl> get copyWith =>
      __$$GeoJsonLineStringImplCopyWithImpl<_$GeoJsonLineStringImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoJsonLineStringImplToJson(
      this,
    );
  }
}

abstract class _GeoJsonLineString implements GeoJsonLineString {
  const factory _GeoJsonLineString(
      {final String type,
      final List<List<double>> coordinates}) = _$GeoJsonLineStringImpl;

  factory _GeoJsonLineString.fromJson(Map<String, dynamic> json) =
      _$GeoJsonLineStringImpl.fromJson;

  @override
  String get type;
  @override
  List<List<double>> get coordinates;

  /// Create a copy of GeoJsonLineString
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoJsonLineStringImplCopyWith<_$GeoJsonLineStringImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavigationLeg _$NavigationLegFromJson(Map<String, dynamic> json) {
  return _NavigationLeg.fromJson(json);
}

/// @nodoc
mixin _$NavigationLeg {
  /// "checkpoint" | "destination"
  String get target => throw _privateConstructorUsedError;
  int? get targetIndex => throw _privateConstructorUsedError;
  String get targetLabel => throw _privateConstructorUsedError;
  double get targetLat => throw _privateConstructorUsedError;
  double get targetLon => throw _privateConstructorUsedError;
  double get distanceM => throw _privateConstructorUsedError;
  double get durationS => throw _privateConstructorUsedError;
  List<NavigationStep> get steps => throw _privateConstructorUsedError;

  /// Serializes this NavigationLeg to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavigationLeg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavigationLegCopyWith<NavigationLeg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavigationLegCopyWith<$Res> {
  factory $NavigationLegCopyWith(
          NavigationLeg value, $Res Function(NavigationLeg) then) =
      _$NavigationLegCopyWithImpl<$Res, NavigationLeg>;
  @useResult
  $Res call(
      {String target,
      int? targetIndex,
      String targetLabel,
      double targetLat,
      double targetLon,
      double distanceM,
      double durationS,
      List<NavigationStep> steps});
}

/// @nodoc
class _$NavigationLegCopyWithImpl<$Res, $Val extends NavigationLeg>
    implements $NavigationLegCopyWith<$Res> {
  _$NavigationLegCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavigationLeg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = null,
    Object? targetIndex = freezed,
    Object? targetLabel = null,
    Object? targetLat = null,
    Object? targetLon = null,
    Object? distanceM = null,
    Object? durationS = null,
    Object? steps = null,
  }) {
    return _then(_value.copyWith(
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as String,
      targetIndex: freezed == targetIndex
          ? _value.targetIndex
          : targetIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      targetLabel: null == targetLabel
          ? _value.targetLabel
          : targetLabel // ignore: cast_nullable_to_non_nullable
              as String,
      targetLat: null == targetLat
          ? _value.targetLat
          : targetLat // ignore: cast_nullable_to_non_nullable
              as double,
      targetLon: null == targetLon
          ? _value.targetLon
          : targetLon // ignore: cast_nullable_to_non_nullable
              as double,
      distanceM: null == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double,
      durationS: null == durationS
          ? _value.durationS
          : durationS // ignore: cast_nullable_to_non_nullable
              as double,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<NavigationStep>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavigationLegImplCopyWith<$Res>
    implements $NavigationLegCopyWith<$Res> {
  factory _$$NavigationLegImplCopyWith(
          _$NavigationLegImpl value, $Res Function(_$NavigationLegImpl) then) =
      __$$NavigationLegImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String target,
      int? targetIndex,
      String targetLabel,
      double targetLat,
      double targetLon,
      double distanceM,
      double durationS,
      List<NavigationStep> steps});
}

/// @nodoc
class __$$NavigationLegImplCopyWithImpl<$Res>
    extends _$NavigationLegCopyWithImpl<$Res, _$NavigationLegImpl>
    implements _$$NavigationLegImplCopyWith<$Res> {
  __$$NavigationLegImplCopyWithImpl(
      _$NavigationLegImpl _value, $Res Function(_$NavigationLegImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavigationLeg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = null,
    Object? targetIndex = freezed,
    Object? targetLabel = null,
    Object? targetLat = null,
    Object? targetLon = null,
    Object? distanceM = null,
    Object? durationS = null,
    Object? steps = null,
  }) {
    return _then(_$NavigationLegImpl(
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as String,
      targetIndex: freezed == targetIndex
          ? _value.targetIndex
          : targetIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      targetLabel: null == targetLabel
          ? _value.targetLabel
          : targetLabel // ignore: cast_nullable_to_non_nullable
              as String,
      targetLat: null == targetLat
          ? _value.targetLat
          : targetLat // ignore: cast_nullable_to_non_nullable
              as double,
      targetLon: null == targetLon
          ? _value.targetLon
          : targetLon // ignore: cast_nullable_to_non_nullable
              as double,
      distanceM: null == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double,
      durationS: null == durationS
          ? _value.durationS
          : durationS // ignore: cast_nullable_to_non_nullable
              as double,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<NavigationStep>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$NavigationLegImpl extends _NavigationLeg {
  const _$NavigationLegImpl(
      {required this.target,
      this.targetIndex,
      this.targetLabel = '',
      this.targetLat = 0.0,
      this.targetLon = 0.0,
      this.distanceM = 0.0,
      this.durationS = 0.0,
      final List<NavigationStep> steps = const []})
      : _steps = steps,
        super._();

  factory _$NavigationLegImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavigationLegImplFromJson(json);

  /// "checkpoint" | "destination"
  @override
  final String target;
  @override
  final int? targetIndex;
  @override
  @JsonKey()
  final String targetLabel;
  @override
  @JsonKey()
  final double targetLat;
  @override
  @JsonKey()
  final double targetLon;
  @override
  @JsonKey()
  final double distanceM;
  @override
  @JsonKey()
  final double durationS;
  final List<NavigationStep> _steps;
  @override
  @JsonKey()
  List<NavigationStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  String toString() {
    return 'NavigationLeg(target: $target, targetIndex: $targetIndex, targetLabel: $targetLabel, targetLat: $targetLat, targetLon: $targetLon, distanceM: $distanceM, durationS: $durationS, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigationLegImpl &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.targetIndex, targetIndex) ||
                other.targetIndex == targetIndex) &&
            (identical(other.targetLabel, targetLabel) ||
                other.targetLabel == targetLabel) &&
            (identical(other.targetLat, targetLat) ||
                other.targetLat == targetLat) &&
            (identical(other.targetLon, targetLon) ||
                other.targetLon == targetLon) &&
            (identical(other.distanceM, distanceM) ||
                other.distanceM == distanceM) &&
            (identical(other.durationS, durationS) ||
                other.durationS == durationS) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      target,
      targetIndex,
      targetLabel,
      targetLat,
      targetLon,
      distanceM,
      durationS,
      const DeepCollectionEquality().hash(_steps));

  /// Create a copy of NavigationLeg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigationLegImplCopyWith<_$NavigationLegImpl> get copyWith =>
      __$$NavigationLegImplCopyWithImpl<_$NavigationLegImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavigationLegImplToJson(
      this,
    );
  }
}

abstract class _NavigationLeg extends NavigationLeg {
  const factory _NavigationLeg(
      {required final String target,
      final int? targetIndex,
      final String targetLabel,
      final double targetLat,
      final double targetLon,
      final double distanceM,
      final double durationS,
      final List<NavigationStep> steps}) = _$NavigationLegImpl;
  const _NavigationLeg._() : super._();

  factory _NavigationLeg.fromJson(Map<String, dynamic> json) =
      _$NavigationLegImpl.fromJson;

  /// "checkpoint" | "destination"
  @override
  String get target;
  @override
  int? get targetIndex;
  @override
  String get targetLabel;
  @override
  double get targetLat;
  @override
  double get targetLon;
  @override
  double get distanceM;
  @override
  double get durationS;
  @override
  List<NavigationStep> get steps;

  /// Create a copy of NavigationLeg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavigationLegImplCopyWith<_$NavigationLegImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavigationStep _$NavigationStepFromJson(Map<String, dynamic> json) {
  return _NavigationStep.fromJson(json);
}

/// @nodoc
mixin _$NavigationStep {
  double get distanceM => throw _privateConstructorUsedError;
  double get durationS => throw _privateConstructorUsedError;
  String? get roadName => throw _privateConstructorUsedError;
  GeoJsonLineString get geometry => throw _privateConstructorUsedError;
  NavigationManeuver get maneuver => throw _privateConstructorUsedError;

  /// Serializes this NavigationStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavigationStepCopyWith<NavigationStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavigationStepCopyWith<$Res> {
  factory $NavigationStepCopyWith(
          NavigationStep value, $Res Function(NavigationStep) then) =
      _$NavigationStepCopyWithImpl<$Res, NavigationStep>;
  @useResult
  $Res call(
      {double distanceM,
      double durationS,
      String? roadName,
      GeoJsonLineString geometry,
      NavigationManeuver maneuver});

  $GeoJsonLineStringCopyWith<$Res> get geometry;
  $NavigationManeuverCopyWith<$Res> get maneuver;
}

/// @nodoc
class _$NavigationStepCopyWithImpl<$Res, $Val extends NavigationStep>
    implements $NavigationStepCopyWith<$Res> {
  _$NavigationStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceM = null,
    Object? durationS = null,
    Object? roadName = freezed,
    Object? geometry = null,
    Object? maneuver = null,
  }) {
    return _then(_value.copyWith(
      distanceM: null == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double,
      durationS: null == durationS
          ? _value.durationS
          : durationS // ignore: cast_nullable_to_non_nullable
              as double,
      roadName: freezed == roadName
          ? _value.roadName
          : roadName // ignore: cast_nullable_to_non_nullable
              as String?,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as GeoJsonLineString,
      maneuver: null == maneuver
          ? _value.maneuver
          : maneuver // ignore: cast_nullable_to_non_nullable
              as NavigationManeuver,
    ) as $Val);
  }

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoJsonLineStringCopyWith<$Res> get geometry {
    return $GeoJsonLineStringCopyWith<$Res>(_value.geometry, (value) {
      return _then(_value.copyWith(geometry: value) as $Val);
    });
  }

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavigationManeuverCopyWith<$Res> get maneuver {
    return $NavigationManeuverCopyWith<$Res>(_value.maneuver, (value) {
      return _then(_value.copyWith(maneuver: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavigationStepImplCopyWith<$Res>
    implements $NavigationStepCopyWith<$Res> {
  factory _$$NavigationStepImplCopyWith(_$NavigationStepImpl value,
          $Res Function(_$NavigationStepImpl) then) =
      __$$NavigationStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double distanceM,
      double durationS,
      String? roadName,
      GeoJsonLineString geometry,
      NavigationManeuver maneuver});

  @override
  $GeoJsonLineStringCopyWith<$Res> get geometry;
  @override
  $NavigationManeuverCopyWith<$Res> get maneuver;
}

/// @nodoc
class __$$NavigationStepImplCopyWithImpl<$Res>
    extends _$NavigationStepCopyWithImpl<$Res, _$NavigationStepImpl>
    implements _$$NavigationStepImplCopyWith<$Res> {
  __$$NavigationStepImplCopyWithImpl(
      _$NavigationStepImpl _value, $Res Function(_$NavigationStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceM = null,
    Object? durationS = null,
    Object? roadName = freezed,
    Object? geometry = null,
    Object? maneuver = null,
  }) {
    return _then(_$NavigationStepImpl(
      distanceM: null == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double,
      durationS: null == durationS
          ? _value.durationS
          : durationS // ignore: cast_nullable_to_non_nullable
              as double,
      roadName: freezed == roadName
          ? _value.roadName
          : roadName // ignore: cast_nullable_to_non_nullable
              as String?,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as GeoJsonLineString,
      maneuver: null == maneuver
          ? _value.maneuver
          : maneuver // ignore: cast_nullable_to_non_nullable
              as NavigationManeuver,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$NavigationStepImpl implements _NavigationStep {
  const _$NavigationStepImpl(
      {this.distanceM = 0.0,
      this.durationS = 0.0,
      this.roadName,
      required this.geometry,
      required this.maneuver});

  factory _$NavigationStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavigationStepImplFromJson(json);

  @override
  @JsonKey()
  final double distanceM;
  @override
  @JsonKey()
  final double durationS;
  @override
  final String? roadName;
  @override
  final GeoJsonLineString geometry;
  @override
  final NavigationManeuver maneuver;

  @override
  String toString() {
    return 'NavigationStep(distanceM: $distanceM, durationS: $durationS, roadName: $roadName, geometry: $geometry, maneuver: $maneuver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigationStepImpl &&
            (identical(other.distanceM, distanceM) ||
                other.distanceM == distanceM) &&
            (identical(other.durationS, durationS) ||
                other.durationS == durationS) &&
            (identical(other.roadName, roadName) ||
                other.roadName == roadName) &&
            (identical(other.geometry, geometry) ||
                other.geometry == geometry) &&
            (identical(other.maneuver, maneuver) ||
                other.maneuver == maneuver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, distanceM, durationS, roadName, geometry, maneuver);

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigationStepImplCopyWith<_$NavigationStepImpl> get copyWith =>
      __$$NavigationStepImplCopyWithImpl<_$NavigationStepImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavigationStepImplToJson(
      this,
    );
  }
}

abstract class _NavigationStep implements NavigationStep {
  const factory _NavigationStep(
      {final double distanceM,
      final double durationS,
      final String? roadName,
      required final GeoJsonLineString geometry,
      required final NavigationManeuver maneuver}) = _$NavigationStepImpl;

  factory _NavigationStep.fromJson(Map<String, dynamic> json) =
      _$NavigationStepImpl.fromJson;

  @override
  double get distanceM;
  @override
  double get durationS;
  @override
  String? get roadName;
  @override
  GeoJsonLineString get geometry;
  @override
  NavigationManeuver get maneuver;

  /// Create a copy of NavigationStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavigationStepImplCopyWith<_$NavigationStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavigationManeuver _$NavigationManeuverFromJson(Map<String, dynamic> json) {
  return _NavigationManeuver.fromJson(json);
}

/// @nodoc
mixin _$NavigationManeuver {
  /// [lon, lat]
  List<double> get location => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get modifier => throw _privateConstructorUsedError;
  double get bearingBefore => throw _privateConstructorUsedError;
  double get bearingAfter => throw _privateConstructorUsedError;
  int? get exit => throw _privateConstructorUsedError;
  String get instructionEs => throw _privateConstructorUsedError;

  /// Serializes this NavigationManeuver to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavigationManeuver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavigationManeuverCopyWith<NavigationManeuver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavigationManeuverCopyWith<$Res> {
  factory $NavigationManeuverCopyWith(
          NavigationManeuver value, $Res Function(NavigationManeuver) then) =
      _$NavigationManeuverCopyWithImpl<$Res, NavigationManeuver>;
  @useResult
  $Res call(
      {List<double> location,
      String type,
      String? modifier,
      double bearingBefore,
      double bearingAfter,
      int? exit,
      String instructionEs});
}

/// @nodoc
class _$NavigationManeuverCopyWithImpl<$Res, $Val extends NavigationManeuver>
    implements $NavigationManeuverCopyWith<$Res> {
  _$NavigationManeuverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavigationManeuver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? type = null,
    Object? modifier = freezed,
    Object? bearingBefore = null,
    Object? bearingAfter = null,
    Object? exit = freezed,
    Object? instructionEs = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as List<double>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      modifier: freezed == modifier
          ? _value.modifier
          : modifier // ignore: cast_nullable_to_non_nullable
              as String?,
      bearingBefore: null == bearingBefore
          ? _value.bearingBefore
          : bearingBefore // ignore: cast_nullable_to_non_nullable
              as double,
      bearingAfter: null == bearingAfter
          ? _value.bearingAfter
          : bearingAfter // ignore: cast_nullable_to_non_nullable
              as double,
      exit: freezed == exit
          ? _value.exit
          : exit // ignore: cast_nullable_to_non_nullable
              as int?,
      instructionEs: null == instructionEs
          ? _value.instructionEs
          : instructionEs // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavigationManeuverImplCopyWith<$Res>
    implements $NavigationManeuverCopyWith<$Res> {
  factory _$$NavigationManeuverImplCopyWith(_$NavigationManeuverImpl value,
          $Res Function(_$NavigationManeuverImpl) then) =
      __$$NavigationManeuverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<double> location,
      String type,
      String? modifier,
      double bearingBefore,
      double bearingAfter,
      int? exit,
      String instructionEs});
}

/// @nodoc
class __$$NavigationManeuverImplCopyWithImpl<$Res>
    extends _$NavigationManeuverCopyWithImpl<$Res, _$NavigationManeuverImpl>
    implements _$$NavigationManeuverImplCopyWith<$Res> {
  __$$NavigationManeuverImplCopyWithImpl(_$NavigationManeuverImpl _value,
      $Res Function(_$NavigationManeuverImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavigationManeuver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? type = null,
    Object? modifier = freezed,
    Object? bearingBefore = null,
    Object? bearingAfter = null,
    Object? exit = freezed,
    Object? instructionEs = null,
  }) {
    return _then(_$NavigationManeuverImpl(
      location: null == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as List<double>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      modifier: freezed == modifier
          ? _value.modifier
          : modifier // ignore: cast_nullable_to_non_nullable
              as String?,
      bearingBefore: null == bearingBefore
          ? _value.bearingBefore
          : bearingBefore // ignore: cast_nullable_to_non_nullable
              as double,
      bearingAfter: null == bearingAfter
          ? _value.bearingAfter
          : bearingAfter // ignore: cast_nullable_to_non_nullable
              as double,
      exit: freezed == exit
          ? _value.exit
          : exit // ignore: cast_nullable_to_non_nullable
              as int?,
      instructionEs: null == instructionEs
          ? _value.instructionEs
          : instructionEs // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$NavigationManeuverImpl implements _NavigationManeuver {
  const _$NavigationManeuverImpl(
      {final List<double> location = const [],
      this.type = '',
      this.modifier,
      this.bearingBefore = 0.0,
      this.bearingAfter = 0.0,
      this.exit,
      this.instructionEs = ''})
      : _location = location;

  factory _$NavigationManeuverImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavigationManeuverImplFromJson(json);

  /// [lon, lat]
  final List<double> _location;

  /// [lon, lat]
  @override
  @JsonKey()
  List<double> get location {
    if (_location is EqualUnmodifiableListView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_location);
  }

  @override
  @JsonKey()
  final String type;
  @override
  final String? modifier;
  @override
  @JsonKey()
  final double bearingBefore;
  @override
  @JsonKey()
  final double bearingAfter;
  @override
  final int? exit;
  @override
  @JsonKey()
  final String instructionEs;

  @override
  String toString() {
    return 'NavigationManeuver(location: $location, type: $type, modifier: $modifier, bearingBefore: $bearingBefore, bearingAfter: $bearingAfter, exit: $exit, instructionEs: $instructionEs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigationManeuverImpl &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.modifier, modifier) ||
                other.modifier == modifier) &&
            (identical(other.bearingBefore, bearingBefore) ||
                other.bearingBefore == bearingBefore) &&
            (identical(other.bearingAfter, bearingAfter) ||
                other.bearingAfter == bearingAfter) &&
            (identical(other.exit, exit) || other.exit == exit) &&
            (identical(other.instructionEs, instructionEs) ||
                other.instructionEs == instructionEs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_location),
      type,
      modifier,
      bearingBefore,
      bearingAfter,
      exit,
      instructionEs);

  /// Create a copy of NavigationManeuver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigationManeuverImplCopyWith<_$NavigationManeuverImpl> get copyWith =>
      __$$NavigationManeuverImplCopyWithImpl<_$NavigationManeuverImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavigationManeuverImplToJson(
      this,
    );
  }
}

abstract class _NavigationManeuver implements NavigationManeuver {
  const factory _NavigationManeuver(
      {final List<double> location,
      final String type,
      final String? modifier,
      final double bearingBefore,
      final double bearingAfter,
      final int? exit,
      final String instructionEs}) = _$NavigationManeuverImpl;

  factory _NavigationManeuver.fromJson(Map<String, dynamic> json) =
      _$NavigationManeuverImpl.fromJson;

  /// [lon, lat]
  @override
  List<double> get location;
  @override
  String get type;
  @override
  String? get modifier;
  @override
  double get bearingBefore;
  @override
  double get bearingAfter;
  @override
  int? get exit;
  @override
  String get instructionEs;

  /// Create a copy of NavigationManeuver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavigationManeuverImplCopyWith<_$NavigationManeuverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
