// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoint_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckpointInfo _$CheckpointInfoFromJson(Map<String, dynamic> json) {
  return _CheckpointInfo.fromJson(json);
}

/// @nodoc
mixin _$CheckpointInfo {
  int get index => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  String? get actionType => throw _privateConstructorUsedError;
  String? get cargoDescription => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get reached => throw _privateConstructorUsedError;
  DateTime? get reachedAt => throw _privateConstructorUsedError;
  double? get reachedLat => throw _privateConstructorUsedError;
  double? get reachedLon => throw _privateConstructorUsedError;
  double? get distanceToCheckpointM => throw _privateConstructorUsedError;
  String? get markedByUserId => throw _privateConstructorUsedError;
  String? get reachNotes => throw _privateConstructorUsedError;
  List<CheckpointEvidence> get reachEvidences =>
      throw _privateConstructorUsedError;

  /// Serializes this CheckpointInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckpointInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointInfoCopyWith<CheckpointInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointInfoCopyWith<$Res> {
  factory $CheckpointInfoCopyWith(
          CheckpointInfo value, $Res Function(CheckpointInfo) then) =
      _$CheckpointInfoCopyWithImpl<$Res, CheckpointInfo>;
  @useResult
  $Res call(
      {int index,
      String? name,
      double? lat,
      double? lon,
      String? actionType,
      String? cargoDescription,
      String? notes,
      bool reached,
      DateTime? reachedAt,
      double? reachedLat,
      double? reachedLon,
      double? distanceToCheckpointM,
      String? markedByUserId,
      String? reachNotes,
      List<CheckpointEvidence> reachEvidences});
}

/// @nodoc
class _$CheckpointInfoCopyWithImpl<$Res, $Val extends CheckpointInfo>
    implements $CheckpointInfoCopyWith<$Res> {
  _$CheckpointInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckpointInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? actionType = freezed,
    Object? cargoDescription = freezed,
    Object? notes = freezed,
    Object? reached = null,
    Object? reachedAt = freezed,
    Object? reachedLat = freezed,
    Object? reachedLon = freezed,
    Object? distanceToCheckpointM = freezed,
    Object? markedByUserId = freezed,
    Object? reachNotes = freezed,
    Object? reachEvidences = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoDescription: freezed == cargoDescription
          ? _value.cargoDescription
          : cargoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reached: null == reached
          ? _value.reached
          : reached // ignore: cast_nullable_to_non_nullable
              as bool,
      reachedAt: freezed == reachedAt
          ? _value.reachedAt
          : reachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reachedLat: freezed == reachedLat
          ? _value.reachedLat
          : reachedLat // ignore: cast_nullable_to_non_nullable
              as double?,
      reachedLon: freezed == reachedLon
          ? _value.reachedLon
          : reachedLon // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToCheckpointM: freezed == distanceToCheckpointM
          ? _value.distanceToCheckpointM
          : distanceToCheckpointM // ignore: cast_nullable_to_non_nullable
              as double?,
      markedByUserId: freezed == markedByUserId
          ? _value.markedByUserId
          : markedByUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      reachNotes: freezed == reachNotes
          ? _value.reachNotes
          : reachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      reachEvidences: null == reachEvidences
          ? _value.reachEvidences
          : reachEvidences // ignore: cast_nullable_to_non_nullable
              as List<CheckpointEvidence>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointInfoImplCopyWith<$Res>
    implements $CheckpointInfoCopyWith<$Res> {
  factory _$$CheckpointInfoImplCopyWith(_$CheckpointInfoImpl value,
          $Res Function(_$CheckpointInfoImpl) then) =
      __$$CheckpointInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index,
      String? name,
      double? lat,
      double? lon,
      String? actionType,
      String? cargoDescription,
      String? notes,
      bool reached,
      DateTime? reachedAt,
      double? reachedLat,
      double? reachedLon,
      double? distanceToCheckpointM,
      String? markedByUserId,
      String? reachNotes,
      List<CheckpointEvidence> reachEvidences});
}

