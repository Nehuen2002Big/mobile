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

/// 403 al check/uncheck cuando el JWT no corresponde al chofer asignado
/// del trip. No deberia pasar en flujo normal (el chofer solo ve sus
/// propios viajes) pero lo mapeamos por defensa: si pasa, la app
/// revierte la marca optimista y avisa al chofer.
class ChecklistNoAutorizadoException extends ApiException {
  ChecklistNoAutorizadoException([String? message])
      : super(
          message ?? 'No tenés permiso para modificar este checklist.',
          statusCode: 403,
        );
}

/// 404 al check/uncheck cuando el item key no existe en el checklist
/// del trip. Indica que el cache local quedo desactualizado (el
/// operador probablemente edito la hoja de ruta). La UI debe refrescar.
class ChecklistItemNoEncontradoException extends ApiException {
  ChecklistItemNoEncontradoException([String? message])
      : super(
          message ?? 'El ítem del checklist ya no existe. Refrescá.',
          statusCode: 404,
        );
}

/// 409 al check/uncheck cuando el trip ya esta FINISHED o CANCELLED.
/// El checklist es read-only despues del cierre. La UI debe refrescar.
class ChecklistTripCerradoException extends ApiException {
  ChecklistTripCerradoException([String? message])
      : super(
          message ?? 'El viaje ya está cerrado; no se modifica el checklist.',
          statusCode: 409,
        );
}
