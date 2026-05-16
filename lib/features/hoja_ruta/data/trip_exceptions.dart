import '../../../core/network/api_exception.dart';
import '../../shared/models/proximity_error.dart';

/// 422 al iniciar el viaje por fallar validacion de proximidad (telefono o
/// satelital). Lleva el detalle estructurado para que la UI pueda mostrar un
/// mensaje especifico segun el error code.
class TripStartProximityException extends ApiException {
  TripStartProximityException(this.detalle)
      : super(
          detalle.message.isNotEmpty
              ? detalle.message
              : 'No se pudo validar la posición para iniciar.',
          statusCode: 422,
        );

  final ProximityError detalle;
}

/// 422 al finalizar el viaje cuando el telefono o el satelital no estan en el
/// destino.
class TripFinishProximityException extends ApiException {
  TripFinishProximityException(this.detalle)
      : super(
          detalle.message.isNotEmpty
              ? detalle.message
              : 'No se pudo validar la posición para finalizar.',
          statusCode: 422,
        );

  final ProximityError detalle;
}

/// 409 cuando el trip esta en un estado que no permite la transicion pedida
/// (por ej. intentar start cuando ya esta ACTIVE o FINISHED).
class TripEstadoInvalidoException extends ApiException {
  TripEstadoInvalidoException([String? message])
      : super(
          message ?? 'El viaje no se puede iniciar en su estado actual.',
          statusCode: 409,
        );
}

/// 400 al hacer finish/cancel de un viaje que ya estaba cerrado (otro
/// chofer cerro sesion + cerro el viaje, o el operador lo cancelo desde
/// la web). NO es un error real para el chofer — solo indica que el
/// estado local quedo desactualizado. La UI debe re-sincronizar
/// (refresh de la lista) y volver al listado silenciosamente.
class TripYaCerradoException extends ApiException {
  TripYaCerradoException([String? message])
      : super(
          message ?? 'El viaje ya estaba cerrado.',
          statusCode: 400,
        );
}
