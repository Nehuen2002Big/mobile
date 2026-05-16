import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../models/alerta.dart';
import '../models/tracking_alert.dart';
import 'alerta_exceptions.dart';

class AlertasRepository {
  AlertasRepository(this._client);

  final DioClient _client;

  Future<void> enviar({
    required String tripId,
    required AlertaPayload payload,
  }) async {
    try {
      await _client.tracking.post(
        '/trips/$tripId/alerts',
        data: payload.toJson(),
      );
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      if (resp?.statusCode == 422 && data is Map) {
        final detail = data['detail'];
        if (detail is Map && detail['error'] == 'image_required') {
          throw AlertaSinFotoException(detail['message'] as String?);
        }
        if (detail is Map && detail['error'] == 'trip_not_stopped') {
          // El backend rechazo PARADA_COMER / PARADA_DESCANSAR porque el
          // ultimo ping DEVICE reporta speed_kmh > 5. Lleva alert_type,
          // last_device_speed_kmh y un mensaje accionable para mostrar.
          final speedRaw = detail['last_device_speed_kmh'];
          final speed = speedRaw is num ? speedRaw.toDouble() : 0.0;
          throw TripNoDetenidoException(
            alertType: (detail['alert_type'] as String?) ?? payload.alertType,
            lastDeviceSpeedKmh: speed,
            message: detail['message'] as String?,
          );
        }
      }
      if (resp?.statusCode == 400 && data is Map) {
        final detail = data['detail'];
        if (detail is Map &&
            detail['error'] == 'alert_type_not_allowed_for_driver') {
          throw TipoAlertaNoPermitidaException(detail['message'] as String?);
        }
      }
      throw mapDioError(e, fallback: 'No se pudo enviar la alerta');
    }
  }

  /// Devuelve las alertas L2/L3 que el chofer todavia no marco como
  /// atendidas. La UI las muestra como banner persistente.
  Future<PendingActionAlertsResponse> pendingAction(String tripId) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/alerts/pending-action',
      );
      return PendingActionAlertsResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudieron cargar alertas pendientes');
    }
  }

  /// Marca una o varias alertas como acknowledged. Las alertas ya
  /// acknowledged se ignoran silenciosamente del lado del backend.
  ///
  /// **IMPORTANTE — NO duplicar la logica del backend.** Desde MC-006,
  /// el backend hace ACK automatico de TODAS las L2/L3 pendientes
  /// cuando el chofer:
  ///   1. Postea un mensaje al chat (sender_role=DRIVER), o
  ///   2. Crea una alerta nueva (TRAFICO/AVERIA/ACCIDENTE/PARADA_COMER), o
  ///   3. Finaliza/cancela el viaje.
  /// La app NO debe llamar `acknowledge()` post-mensaje ni post-alerta
  /// — solo dispara el tick inmediato del `PendingActionNotifier` para
  /// que el banner reaccione rapido al `total=0` del proximo poll.
  ///
  /// Los unicos call-sites legitimos hoy son acciones explicitas del
  /// chofer atendiendo la cascada:
  ///   - PendingActionBanner "Recibido" / DetallesSheet
  ///   - FakeCallScreen "Estoy bien" / "Necesito ayuda"
  ///   - Background notif "Estoy bien" (action button del SO)
  Future<int> acknowledge(List<int> alertIds) async {
    if (alertIds.isEmpty) return 0;
    try {
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/alerts/acknowledge',
        data: {'alert_ids': alertIds},
      );
      return (res.data?['acknowledged'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw mapDioError(
        e,
        fallback: 'No se pudieron marcar las alertas como atendidas',
      );
    }
  }
}
