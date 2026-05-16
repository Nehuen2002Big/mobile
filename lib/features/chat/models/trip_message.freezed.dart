// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripMessage _$TripMessageFromJson(Map<String, dynamic> json) {
  return _TripMessage.fromJson(json);
}

/// @nodoc
mixin _$TripMessage {
  int get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get senderRole => throw _privateConstructorUsedError;
  String? get senderUserId => throw _privateConstructorUsedError;
  String? get senderName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  int? get alertId => throw _privateConstructorUsedError;
  MessageAlertRef? get alert => throw _privateConstructorUsedError;

  /// Serializes this TripMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripMessageCopyWith<TripMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripMessageCopyWith<$Res> {
  factory $TripMessageCopyWith(
          TripMessage value, $Res Function(TripMessage) then) =
      _$TripMessageCopyWithImpl<$Res, TripMessage>;
  @useResult
  $Res call(
      {int id,
      String tripId,
      String senderRole,
      String? senderUserId,
      String? senderName,
      String content,
      DateTime createdAt,
      DateTime? readAt,
      int? alertId,
      MessageAlertRef? alert});

  $MessageAlertRefCopyWith<$Res>? get alert;
}

/// @nodoc
class _$TripMessageCopyWithImpl<$Res, $Val extends TripMessage>
    implements $TripMessageCopyWith<$Res> {
  _$TripMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? senderRole = null,
    Object? senderUserId = freezed,
    Object? senderName = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? alertId = freezed,
    Object? alert = freezed,
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
      senderRole: null == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String,
      senderUserId: freezed == senderUserId
          ? _value.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      alertId: freezed == alertId
          ? _value.alertId
          : alertId // ignore: cast_nullable_to_non_nullable
              as int?,
      alert: freezed == alert
          ? _value.alert
          : alert // ignore: cast_nullable_to_non_nullable
              as MessageAlertRef?,
    ) as $Val);
  }

  /// Create a copy of TripMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageAlertRefCopyWith<$Res>? get alert {
    if (_value.alert == null) {
      return null;
    }

    return $MessageAlertRefCopyWith<$Res>(_value.alert!, (value) {
      return _then(_value.copyWith(alert: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripMessageImplCopyWith<$Res>
    implements $TripMessageCopyWith<$Res> {
  factory _$$TripMessageImplCopyWith(
          _$TripMessageImpl value, $Res Function(_$TripMessageImpl) then) =
      __$$TripMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String tripId,
      String senderRole,
      String? senderUserId,
      String? senderName,
      String content,
      DateTime createdAt,
      DateTime? readAt,
      int? alertId,
      MessageAlertRef? alert});

  @override
  $MessageAlertRefCopyWith<$Res>? get alert;
}

/// @nodoc
class __$$TripMessageImplCopyWithImpl<$Res>
    extends _$TripMessageCopyWithImpl<$Res, _$TripMessageImpl>
    implements _$$TripMessageImplCopyWith<$Res> {
  __$$TripMessageImplCopyWithImpl(
      _$TripMessageImpl _value, $Res Function(_$TripMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? senderRole = null,
    Object? senderUserId = freezed,
    Object? senderName = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? alertId = freezed,
    Object? alert = freezed,
  }) {
    return _then(_$TripMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      senderRole: null == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String,
      senderUserId: freezed == senderUserId
          ? _value.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      alertId: freezed == alertId
          ? _value.alertId
          : alertId // ignore: cast_nullable_to_non_nullable
              as int?,
      alert: freezed == alert
          ? _value.alert
          : alert // ignore: cast_nullable_to_non_nullable
              as MessageAlertRef?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TripMessageImpl extends _TripMessage {
  const _$TripMessageImpl(
      {required this.id,
      required this.tripId,
      required this.senderRole,
      this.senderUserId,
      this.senderName,
      required this.content,
      required this.createdAt,
      this.readAt,
      this.alertId,
      this.alert})
      : super._();

  factory _$TripMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripMessageImplFromJson(json);

  @override
  final int id;
  @override
  final String tripId;
  @override
  final String senderRole;
  @override
  final String? senderUserId;
  @override
  final String? senderName;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime? readAt;
  @override
  final int? alertId;
  @override
  final MessageAlertRef? alert;

  @override
  String toString() {
    return 'TripMessage(id: $id, tripId: $tripId, senderRole: $senderRole, senderUserId: $senderUserId, senderName: $senderName, content: $content, createdAt: $createdAt, readAt: $readAt, alertId: $alertId, alert: $alert)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.senderRole, senderRole) ||
                other.senderRole == senderRole) &&
            (identical(other.senderUserId, senderUserId) ||
                other.senderUserId == senderUserId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.alertId, alertId) || other.alertId == alertId) &&
            (identical(other.alert, alert) || other.alert == alert));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tripId, senderRole,
      senderUserId, senderName, content, createdAt, readAt, alertId, alert);

  /// Create a copy of TripMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripMessageImplCopyWith<_$TripMessageImpl> get copyWith =>
      __$$TripMessageImplCopyWithImpl<_$TripMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripMessageImplToJson(
      this,
    );
  }
}

abstract class _TripMessage extends TripMessage {
  const factory _TripMessage(
      {required final int id,
      required final String tripId,
      required final String senderRole,
      final String? senderUserId,
      final String? senderName,
      required final String content,
      required final DateTime createdAt,
      final DateTime? readAt,
      final int? alertId,
      final MessageAlertRef? alert}) = _$TripMessageImpl;
  const _TripMessage._() : super._();

  factory _TripMessage.fromJson(Map<String, dynamic> json) =
      _$TripMessageImpl.fromJson;

  @override
  int get id;
  @override
  String get tripId;
  @override
  String get senderRole;
  @override
  String? get senderUserId;
  @override
  String? get senderName;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  DateTime? get readAt;
  @override
  int? get alertId;
  @override
  MessageAlertRef? get alert;

  /// Create a copy of TripMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripMessageImplCopyWith<_$TripMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
