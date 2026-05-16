import '../../../core/network/api_exception.dart';

/// 409 cuando el viaje ya esta FINISHED o CANCELLED y el backend rechaza
/// nuevos phone-location pings.
class TripYaTerminadoException extends ApiException {
  TripYaTerminadoException([String? message])
      : super(
          message ?? 'El viaje ya termino, no se aceptan mas ubicaciones.',
          statusCode: 409,
        );
}
