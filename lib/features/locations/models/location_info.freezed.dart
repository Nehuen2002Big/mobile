// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) {
  return _LocationInfo.fromJson(json);
}

/// @nodoc
mixin _$LocationInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;

  /// Serializes this LocationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationInfoCopyWith<LocationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationInfoCopyWith<$Res> {
  factory $LocationInfoCopyWith(
          LocationInfo value, $Res Function(LocationInfo) then) =
      _$LocationInfoCopyWithImpl<$Res, LocationInfo>;
  @useResult
  $Res call({String id, String name, double? lat, double? lon});
}

/// @nodoc
class _$LocationInfoCopyWithImpl<$Res, $Val extends LocationInfo>
    implements $LocationInfoCopyWith<$Res> {
  _$LocationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationInfoImplCopyWith<$Res>
    implements $LocationInfoCopyWith<$Res> {
  factory _$$LocationInfoImplCopyWith(
          _$LocationInfoImpl value, $Res Function(_$LocationInfoImpl) then) =
      __$$LocationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, double? lat, double? lon});
}

/// @nodoc
class __$$LocationInfoImplCopyWithImpl<$Res>
    extends _$LocationInfoCopyWithImpl<$Res, _$LocationInfoImpl>
    implements _$$LocationInfoImplCopyWith<$Res> {
  __$$LocationInfoImplCopyWithImpl(
      _$LocationInfoImpl _value, $Res Function(_$LocationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_$LocationInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$LocationInfoImpl implements _LocationInfo {
  const _$LocationInfoImpl(
      {required this.id, this.name = '', this.lat, this.lon});

  factory _$LocationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationInfoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  final double? lat;
  @override
  final double? lon;

  @override
  String toString() {
    return 'LocationInfo(id: $id, name: $name, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, lat, lon);

  /// Create a copy of LocationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationInfoImplCopyWith<_$LocationInfoImpl> get copyWith =>
      __$$LocationInfoImplCopyWithImpl<_$LocationInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationInfoImplToJson(
      this,
    );
  }
}

abstract class _LocationInfo implements LocationInfo {
  const factory _LocationInfo(
      {required final String id,
      final String name,
      final double? lat,
      final double? lon}) = _$LocationInfoImpl;

  factory _LocationInfo.fromJson(Map<String, dynamic> json) =
      _$LocationInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double? get lat;
  @override
  double? get lon;

  /// Create a copy of LocationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationInfoImplCopyWith<_$LocationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