/// @nodoc
class __$$CheckpointInfoImplCopyWithImpl<$Res>
    extends _$CheckpointInfoCopyWithImpl<$Res, _$CheckpointInfoImpl>
    implements _$$CheckpointInfoImplCopyWith<$Res> {
  __$$CheckpointInfoImplCopyWithImpl(
      _$CheckpointInfoImpl _value, $Res Function(_$CheckpointInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckpointInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? actionType = freezed,
    Object? cargoDescription = freezed,
    Object? notes = freezed,
    Object? reached = null,
    Object? reachedAt = freezed,
    Object? reachedLat = freezed,
    Object? reachedLon = freezed,
    Object? distanceToCheckpointM = freezed,
    Object? markedByUserId = freezed,
    Object? reachNotes = freezed,
    Object? reachEvidences = null,
  }) {
    return _then(_$CheckpointInfoImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoDescription: freezed == cargoDescription
          ? _value.cargoDescription
          : cargoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reached: null == reached
          ? _value.reached
          : reached // ignore: cast_nullable_to_non_nullable
              as bool,
      reachedAt: freezed == reachedAt
          ? _value.reachedAt
          : reachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reachedLat: freezed == reachedLat
          ? _value.reachedLat
          : reachedLat // ignore: cast_nullable_to_non_nullable
              as double?,
      reachedLon: freezed == reachedLon
          ? _value.reachedLon
          : reachedLon // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToCheckpointM: freezed == distanceToCheckpointM
          ? _value.distanceToCheckpointM
          : distanceToCheckpointM // ignore: cast_nullable_to_non_nullable
              as double?,
      markedByUserId: freezed == markedByUserId
          ? _value.markedByUserId
          : markedByUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      reachNotes: freezed == reachNotes
          ? _value.reachNotes
          : reachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      reachEvidences: null == reachEvidences
          ? _value._reachEvidences
          : reachEvidences // ignore: cast_nullable_to_non_nullable
              as List<CheckpointEvidence>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CheckpointInfoImpl extends _CheckpointInfo {
  const _$CheckpointInfoImpl(
      {required this.index,
      this.name,
      this.lat,
      this.lon,
      this.actionType,
      this.cargoDescription,
      this.notes,
      this.reached = false,
      this.reachedAt,
      this.reachedLat,
      this.reachedLon,
      this.distanceToCheckpointM,
      this.markedByUserId,
      this.reachNotes,
      final List<CheckpointEvidence> reachEvidences = const []})
      : _reachEvidences = reachEvidences,
        super._();

  factory _$CheckpointInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckpointInfoImplFromJson(json);

  @override
  final int index;
  @override
  final String? name;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  final String? actionType;
  @override
  final String? cargoDescription;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool reached;
  @override
  final DateTime? reachedAt;
  @override
  final double? reachedLat;
  @override
  final double? reachedLon;
  @override
  final double? distanceToCheckpointM;
  @override
  final String? markedByUserId;
  @override
  final String? reachNotes;
  final List<CheckpointEvidence> _reachEvidences;
  @override
  @JsonKey()
  List<CheckpointEvidence> get reachEvidences {
    if (_reachEvidences is EqualUnmodifiableListView) return _reachEvidences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reachEvidences);
  }

  @override
  String toString() {
    return 'CheckpointInfo(index: $index, name: $name, lat: $lat, lon: $lon, actionType: $actionType, cargoDescription: $cargoDescription, notes: $notes, reached: $reached, reachedAt: $reachedAt, reachedLat: $reachedLat, reachedLon: $reachedLon, distanceToCheckpointM: $distanceToCheckpointM, markedByUserId: $markedByUserId, reachNotes: $reachNotes, reachEvidences: $reachEvidences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointInfoImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.cargoDescription, cargoDescription) ||
                other.cargoDescription == cargoDescription) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.reached, reached) || other.reached == reached) &&
            (identical(other.reachedAt, reachedAt) ||
                other.reachedAt == reachedAt) &&
            (identical(other.reachedLat, reachedLat) ||
                other.reachedLat == reachedLat) &&
            (identical(other.reachedLon, reachedLon) ||
                other.reachedLon == reachedLon) &&
            (identical(other.distanceToCheckpointM, distanceToCheckpointM) ||
                other.distanceToCheckpointM == distanceToCheckpointM) &&
            (identical(other.markedByUserId, markedByUserId) ||
                other.markedByUserId == markedByUserId) &&
            (identical(other.reachNotes, reachNotes) ||
                other.reachNotes == reachNotes) &&
            const DeepCollectionEquality()
                .equals(other._reachEvidences, _reachEvidences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      index,
      name,
      lat,
      lon,
      actionType,
      cargoDescription,
      notes,
      reached,
      reachedAt,
      reachedLat,
      reachedLon,
      distanceToCheckpointM,
      markedByUserId,
      reachNotes,
      const DeepCollectionEquality().hash(_reachEvidences));

  /// Create a copy of CheckpointInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointInfoImplCopyWith<_$CheckpointInfoImpl> get copyWith =>
      __$$CheckpointInfoImplCopyWithImpl<_$CheckpointInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckpointInfoImplToJson(
      this,
    );
  }
}

abstract class _CheckpointInfo extends CheckpointInfo {
  const factory _CheckpointInfo(
      {required final int index,
      final String? name,
      final double? lat,
      final double? lon,
      final String? actionType,
      final String? cargoDescription,
      final String? notes,
      final bool reached,
      final DateTime? reachedAt,
      final double? reachedLat,
      final double? reachedLon,
      final double? distanceToCheckpointM,
      final String? markedByUserId,
      final String? reachNotes,
      final List<CheckpointEvidence> reachEvidences}) = _$CheckpointInfoImpl;
  const _CheckpointInfo._() : super._();

  factory _CheckpointInfo.fromJson(Map<String, dynamic> json) =
      _$CheckpointInfoImpl.fromJson;

  @override
  int get index;
  @override
  String? get name;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  String? get actionType;
  @override
  String? get cargoDescription;
  @override
  String? get notes;
  @override
  bool get reached;
  @override
  DateTime? get reachedAt;
  @override
  double? get reachedLat;
  @override
  double? get reachedLon;
  @override
  double? get distanceToCheckpointM;
  @override
  String? get markedByUserId;
  @override
  String? get reachNotes;
  @override
  List<CheckpointEvidence> get reachEvidences;

  /// Create a copy of CheckpointInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointInfoImplCopyWith<_$CheckpointInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
