// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_evidence_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UploadEvidenceResponse _$UploadEvidenceResponseFromJson(
    Map<String, dynamic> json) {
  return _UploadEvidenceResponse.fromJson(json);
}

/// @nodoc
mixin _$UploadEvidenceResponse {
  String get tripId => throw _privateConstructorUsedError;
  String get filename => throw _privateConstructorUsedError;
  int get sizeBytes => throw _privateConstructorUsedError;
  String get contentType => throw _privateConstructorUsedError;

  /// URL RELATIVO al host (ej. "/api/v1/uploads/evidence/TRIP/xxx.jpg").
  /// Para construir URL absoluta hay que anteponer `config.trackingBaseUrl`.
  String get url => throw _privateConstructorUsedError;

  /// Serializes this UploadEvidenceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadEvidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadEvidenceResponseCopyWith<UploadEvidenceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadEvidenceResponseCopyWith<$Res> {
  factory $UploadEvidenceResponseCopyWith(UploadEvidenceResponse value,
          $Res Function(UploadEvidenceResponse) then) =
      _$UploadEvidenceResponseCopyWithImpl<$Res, UploadEvidenceResponse>;
  @useResult
  $Res call(
      {String tripId,
      String filename,
      int sizeBytes,
      String contentType,
      String url});
}

/// @nodoc
class _$UploadEvidenceResponseCopyWithImpl<$Res,
        $Val extends UploadEvidenceResponse>
    implements $UploadEvidenceResponseCopyWith<$Res> {
  _$UploadEvidenceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadEvidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? filename = null,
    Object? sizeBytes = null,
    Object? contentType = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadEvidenceResponseImplCopyWith<$Res>
    implements $UploadEvidenceResponseCopyWith<$Res> {
  factory _$$UploadEvidenceResponseImplCopyWith(
          _$UploadEvidenceResponseImpl value,
          $Res Function(_$UploadEvidenceResponseImpl) then) =
      __$$UploadEvidenceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tripId,
      String filename,
      int sizeBytes,
      String contentType,
      String url});
}

/// @nodoc
class __$$UploadEvidenceResponseImplCopyWithImpl<$Res>
    extends _$UploadEvidenceResponseCopyWithImpl<$Res,
        _$UploadEvidenceResponseImpl>
    implements _$$UploadEvidenceResponseImplCopyWith<$Res> {
  __$$UploadEvidenceResponseImplCopyWithImpl(
      _$UploadEvidenceResponseImpl _value,
      $Res Function(_$UploadEvidenceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadEvidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? filename = null,
    Object? sizeBytes = null,
    Object? contentType = null,
    Object? url = null,
  }) {
    return _then(_$UploadEvidenceResponseImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$UploadEvidenceResponseImpl implements _UploadEvidenceResponse {
  const _$UploadEvidenceResponseImpl(
      {required this.tripId,
      required this.filename,
      this.sizeBytes = 0,
      this.contentType = '',
      required this.url});

  factory _$UploadEvidenceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadEvidenceResponseImplFromJson(json);

  @override
  final String tripId;
  @override
  final String filename;
  @override
  @JsonKey()
  final int sizeBytes;
  @override
  @JsonKey()
  final String contentType;

  /// URL RELATIVO al host (ej. "/api/v1/uploads/evidence/TRIP/xxx.jpg").
  /// Para construir URL absoluta hay que anteponer `config.trackingBaseUrl`.
  @override
  final String url;

  @override
  String toString() {
    return 'UploadEvidenceResponse(tripId: $tripId, filename: $filename, sizeBytes: $sizeBytes, contentType: $contentType, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadEvidenceResponseImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tripId, filename, sizeBytes, contentType, url);

  /// Create a copy of UploadEvidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadEvidenceResponseImplCopyWith<_$UploadEvidenceResponseImpl>
      get copyWith => __$$UploadEvidenceResponseImplCopyWithImpl<
          _$UploadEvidenceResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadEvidenceResponseImplToJson(
      this,
    );
  }
}

abstract class _UploadEvidenceResponse implements UploadEvidenceResponse {
  const factory _UploadEvidenceResponse(
      {required final String tripId,
      required final String filename,
      final int sizeBytes,
      final String contentType,
      required final String url}) = _$UploadEvidenceResponseImpl;

  factory _UploadEvidenceResponse.fromJson(Map<String, dynamic> json) =
      _$UploadEvidenceResponseImpl.fromJson;

  @override
  String get tripId;
  @override
  String get filename;
  @override
  int get sizeBytes;
  @override
  String get contentType;

  /// URL RELATIVO al host (ej. "/api/v1/uploads/evidence/TRIP/xxx.jpg").
  /// Para construir URL absoluta hay que anteponer `config.trackingBaseUrl`.
  @override
  String get url;

  /// Create a copy of UploadEvidenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadEvidenceResponseImplCopyWith<_$UploadEvidenceResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
