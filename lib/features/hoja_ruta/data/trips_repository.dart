import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/dio_client.dart';
import '../../shared/models/proximity_error.dart';
import '../../viaje/models/trip_checklist.dart';
import '../../viaje/models/trip_pause_status.dart';
import '../models/route_progress_response.dart';
import '../models/trip.dart';
import '../models/trip_finish_request.dart';
import '../models/trip_start_request.dart';
import 'trip_exceptions.dart';

class TripsRepository {
  TripsRepository(this._client);

  final DioClient _client;

  Future<List<Trip>> listar({String? driverPersonId}) async {
    try {
      final res = await _client.tracking.get<dynamic>('/trips');
      final data = res.data;
      final List raw = data is List ? data : (data is Map ? (data['items'] as List? ?? const []) : const []);
      final all = raw
          .whereType<Map<String, dynamic>>()
          .map(Trip.fromJson)
          .toList();
      if (driverPersonId == null) return all;
      return all.where((t) => t.driverPersonId == driverPersonId).toList();
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudieron cargar los viajes');
    }
  }

  Future<Trip> detalle(String tripId) async {
    try {
      final res = await _client.tracking
          .get<Map<String, dynamic>>('/trips/$tripId');
      debugPrint('TRIP RAW: ${jsonEncode(res.data)}');
      return Trip.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo cargar el viaje');
    }
  }

  /// Finaliza un viaje ACTIVE. Requiere GPS del telefono. El backend valida
  /// que tanto el telefono como el satelital del camion esten cerca del
  /// destino (por default 150m). Si alguno falla, lanza
  /// [TripFinishProximityException] con el detalle estructurado.
  Future<Trip> finalizar({
    required String tripId,
    required double lat,
    required double lon,
    double? maxDistanceM,
  }) async {
    try {
      final payload = TripFinishRequest(
        lat: lat,
        lon: lon,
        maxDistanceM: maxDistanceM,
      );
      final res = await _client.tracking.patch<Map<String, dynamic>>(
        '/trips/$tripId/finish',
        data: payload.toJson(),
      );
      return Trip.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      // 422 = proximity error (telefono o satelital lejos del destino).
      // Llevamos el detalle estructurado para que la UI muestre la
      // distancia restante con un mensaje accionable.
      if (resp?.statusCode == 422 && data is Map) {
        final detail = data['detail'];
        if (detail is Map<String, dynamic>) {
          final pe = ProximityError.fromJson(detail);
          throw TripFinishProximityException(pe);
        }
      }
      // 400 = trip ya estaba cerrado (cancelado desde la web, o cerrado
      // en otra sesion del chofer). NO es error real — la UI debe
      // re-sincronizar y volver al listado sin mostrar alerta roja.
      if (resp?.statusCode == 400) {
        final detail = data is Map ? data['detail']?.toString() : null;
        throw TripYaCerradoException(detail);
      }
      throw mapDioError(e, fallback: 'No se pudo finalizar el viaje');
    }
  }

  /// Inicia un viaje PENDING. Requiere GPS actual del dispositivo para que
  /// el backend valide que el chofer esta en el origen (< 100m por default).
  /// Lanza excepciones especificas para 422/409 para que la UI reaccione.
  Future<Trip> iniciarViaje({
    required String tripId,
    required double lat,
    required double lon,
    double? maxDistanceM,
  }) async {
    try {
      final payload = TripStartRequest(
        lat: lat,
        lon: lon,
        maxDistanceM: maxDistanceM,
      );
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/start',
        data: payload.toJson(),
      );
      return Trip.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      final data = resp?.data;
      if (resp?.statusCode == 422 && data is Map) {
        final detail = data['detail'];
        if (detail is Map<String, dynamic>) {
          final pe = ProximityError.fromJson(detail);
          throw TripStartProximityException(pe);
        }
      }
      if (resp?.statusCode == 409 && data is Map) {
        final detail = data['detail']?.toString() ?? '';
        throw TripEstadoInvalidoException(detail);
      }
      throw mapDioError(e, fallback: 'No se pudo iniciar el viaje');
    }
  }

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

  /// Consulta el estado de pausa de un viaje (MC-015). Devuelve un
  /// snapshot con `paused: true|false`. El backend hace cleanup lazy de
  /// pausas vencidas — el primer poll despues de `ends_at` ya devuelve
  /// `paused: false` sin necesidad de timers en la app.
  Future<TripPauseStatus> pauseStatus(String tripId) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/pause/status',
      );
      return TripPauseStatus.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo consultar el estado de pausa');
    }
  }

  /// Cancela anticipadamente la pausa activa del viaje (MC-015). Es
  /// idempotente del lado backend: si ya no habia pausa activa
  /// (expiro entre el poll y el click), devuelve `paused: false` sin
  /// error y devolvemos eso mismo.
  Future<TripPauseStatus> endPause(String tripId) async {
    try {
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/pause/end',
      );
      return TripPauseStatus.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo cancelar la pausa');
    }
  }

  /// Lee el checklist de salida completo de un viaje (MC-022). Para
  /// viajes viejos pre-MC-022 el backend puede devolver `items: []`
  /// (200 con lista vacia) o directamente 404 (el endpoint no encontro
  /// `params.checklist`). Tratamos ambos casos como "sin checklist":
  /// la seccion se autocolapsa y el boton Iniciar viaje no se bloquea.
  Future<TripChecklist> getChecklist(String tripId) async {
    try {
      final res = await _client.tracking.get<Map<String, dynamic>>(
        '/trips/$tripId/checklist',
      );
      return TripChecklist.fromJson(res.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Trip sin checklist definido — caso esperado para viajes
        // legacy. NO es error real, devolvemos snapshot vacio.
        return TripChecklist.empty(tripId);
      }
      throw mapDioError(e, fallback: 'No se pudo cargar el checklist');
    }
  }

  /// Marca un item como tildado. El backend gatea que el JWT pertenezca
  /// al chofer asignado y que el trip no este FINISHED/CANCELLED.
  /// Devuelve el item actualizado (con `checked: true`, `checked_at`,
  /// `checked_by`).
  Future<ChecklistItem> checkChecklistItem({
    required String tripId,
    required String itemKey,
  }) =>
      _toggleChecklistItem(tripId: tripId, itemKey: itemKey, check: true);

  /// Destilda un item por si el chofer se equivoco. Mismas garantias de
  /// permisos y estado que [checkChecklistItem]. Devuelve el item con
  /// `checked: false` y metadatos en null.
  Future<ChecklistItem> uncheckChecklistItem({
    required String tripId,
    required String itemKey,
  }) =>
      _toggleChecklistItem(tripId: tripId, itemKey: itemKey, check: false);

  Future<ChecklistItem> _toggleChecklistItem({
    required String tripId,
    required String itemKey,
    required bool check,
  }) async {
    final accion = check ? 'check' : 'uncheck';
    try {
      final res = await _client.tracking.post<Map<String, dynamic>>(
        '/trips/$tripId/checklist/items/$itemKey/$accion',
      );
      return ChecklistItem.fromJson(res.data!);
    } on DioException catch (e) {
      final resp = e.response;
      switch (resp?.statusCode) {
        case 403:
          throw ChecklistNoAutorizadoException();
        case 404:
          throw ChecklistItemNoEncontradoException();
        case 409:
          throw ChecklistTripCerradoException();
      }
      throw mapDioError(
        e,
        fallback: check
            ? 'No se pudo marcar el ítem'
            : 'No se pudo destildar el ítem',
      );
    }
  }
}
