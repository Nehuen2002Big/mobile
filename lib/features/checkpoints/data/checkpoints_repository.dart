import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../shared/models/proximity_error.dart';
import '../models/checkpoint_list_response.dart';
import '../models/checkpoint_reach_request.dart';
import '../models/checkpoint_reach_response.dart';
import 'checkpoint_exceptions.dart';

class CheckpointsRepository {
  CheckpointsRepository(this._client);

  final DioClient _client;

  Future<CheckpointListResponse> listar(String tripId) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/checkpoints',
      );
      return CheckpointListResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudieron cargar los checkpoints');
    }
  }

  /// Marca el checkpoint como alcanzado. Parsea los errores 422/409 en
  /// excepciones especificas para que la UI pueda reaccionar con mensajes
  /// claros (distancia actual, etc).
  Future<CheckpointReachResponse> marcarLlegada({
    required String tripId,
    required int index,
    required CheckpointReachRequest payload,
  }) async {
    try {
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/checkpoints/$index/reach',
        data: payload.toJson(),
      );
      return CheckpointReachResponse.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      // 422 con detalle estructurado. Puede ser de proximidad (phone/device)
      // o de contenido faltante (image_required, reason_required).
      if (resp?.statusCode == 422 && data is Map) {
        final detail = data['detail'];
        if (detail is Map<String, dynamic>) {
          final errorCode = detail['error']?.toString() ?? '';
          if (errorCode == 'image_required') {
            throw EvidenciaFotoRequeridaException(
              actionType: detail['action_type']?.toString() ?? 'delivery',
              message: detail['message'] as String?,
            );
          }
          if (errorCode == 'reason_required') {
            throw EvidenciaMotivoRequeridoException(
              message: detail['message'] as String?,
            );
          }
          // Cualquier otro error 422 con estructura es de proximidad.
          final pe = ProximityError.fromJson(detail);
          throw CheckpointReachProximityException(pe);
        }
      }
      // 409 Conflict: ya marcado o sin coordenadas. El detail es string.
      if (resp?.statusCode == 409 && data is Map) {
        final detail = data['detail']?.toString() ?? '';
        if (detail.toLowerCase().contains('already reached')) {
          throw CheckpointYaMarcadoException(detail);
        }
        if (detail.toLowerCase().contains('no coordinates')) {
          throw CheckpointSinCoordenadasException(detail);
        }
      }
      throw mapDioError(e, fallback: 'No se pudo marcar el checkpoint');
    }
  }
}
