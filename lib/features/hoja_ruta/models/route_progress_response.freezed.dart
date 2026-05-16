// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_progress_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RouteProgressResponse _$RouteProgressResponseFromJson(
    Map<String, dynamic> json) {
  return _RouteProgressResponse.fromJson(json);
}

/// @nodoc
mixin _$RouteProgressResponse {
  String get tripId => throw _privateConstructorUsedError;
  double? get routeTotalM => throw _privateConstructorUsedError;
  double get progressM => throw _privateConstructorUsedError;
  double get progressPct => throw _privateConstructorUsedError;
  List<List<double>> get completedGeometry =>
      throw _privateConstructorUsedError;
  List<List<double>> get remainingGeometry =>
      throw _privateConstructorUsedError; // Campos de turn-by-turn (null si no hay nav computado).
  int? get currentLegIndex => throw _privateConstructorUsedError;
  int? get currentStepIndex => throw _privateConstructorUsedError;
  double? get distanceToNextManeuverM => throw _privateConstructorUsedError;
  double? get distanceToCurrentTargetM => throw _privateConstructorUsedError;
  double? get distanceToDestinationM => throw _privateConstructorUsedError;
  bool? get isOnRoute => throw _privateConstructorUsedError;

  /// Serializes this RouteProgressResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteProgressResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteProgressResponseCopyWith<RouteProgressResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteProgressResponseCopyWith<$Res> {
  factory $RouteProgressResponseCopyWith(RouteProgressResponse value,
          $Res Function(RouteProgressResponse) then) =
      _$RouteProgressResponseCopyWithImpl<$Res, RouteProgressResponse>;
  @useResult
  $Res call(
      {String tripId,
      double? routeTotalM,
      double progressM,
      double progressPct,
      List<List<double>> completedGeometry,
      List<List<double>> remainingGeometry,
      int? currentLegIndex,
      int? currentStepIndex,
      double? distanceToNextManeuverM,
      double? distanceToCurrentTargetM,
      double? distanceToDestinationM,
      bool? isOnRoute});
}

/// @nodoc
class _$RouteProgressResponseCopyWithImpl<$Res,
        $Val extends RouteProgressResponse>
    implements $RouteProgressResponseCopyWith<$Res> {
  _$RouteProgressResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteProgressResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? routeTotalM = freezed,
    Object? progressM = null,
    Object? progressPct = null,
    Object? completedGeometry = null,
    Object? remainingGeometry = null,
    Object? currentLegIndex = freezed,
    Object? currentStepIndex = freezed,
    Object? distanceToNextManeuverM = freezed,
    Object? distanceToCurrentTargetM = freezed,
    Object? distanceToDestinationM = freezed,
    Object? isOnRoute = freezed,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      routeTotalM: freezed == routeTotalM
          ? _value.routeTotalM
          : routeTotalM // ignore: cast_nullable_to_non_nullable
              as double?,
      progressM: null == progressM
          ? _value.progressM
          : progressM // ignore: cast_nullable_to_non_nullable
              as double,
      progressPct: null == progressPct
          ? _value.progressPct
          : progressPct // ignore: cast_nullable_to_non_nullable
              as double,
      completedGeometry: null == completedGeometry
          ? _value.completedGeometry
          : completedGeometry // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      remainingGeometry: null == remainingGeometry
          ? _value.remainingGeometry
          : remainingGeometry // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      currentLegIndex: freezed == currentLegIndex
          ? _value.currentLegIndex
          : currentLegIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStepIndex: freezed == currentStepIndex
          ? _value.currentStepIndex
          : currentStepIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceToNextManeuverM: freezed == distanceToNextManeuverM
          ? _value.distanceToNextManeuverM
          : distanceToNextManeuverM // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToCurrentTargetM: freezed == distanceToCurrentTargetM
          ? _value.distanceToCurrentTargetM
          : distanceToCurrentTargetM // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToDestinationM: freezed == distanceToDestinationM
          ? _value.distanceToDestinationM
          : distanceToDestinationM // ignore: cast_nullable_to_non_nullable
              as double?,
      isOnRoute: freezed == isOnRoute
          ? _value.isOnRoute
          : isOnRoute // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteProgressResponseImplCopyWith<$Res>
    implements $RouteProgressResponseCopyWith<$Res> {
  factory _$$RouteProgressResponseImplCopyWith(
          _$RouteProgressResponseImpl value,
          $Res Function(_$RouteProgressResponseImpl) then) =
      __$$RouteProgressResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tripId,
      double? routeTotalM,
      double progressM,
      double progressPct,
      List<List<double>> completedGeometry,
      List<List<double>> remainingGeometry,
      int? currentLegIndex,
      int? currentStepIndex,
      double? distanceToNextManeuverM,
      double? distanceToCurrentTargetM,
      double? distanceToDestinationM,
      bool? isOnRoute});
}

