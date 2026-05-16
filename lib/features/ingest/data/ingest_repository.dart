import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../models/ingest_result.dart';
import '../models/phone_location_request.dart';
import '../models/phone_location_response.dart';
import 'phone_location_exceptions.dart';

export '../models/ingest_result.dart';
export '../models/phone_location_request.dart';
export '../models/phone_location_response.dart';

class IngestRepository {
  IngestRepository(this._client);

  final DioClient _client;

  /// El backend devuelve una lista con un resultado por trip activo del IMEI.
  /// Si la lista esta vacia significa que no hay trips activos para ese IMEI
  /// y el punto fue descartado. Devolvemos el primer resultado (el viaje principal)
  /// o un IngestResult vacio como fallback.
  Future<IngestResult> enviarPunto({
    required String imei,
    required double lat,
    required double lon,
    double? speedKmh,
    DateTime? recordedAt,
  }) async {
    try {
      final res = await _client.tracking.post<List<dynamic>>(
        '/ingest/$imei',
        data: {
          'lat': lat,
          'lon': lon,
          if (speedKmh != null) 'speed_kmh': speedKmh,
          'recorded_at':
              (recordedAt ?? DateTime.now().toUtc()).toUtc().toIso8601String(),
        },
      );
      final list = res.data ?? const [];
      if (list.isEmpty) return const IngestResult();
      final first = list.first as Map<String, dynamic>;
      return IngestResult.fromJson(first);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo enviar la ubicacion');
    }
  }

  /// Reporta la ubicacion del telefono del chofer. Se corre en paralelo al
  /// /ingest/{imei} del camion. No dispara alertas ni afecta progreso — solo
  /// queda guardado para visualizacion en el dashboard del monitor.
  Future<PhoneLocationResponse> enviarPhoneLocation({
    required String tripId,
    required double lat,
    required double lon,
    double? speedKmh,
    DateTime? recordedAt,
  }) async {
    try {
      final payload = PhoneLocationRequest(
        lat: lat,
        lon: lon,
        speedKmh: speedKmh,
        recordedAt: recordedAt ?? DateTime.now().toUtc(),
      );
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/phone-location',
        data: payload.toJson(),
      );
      return PhoneLocationResponse.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      if (resp?.statusCode == 409) {
        final detail = data is Map ? data['detail']?.toString() : null;
        throw TripYaTerminadoException(detail);
      }
      if (resp?.statusCode == 422 && data is Map) {
        // Extraer el detalle especifico del backend (validacion Pydantic o
        // validacion de negocio custom).
        final detail = data['detail'];
        String msg = 'Phone-location rechazado (422)';
        if (detail is String) {
          msg = 'Phone-location 422: $detail';
        } else if (detail is Map) {
          if (detail['message'] is String) {
            msg = 'Phone-location 422: ${detail['message']}';
          } else if (detail['error'] is String) {
            msg = 'Phone-location 422 error=${detail['error']}';
          } else {
            msg = 'Phone-location 422: $detail';
          }
        } else if (detail is List) {
          // Pydantic devuelve una lista de errores de validacion por campo.
          msg = 'Phone-location 422 (validation): $detail';
        }
        throw ApiException(msg, statusCode: 422, cause: e);
      }
      throw mapDioError(e, fallback: 'No se pudo reportar ubicacion del telefono');
    }
  }
}
