// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageListResponse _$MessageListResponseFromJson(Map<String, dynamic> json) {
  return _MessageListResponse.fromJson(json);
}

/// @nodoc
mixin _$MessageListResponse {
  List<TripMessage> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get unreadForDriver => throw _privateConstructorUsedError;
  int get unreadForMonitor => throw _privateConstructorUsedError;

  /// Serializes this MessageListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageListResponseCopyWith<MessageListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageListResponseCopyWith<$Res> {
  factory $MessageListResponseCopyWith(
          MessageListResponse value, $Res Function(MessageListResponse) then) =
      _$MessageListResponseCopyWithImpl<$Res, MessageListResponse>;
  @useResult
  $Res call(
      {List<TripMessage> items,
      int total,
      int unreadForDriver,
      int unreadForMonitor});
}

/// @nodoc
class _$MessageListResponseCopyWithImpl<$Res, $Val extends MessageListResponse>
    implements $MessageListResponseCopyWith<$Res> {
  _$MessageListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? unreadForDriver = null,
    Object? unreadForMonitor = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TripMessage>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      unreadForDriver: null == unreadForDriver
          ? _value.unreadForDriver
          : unreadForDriver // ignore: cast_nullable_to_non_nullable
              as int,
      unreadForMonitor: null == unreadForMonitor
          ? _value.unreadForMonitor
          : unreadForMonitor // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageListResponseImplCopyWith<$Res>
    implements $MessageListResponseCopyWith<$Res> {
  factory _$$MessageListResponseImplCopyWith(_$MessageListResponseImpl value,
          $Res Function(_$MessageListResponseImpl) then) =
      __$$MessageListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TripMessage> items,
      int total,
      int unreadForDriver,
      int unreadForMonitor});
}

/// @nodoc
class __$$MessageListResponseImplCopyWithImpl<$Res>
    extends _$MessageListResponseCopyWithImpl<$Res, _$MessageListResponseImpl>
    implements _$$MessageListResponseImplCopyWith<$Res> {
  __$$MessageListResponseImplCopyWithImpl(_$MessageListResponseImpl _value,
      $Res Function(_$MessageListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? unreadForDriver = null,
    Object? unreadForMonitor = null,
  }) {
    return _then(_$MessageListResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TripMessage>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      unreadForDriver: null == unreadForDriver
          ? _value.unreadForDriver
          : unreadForDriver // ignore: cast_nullable_to_non_nullable
              as int,
      unreadForMonitor: null == unreadForMonitor
          ? _value.unreadForMonitor
          : unreadForMonitor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MessageListResponseImpl implements _MessageListResponse {
  const _$MessageListResponseImpl(
      {final List<TripMessage> items = const [],
      this.total = 0,
      this.unreadForDriver = 0,
      this.unreadForMonitor = 0})
      : _items = items;

  factory _$MessageListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageListResponseImplFromJson(json);

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
  final int total;
  @override
  @JsonKey()
  final int unreadForDriver;
  @override
  @JsonKey()
  final int unreadForMonitor;

  @override
  String toString() {
    return 'MessageListResponse(items: $items, total: $total, unreadForDriver: $unreadForDriver, unreadForMonitor: $unreadForMonitor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageListResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.unreadForDriver, unreadForDriver) ||
                other.unreadForDriver == unreadForDriver) &&
            (identical(other.unreadForMonitor, unreadForMonitor) ||
                other.unreadForMonitor == unreadForMonitor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      total,
      unreadForDriver,
      unreadForMonitor);

  /// Create a copy of MessageListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageListResponseImplCopyWith<_$MessageListResponseImpl> get copyWith =>
      __$$MessageListResponseImplCopyWithImpl<_$MessageListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageListResponseImplToJson(
      this,
    );
  }
}

abstract class _MessageListResponse implements MessageListResponse {
  const factory _MessageListResponse(
      {final List<TripMessage> items,
      final int total,
      final int unreadForDriver,
      final int unreadForMonitor}) = _$MessageListResponseImpl;

  factory _MessageListResponse.fromJson(Map<String, dynamic> json) =
      _$MessageListResponseImpl.fromJson;

  @override
  List<TripMessage> get items;
  @override
  int get total;
  @override
  int get unreadForDriver;
  @override
  int get unreadForMonitor;

  /// Create a copy of MessageListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageListResponseImplCopyWith<_$MessageListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