/// @nodoc
class __$$RouteProgressResponseImplCopyWithImpl<$Res>
    extends _$RouteProgressResponseCopyWithImpl<$Res,
        _$RouteProgressResponseImpl>
    implements _$$RouteProgressResponseImplCopyWith<$Res> {
  __$$RouteProgressResponseImplCopyWithImpl(_$RouteProgressResponseImpl _value,
      $Res Function(_$RouteProgressResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteProgressResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? routeTotalM = freezed,
    Object? progressM = null,
    Object? progressPct = null,
    Object? completedGeometry = null,
    Object? remainingGeometry = null,
    Object? currentLegIndex = freezed,
    Object? currentStepIndex = freezed,
    Object? distanceToNextManeuverM = freezed,
    Object? distanceToCurrentTargetM = freezed,
    Object? distanceToDestinationM = freezed,
    Object? isOnRoute = freezed,
  }) {
    return _then(_$RouteProgressResponseImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      routeTotalM: freezed == routeTotalM
          ? _value.routeTotalM
          : routeTotalM // ignore: cast_nullable_to_non_nullable
              as double?,
      progressM: null == progressM
          ? _value.progressM
          : progressM // ignore: cast_nullable_to_non_nullable
              as double,
      progressPct: null == progressPct
          ? _value.progressPct
          : progressPct // ignore: cast_nullable_to_non_nullable
              as double,
      completedGeometry: null == completedGeometry
          ? _value._completedGeometry
          : completedGeometry // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      remainingGeometry: null == remainingGeometry
          ? _value._remainingGeometry
          : remainingGeometry // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      currentLegIndex: freezed == currentLegIndex
          ? _value.currentLegIndex
          : currentLegIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStepIndex: freezed == currentStepIndex
          ? _value.currentStepIndex
          : currentStepIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceToNextManeuverM: freezed == distanceToNextManeuverM
          ? _value.distanceToNextManeuverM
          : distanceToNextManeuverM // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToCurrentTargetM: freezed == distanceToCurrentTargetM
          ? _value.distanceToCurrentTargetM
          : distanceToCurrentTargetM // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToDestinationM: freezed == distanceToDestinationM
          ? _value.distanceToDestinationM
          : distanceToDestinationM // ignore: cast_nullable_to_non_nullable
              as double?,
      isOnRoute: freezed == isOnRoute
          ? _value.isOnRoute
          : isOnRoute // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RouteProgressResponseImpl implements _RouteProgressResponse {
  const _$RouteProgressResponseImpl(
      {required this.tripId,
      this.routeTotalM,
      this.progressM = 0.0,
      this.progressPct = 0.0,
      final List<List<double>> completedGeometry = const [],
      final List<List<double>> remainingGeometry = const [],
      this.currentLegIndex,
      this.currentStepIndex,
      this.distanceToNextManeuverM,
      this.distanceToCurrentTargetM,
      this.distanceToDestinationM,
      this.isOnRoute})
      : _completedGeometry = completedGeometry,
        _remainingGeometry = remainingGeometry;

  factory _$RouteProgressResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteProgressResponseImplFromJson(json);

  @override
  final String tripId;
  @override
  final double? routeTotalM;
  @override
  @JsonKey()
  final double progressM;
  @override
  @JsonKey()
  final double progressPct;
  final List<List<double>> _completedGeometry;
  @override
  @JsonKey()
  List<List<double>> get completedGeometry {
    if (_completedGeometry is EqualUnmodifiableListView)
      return _completedGeometry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedGeometry);
  }

  final List<List<double>> _remainingGeometry;
  @override
  @JsonKey()
  List<List<double>> get remainingGeometry {
    if (_remainingGeometry is EqualUnmodifiableListView)
      return _remainingGeometry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_remainingGeometry);
  }

// Campos de turn-by-turn (null si no hay nav computado).
  @override
  final int? currentLegIndex;
  @override
  final int? currentStepIndex;
  @override
  final double? distanceToNextManeuverM;
  @override
  final double? distanceToCurrentTargetM;
  @override
  final double? distanceToDestinationM;
  @override
  final bool? isOnRoute;

  @override
  String toString() {
    return 'RouteProgressResponse(tripId: $tripId, routeTotalM: $routeTotalM, progressM: $progressM, progressPct: $progressPct, completedGeometry: $completedGeometry, remainingGeometry: $remainingGeometry, currentLegIndex: $currentLegIndex, currentStepIndex: $currentStepIndex, distanceToNextManeuverM: $distanceToNextManeuverM, distanceToCurrentTargetM: $distanceToCurrentTargetM, distanceToDestinationM: $distanceToDestinationM, isOnRoute: $isOnRoute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteProgressResponseImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.routeTotalM, routeTotalM) ||
                other.routeTotalM == routeTotalM) &&
            (identical(other.progressM, progressM) ||
                other.progressM == progressM) &&
            (identical(other.progressPct, progressPct) ||
                other.progressPct == progressPct) &&
            const DeepCollectionEquality()
                .equals(other._completedGeometry, _completedGeometry) &&
            const DeepCollectionEquality()
                .equals(other._remainingGeometry, _remainingGeometry) &&
            (identical(other.currentLegIndex, currentLegIndex) ||
                other.currentLegIndex == currentLegIndex) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            (identical(
                    other.distanceToNextManeuverM, distanceToNextManeuverM) ||
                other.distanceToNextManeuverM == distanceToNextManeuverM) &&
            (identical(
                    other.distanceToCurrentTargetM, distanceToCurrentTargetM) ||
                other.distanceToCurrentTargetM == distanceToCurrentTargetM) &&
            (identical(other.distanceToDestinationM, distanceToDestinationM) ||
                other.distanceToDestinationM == distanceToDestinationM) &&
            (identical(other.isOnRoute, isOnRoute) ||
                other.isOnRoute == isOnRoute));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tripId,
      routeTotalM,
      progressM,
      progressPct,
      const DeepCollectionEquality().hash(_completedGeometry),
      const DeepCollectionEquality().hash(_remainingGeometry),
      currentLegIndex,
      currentStepIndex,
      distanceToNextManeuverM,
      distanceToCurrentTargetM,
      distanceToDestinationM,
      isOnRoute);

  /// Create a copy of RouteProgressResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteProgressResponseImplCopyWith<_$RouteProgressResponseImpl>
      get copyWith => __$$RouteProgressResponseImplCopyWithImpl<
          _$RouteProgressResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteProgressResponseImplToJson(
      this,
    );
  }
}

