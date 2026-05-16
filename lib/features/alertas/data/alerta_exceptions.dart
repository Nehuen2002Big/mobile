import '../../../core/network/api_exception.dart';

/// 422 image_required: la alerta del chofer requiere al menos una foto.
class AlertaSinFotoException extends ApiException {
  AlertaSinFotoException([String? message])
      : super(
          message ??
              'Necesitás adjuntar una foto antes de enviar la alerta.',
          statusCode: 422,
        );
}

/// 400 alert_type_not_allowed_for_driver: el chofer intentó mandar un tipo
/// de alerta que solo el backend puede generar (DESVIO automatico, etc.).
class TipoAlertaNoPermitidaException extends ApiException {
  TipoAlertaNoPermitidaException([String? message])
      : super(
          message ?? 'Tipo de alerta no permitido para el chofer.',
          statusCode: 400,
        );
}

/// 422 trip_not_stopped: el chofer quiso crear una alerta tipo descanso
/// (PARADA_COMER / PARADA_DESCANSAR) con el camion todavia en movimiento.
/// El backend mira el ultimo ping DEVICE — si `speed_kmh > 5`, rechaza.
/// Lleva la velocidad reportada y un mensaje accionable del backend.
class TripNoDetenidoException extends ApiException {
  TripNoDetenidoException({
    required this.alertType,
    required this.lastDeviceSpeedKmh,
    String? message,
  }) : super(
          message ??
              'El camión está en movimiento. Detenelo completamente antes '
                  'de iniciar la parada.',
          statusCode: 422,
        );

  /// El `alert_type` que se intento crear (PARADA_COMER / PARADA_DESCANSAR).
  final String alertType;

  /// Velocidad reportada por el ultimo ping del DEVICE (rastreador
  /// satelital del camion), no del telefono. Sirve para mostrar al
  /// chofer "estás a 45 km/h, pará el camión".
  final double lastDeviceSpeedKmh;
}
