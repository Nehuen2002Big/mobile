import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../models/location_info.dart';

class LocationsRepository {
  LocationsRepository(this._client);

  final DioClient _client;

  Future<LocationInfo> obtenerPorId(String id) async {
    try {
      final res = await _client.routes.get<Map<String, dynamic>>(
        '/locations/$id',
      );
      return LocationInfo.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo cargar la ubicacion');
    }
  }
}