abstract class _RouteProgressResponse implements RouteProgressResponse {
  const factory _RouteProgressResponse(
      {required final String tripId,
      final double? routeTotalM,
      final double progressM,
      final double progressPct,
      final List<List<double>> completedGeometry,
      final List<List<double>> remainingGeometry,
      final int? currentLegIndex,
      final int? currentStepIndex,
      final double? distanceToNextManeuverM,
      final double? distanceToCurrentTargetM,
      final double? distanceToDestinationM,
      final bool? isOnRoute}) = _$RouteProgressResponseImpl;

  factory _RouteProgressResponse.fromJson(Map<String, dynamic> json) =
      _$RouteProgressResponseImpl.fromJson;

  @override
  String get tripId;
  @override
  double? get routeTotalM;
  @override
  double get progressM;
  @override
  double get progressPct;
  @override
  List<List<double>> get completedGeometry;
  @override
  List<List<double>>
      get remainingGeometry; // Campos de turn-by-turn (null si no hay nav computado).
  @override
  int? get currentLegIndex;
  @override
  int? get currentStepIndex;
  @override
  double? get distanceToNextManeuverM;
  @override
  double? get distanceToCurrentTargetM;
  @override
  double? get distanceToDestinationM;
  @override
  bool? get isOnRoute;

  /// Create a copy of RouteProgressResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteProgressResponseImplCopyWith<_$RouteProgressResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
