import '../../../core/network/api_exception.dart';

/// 404 navigation_not_computed: el backend todavia no calculo la ruta para
/// este viaje. La app debe disparar POST /navigation/recompute y reintentar.
class NavigationNoComputadaException extends ApiException {
  NavigationNoComputadaException([String? message])
      : super(
          message ??
              'La ruta todavía no fue calculada por el backend.',
          statusCode: 404,
        );
}

/// 422 not_enough_waypoints: el viaje no tiene destino, no se puede rutear.
class NavigationSinWaypointsException extends ApiException {
  NavigationSinWaypointsException([String? message])
      : super(
          message ??
              'El viaje no tiene suficientes waypoints para calcular ruta.',
          statusCode: 422,
        );
}

/// 422 no_routable: OSRM no encontro ruta entre los waypoints.
class NavigationNoRuteableException extends ApiException {
  NavigationNoRuteableException([String? message])
      : super(
          message ??
              'No se encontró una ruta accesible entre los puntos. '
                  'Contactá al monitoreo.',
          statusCode: 422,
        );
}

/// 503 routing_engine_unavailable: OSRM caido en el server.
class NavigationMotorCaidoException extends ApiException {
  NavigationMotorCaidoException([String? message])
      : super(
          message ??
              'El servicio de navegación no está disponible. Reintentando...',
          statusCode: 503,
        );
}
