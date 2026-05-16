class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Sesion expirada'])
      : super(message, statusCode: 401);
}

/// Sanity check post-login: el user logueo OK contra IAM, pero su
/// perfil en Persons no es de chofer (`driver_profile == null`).
/// Rechazamos el login con un mensaje claro al usuario.
class NoEsConductorException extends ApiException {
  NoEsConductorException()
      : super(
          'Esta app es solo para choferes. '
          'Si sos operador, usá la consola web de IsaTech.',
          statusCode: 200,
        );
}

/// El user no tiene Person link en Persons (`/me/profile` 404). El
/// admin tiene que asociar la cuenta a un Person con driver_profile.
class SinPerfilChoferException extends ApiException {
  SinPerfilChoferException()
      : super(
          'Tu cuenta no tiene perfil de chofer asociado. '
          'Contactá al administrador.',
          statusCode: 404,
        );
}

/// El servicio de Persons no responde despues de varios intentos
/// (5xx persistente / red caida). No bloqueamos para siempre — la UI
/// debe ofrecer "Reintentar".
class ServicioNoDisponibleException extends ApiException {
  ServicioNoDisponibleException()
      : super(
          'El servicio no está disponible en este momento. '
          'Verificá tu conexión y reintentá.',
        );
}
