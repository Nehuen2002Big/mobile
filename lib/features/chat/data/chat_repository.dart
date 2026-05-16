import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../models/message_create_request.dart';
import '../models/message_list_response.dart';
import '../models/trip_message.dart';

class ChatRepository {
  ChatRepository(this._client);

  final DioClient _client;

  /// Lista mensajes del trip. Si `afterId` se provee, devuelve solo los nuevos.
  Future<MessageListResponse> listar(
    String tripId, {
    int? afterId,
    int limit = 200,
    int offset = 0,
  }) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/messages',
        queryParameters: {
          if (afterId != null) 'after_id': afterId,
          'limit': limit,
          'offset': offset,
          '_t': DateTime.now().millisecondsSinceEpoch,
        },
      );
      return MessageListResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudieron cargar los mensajes');
    }
  }

  Future<TripMessage> enviar({
    required String tripId,
    required String content,
    String? senderName,
  }) async {
    try {
      final payload = MessageCreateRequest(
        senderRole: 'DRIVER',
        senderName: senderName,
        content: content,
      );
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/messages',
        data: payload.toJson(),
      );
      return TripMessage.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo enviar el mensaje');
    }
  }

  /// Marca como leidos todos los mensajes del MONITOR que el DRIVER no habia
  /// leido. Devuelve la cantidad de mensajes marcados.
  Future<int> marcarLeidos(String tripId) async {
    try {
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/messages/read',
        data: {'reader_role': 'DRIVER'},
      );
      return (res.data?['marked_read'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo marcar como leido');
    }
  }
}
