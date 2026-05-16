import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../hoja_ruta/models/route_progress_response.dart';
import '../models/trip_navigation.dart';
import 'navigation_exceptions.dart';

/// Cliente para los endpoints de navegacion turn-by-turn del backend de
/// tracking. Reemplaza al RoutingRepository que pegaba al OSRM publico —
/// ahora el calculo lo hace el server al crear/iniciar el viaje y la app
/// solo consume.
class NavigationRepository {
  NavigationRepository(this._client);

  final DioClient _client;

  /// GET /trips/{trip_id}/navigation. Si el backend no tiene la ruta
  /// computada todavia, lanza [NavigationNoComputadaException].
  Future<TripNavigation> obtener(String tripId) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/navigation',
      );
      return TripNavigation.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      if (resp?.statusCode == 404 && data is Map) {
        final detail = data['detail'];
        if (detail is Map && detail['error'] == 'navigation_not_computed') {
          throw NavigationNoComputadaException(detail['message'] as String?);
        }
      }
      if (resp?.statusCode == 503) {
        throw NavigationMotorCaidoException(_msg(data));
      }
      throw mapDioError(e, fallback: 'No se pudo cargar la navegación');
    }
  }

  /// GET /trips/{trip_id}/route-progress. Polea cada 5-10s mientras la
  /// pantalla de navegacion esta abierta.
  Future<RouteProgressResponse> progreso(String tripId) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/route-progress',
      );
      return RouteProgressResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo cargar el progreso');
    }
  }

  /// POST /trips/{trip_id}/navigation/recompute.
  ///
  /// Dos modos de uso:
  ///
  /// 1. **Fallback inicial** (sin `startLat`/`startLon`): cuando
  ///    `obtener()` devolvio `NavigationNoComputadaException`. El
  ///    backend recomputa desde el origen del trip.
  ///
  /// 2. **Auto-reroute** (con `startLat`/`startLon` — MC-021): cuando
  ///    el chofer se desvio >50 m del polyline por mas de 10 s. El
  ///    backend recomputa desde la posicion actual del telefono.
  ///    Devuelve el nuevo payload para que la app reemplace su state
  ///    sin necesidad de un GET extra.
  Future<TripNavigation?> recomputar(
    String tripId, {
    double? startLat,
    double? startLon,
  }) async {
    try {
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/navigation/recompute',
        queryParameters: {
          if (startLat != null) 'start_lat': startLat,
          if (startLon != null) 'start_lon': startLon,
        },
      );
      final data = res.data;
      if (data == null) return null;
      return TripNavigation.fromJson(data);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      if (resp?.statusCode == 422 && data is Map) {
        final detail = data['detail'];
        if (detail is Map) {
          if (detail['error'] == 'not_enough_waypoints') {
            throw NavigationSinWaypointsException(
              detail['message'] as String?,
            );
          }
          if (detail['error'] == 'no_routable') {
            throw NavigationNoRuteableException(detail['message'] as String?);
          }
        }
      }
      if (resp?.statusCode == 503) {
        throw NavigationMotorCaidoException(_msg(data));
      }
      throw mapDioError(e, fallback: 'No se pudo recomputar la navegación');
    }
  }

  String? _msg(Object? data) {
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is Map && detail['message'] is String) {
        return detail['message'] as String;
      }
    }
    return null;
  }
}
