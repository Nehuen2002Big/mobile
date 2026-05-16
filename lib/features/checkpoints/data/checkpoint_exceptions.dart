import '../../../core/network/api_exception.dart';
import '../../shared/models/proximity_error.dart';

/// Excepcion 422 cuando el backend rechaza el marcado de checkpoint. Puede
/// ser por el GPS del telefono (phone_too_far_from_checkpoint), por falta de
/// senal del satelital (device_signal_missing), o porque el satelital marca
/// que el camion esta lejos (device_too_far_from_checkpoint).
class CheckpointReachProximityException extends ApiException {
  CheckpointReachProximityException(this.detalle)
      : super(
          detalle.message.isNotEmpty
              ? detalle.message
              : 'No se pudo validar la posición para marcar el checkpoint.',
          statusCode: 422,
        );

  final ProximityError detalle;
}

/// Excepcion cuando el checkpoint ya estaba marcado (409).
class CheckpointYaMarcadoException extends ApiException {
  CheckpointYaMarcadoException([String? message])
      : super(message ?? 'Este checkpoint ya esta marcado.', statusCode: 409);
}

/// 422 image_required: el checkpoint es delivery/pickup y no se mando ninguna
/// evidencia IMAGE con file_url.
class EvidenciaFotoRequeridaException extends ApiException {
  EvidenciaFotoRequeridaException({
    required this.actionType,
    String? message,
  }) : super(
          message ??
              'Este checkpoint de ${actionType == 'delivery' ? 'entrega' : 'retiro'} '
                  'requiere al menos una foto.',
          statusCode: 422,
        );

  final String actionType;
}

/// 422 reason_required: el checkpoint es stop y no se mando `notes`.
class EvidenciaMotivoRequeridoException extends ApiException {
  EvidenciaMotivoRequeridoException({String? message})
      : super(
          message ??
              'El checkpoint de parada requiere que indiques el motivo.',
          statusCode: 422,
        );
}

/// Excepcion cuando el checkpoint no tiene coordenadas en la hoja de ruta (409).
class CheckpointSinCoordenadasException extends ApiException {
  CheckpointSinCoordenadasException([String? message])
      : super(
          message ??
              'El checkpoint no tiene coordenadas definidas. Contactar operador.',
          statusCode: 409,
        );
}
