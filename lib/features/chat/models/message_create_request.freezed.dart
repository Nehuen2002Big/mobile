// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageCreateRequest _$MessageCreateRequestFromJson(Map<String, dynamic> json) {
  return _MessageCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$MessageCreateRequest {
  String get senderRole => throw _privateConstructorUsedError;
  String? get senderName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this MessageCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCreateRequestCopyWith<MessageCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCreateRequestCopyWith<$Res> {
  factory $MessageCreateRequestCopyWith(MessageCreateRequest value,
          $Res Function(MessageCreateRequest) then) =
      _$MessageCreateRequestCopyWithImpl<$Res, MessageCreateRequest>;
  @useResult
  $Res call({String senderRole, String? senderName, String content});
}

/// @nodoc
class _$MessageCreateRequestCopyWithImpl<$Res,
        $Val extends MessageCreateRequest>
    implements $MessageCreateRequestCopyWith<$Res> {
  _$MessageCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderRole = null,
    Object? senderName = freezed,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      senderRole: null == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageCreateRequestImplCopyWith<$Res>
    implements $MessageCreateRequestCopyWith<$Res> {
  factory _$$MessageCreateRequestImplCopyWith(_$MessageCreateRequestImpl value,
          $Res Function(_$MessageCreateRequestImpl) then) =
      __$$MessageCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String senderRole, String? senderName, String content});
}

/// @nodoc
class __$$MessageCreateRequestImplCopyWithImpl<$Res>
    extends _$MessageCreateRequestCopyWithImpl<$Res, _$MessageCreateRequestImpl>
    implements _$$MessageCreateRequestImplCopyWith<$Res> {
  __$$MessageCreateRequestImplCopyWithImpl(_$MessageCreateRequestImpl _value,
      $Res Function(_$MessageCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderRole = null,
    Object? senderName = freezed,
    Object? content = null,
  }) {
    return _then(_$MessageCreateRequestImpl(
      senderRole: null == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MessageCreateRequestImpl implements _MessageCreateRequest {
  const _$MessageCreateRequestImpl(
      {required this.senderRole, this.senderName, required this.content});

  factory _$MessageCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageCreateRequestImplFromJson(json);

  @override
  final String senderRole;
  @override
  final String? senderName;
  @override
  final String content;

  @override
  String toString() {
    return 'MessageCreateRequest(senderRole: $senderRole, senderName: $senderName, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageCreateRequestImpl &&
            (identical(other.senderRole, senderRole) ||
                other.senderRole == senderRole) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, senderRole, senderName, content);

  /// Create a copy of MessageCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageCreateRequestImplCopyWith<_$MessageCreateRequestImpl>
      get copyWith =>
          __$$MessageCreateRequestImplCopyWithImpl<_$MessageCreateRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _MessageCreateRequest implements MessageCreateRequest {
  const factory _MessageCreateRequest(
      {required final String senderRole,
      final String? senderName,
      required final String content}) = _$MessageCreateRequestImpl;

  factory _MessageCreateRequest.fromJson(Map<String, dynamic> json) =
      _$MessageCreateRequestImpl.fromJson;

  @override
  String get senderRole;
  @override
  String? get senderName;
  @override
  String get content;

  /// Create a copy of MessageCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageCreateRequestImplCopyWith<_$MessageCreateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
