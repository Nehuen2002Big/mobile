import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../models/perfil.dart';

class PerfilRepository {
  PerfilRepository(this._client);

  final DioClient _client;

  Future<Perfil> miPerfil() async {
    try {
      final res =
          await _client.personas.get<Map<String, dynamic>>('/me/profile');
      return Perfil.fromEnvelope(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo obtener el perfil');
    }
  }
}
