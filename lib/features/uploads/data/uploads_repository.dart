import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/network/dio_client.dart';
import '../models/upload_evidence_response.dart';
import 'upload_exceptions.dart';

class UploadsRepository {
  UploadsRepository(this._client);

  final DioClient _client;

  /// Sube una imagen como evidencia para un viaje. Devuelve la metadata del
  /// archivo con el URL relativo que despues se adjunta al checkpoint o
  /// alerta. Lanza ArchivoDemasiadoGrandeException (413) o
  /// TipoArchivoNoPermitidoException (415) si el backend rechaza.
  Future<UploadEvidenceResponse> subirEvidencia({
    required String tripId,
    required File file,
  }) async {
    try {
      final ext = _extension(file.path).toLowerCase();
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: 'evidence$ext',
          contentType: _mediaType(ext),
        ),
      });
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/uploads/evidence/$tripId',
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );
      return UploadEvidenceResponse.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      if (resp?.statusCode == 413 && data is Map) {
        final detail = data['detail'];
        int size = 0;
        int max = 0;
        String? msg;
        if (detail is Map) {
          size = (detail['size_bytes'] as num?)?.toInt() ?? 0;
          max = (detail['max_bytes'] as num?)?.toInt() ?? 0;
          msg = detail['message'] as String?;
        }
        throw ArchivoDemasiadoGrandeException(
          sizeBytes: size,
          maxBytes: max,
          message: msg,
        );
      }
      if (resp?.statusCode == 415 && data is Map) {
        final detail = data['detail'];
        String mime = '';
        String? msg;
        if (detail is Map) {
          mime = (detail['mime'] as String?) ?? '';
          msg = detail['message'] as String?;
        }
        throw TipoArchivoNoPermitidoException(mime: mime, message: msg);
      }
      throw mapDioError(e, fallback: 'No se pudo subir la foto');
    }
  }

  String _extension(String path) {
    final i = path.lastIndexOf('.');
    if (i < 0) return '.jpg';
    return path.substring(i);
  }

  MediaType _mediaType(String ext) {
    switch (ext) {
      case '.png':
        return MediaType('image', 'png');
      case '.webp':
        return MediaType('image', 'webp');
      case '.jpg':
      case '.jpeg':
      default:
        return MediaType('image', 'jpeg');
    }
  }
}
