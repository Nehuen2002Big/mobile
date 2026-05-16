import '../../../core/network/api_exception.dart';

/// 413 al subir evidencia: archivo mas grande que el limite del backend.
class ArchivoDemasiadoGrandeException extends ApiException {
  ArchivoDemasiadoGrandeException({
    required this.sizeBytes,
    required this.maxBytes,
    String? message,
  }) : super(
          message ??
              'La foto pesa ${(sizeBytes / 1024 / 1024).toStringAsFixed(1)} MB '
                  'y el máximo es ${(maxBytes / 1024 / 1024).toStringAsFixed(0)} MB. '
                  'Probá con una imagen más chica.',
          statusCode: 413,
        );

  final int sizeBytes;
  final int maxBytes;
}

/// 415 al subir evidencia: tipo MIME no permitido.
class TipoArchivoNoPermitidoException extends ApiException {
  TipoArchivoNoPermitidoException({
    required this.mime,
    String? message,
  }) : super(
          message ??
              'El formato "$mime" no está permitido. Usá una foto JPEG, PNG '
                  'o WebP.',
          statusCode: 415,
        );

  final String mime;
}
