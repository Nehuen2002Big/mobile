// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoint_evidence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckpointEvidence _$CheckpointEvidenceFromJson(Map<String, dynamic> json) {
  return _CheckpointEvidence.fromJson(json);
}

/// @nodoc
mixin _$CheckpointEvidence {
  String get evidenceType => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CheckpointEvidence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckpointEvidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckpointEvidenceCopyWith<CheckpointEvidence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointEvidenceCopyWith<$Res> {
  factory $CheckpointEvidenceCopyWith(
          CheckpointEvidence value, $Res Function(CheckpointEvidence) then) =
      _$CheckpointEvidenceCopyWithImpl<$Res, CheckpointEvidence>;
  @useResult
  $Res call({String evidenceType, String? fileUrl, String? description});
}

/// @nodoc
class _$CheckpointEvidenceCopyWithImpl<$Res, $Val extends CheckpointEvidence>
    implements $CheckpointEvidenceCopyWith<$Res> {
  _$CheckpointEvidenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckpointEvidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? evidenceType = null,
    Object? fileUrl = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      evidenceType: null == evidenceType
          ? _value.evidenceType
          : evidenceType // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointEvidenceImplCopyWith<$Res>
    implements $CheckpointEvidenceCopyWith<$Res> {
  factory _$$CheckpointEvidenceImplCopyWith(_$CheckpointEvidenceImpl value,
          $Res Function(_$CheckpointEvidenceImpl) then) =
      __$$CheckpointEvidenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String evidenceType, String? fileUrl, String? description});
}

/// @nodoc
class __$$CheckpointEvidenceImplCopyWithImpl<$Res>
    extends _$CheckpointEvidenceCopyWithImpl<$Res, _$CheckpointEvidenceImpl>
    implements _$$CheckpointEvidenceImplCopyWith<$Res> {
  __$$CheckpointEvidenceImplCopyWithImpl(_$CheckpointEvidenceImpl _value,
      $Res Function(_$CheckpointEvidenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckpointEvidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? evidenceType = null,
    Object? fileUrl = freezed,
    Object? description = freezed,
  }) {
    return _then(_$CheckpointEvidenceImpl(
      evidenceType: null == evidenceType
          ? _value.evidenceType
          : evidenceType // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CheckpointEvidenceImpl implements _CheckpointEvidence {
  const _$CheckpointEvidenceImpl(
      {required this.evidenceType, this.fileUrl, this.description});

  factory _$CheckpointEvidenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckpointEvidenceImplFromJson(json);

  @override
  final String evidenceType;
  @override
  final String? fileUrl;
  @override
  final String? description;

  @override
  String toString() {
    return 'CheckpointEvidence(evidenceType: $evidenceType, fileUrl: $fileUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointEvidenceImpl &&
            (identical(other.evidenceType, evidenceType) ||
                other.evidenceType == evidenceType) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, evidenceType, fileUrl, description);

  /// Create a copy of CheckpointEvidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointEvidenceImplCopyWith<_$CheckpointEvidenceImpl> get copyWith =>
      __$$CheckpointEvidenceImplCopyWithImpl<_$CheckpointEvidenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckpointEvidenceImplToJson(
      this,
    );
  }
}

abstract class _CheckpointEvidence implements CheckpointEvidence {
  const factory _CheckpointEvidence(
      {required final String evidenceType,
      final String? fileUrl,
      final String? description}) = _$CheckpointEvidenceImpl;

  factory _CheckpointEvidence.fromJson(Map<String, dynamic> json) =
      _$CheckpointEvidenceImpl.fromJson;

  @override
  String get evidenceType;
  @override
  String? get fileUrl;
  @override
  String? get description;

  /// Create a copy of CheckpointEvidence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckpointEvidenceImplCopyWith<_$CheckpointEvidenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
