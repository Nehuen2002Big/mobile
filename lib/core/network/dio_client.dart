import 'dart:async';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

typedef OnUnauthorized = Future<void> Function();

class DioClient {
  DioClient({
    required this.config,
    required this.tokenStorage,
    required this.onUnauthorized,
  }) {
    iam = _build(config.iamApi, attachToken: true);
    iamNoAuth = _build(config.iamApi, attachToken: false);
    personas = _build(config.personasApi, attachToken: true);
    tracking = _build(config.trackingApi, attachToken: true);
    routes = _build(config.routesApi, attachToken: true);
  }

  final ApiConfig config;
  final TokenStorage tokenStorage;
  final OnUnauthorized onUnauthorized;

  late final Dio iam;
  late final Dio iamNoAuth;
  late final Dio personas;
  late final Dio tracking;
  late final Dio routes;

  // Evita refrescos concurrentes: todas las requests en vuelo esperan el mismo refresh.
  Completer<String?>? _refreshing;

  Future<String?> _refreshIfPossible() async {
    final inFlight = _refreshing;
    if (inFlight != null) return inFlight.future;
    final completer = Completer<String?>();
    _refreshing = completer;
    try {
      final refreshToken = await tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        completer.complete(null);
        return null;
      }
      final res = await iamNoAuth.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final newAccess = res.data!['access_token'] as String;
      final newRefresh = res.data!['refresh_token'] as String? ?? refreshToken;
      // El backend devuelve `expires_in` en segundos. Si no viene,
      // asumimos 900 (15 min, default de IAM).
      final expiresIn = (res.data!['expires_in'] as num?)?.toInt() ?? 900;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
      await tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
        expiresAt: expiresAt,
      );
      completer.complete(newAccess);
      return newAccess;
    } catch (e) {
      completer.complete(null);
      return null;
    } finally {
      _refreshing = null;
    }
  }

  /// True si el access_token expira dentro del proximo umbral. Si no
  /// hay expires_at persistido (ej. token de version vieja), devuelve
  /// false — dejamos que el flujo reactivo del 401 maneje la expiracion.
  Future<bool> _isTokenExpiringSoon({
    Duration umbral = const Duration(seconds: 60),
  }) async {
    final expiresAt = await tokenStorage.readExpiresAt();
    if (expiresAt == null) return false;
    return expiresAt.isBefore(DateTime.now().add(umbral));
  }

  Dio _build(String baseUrl, {required bool attachToken}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    if (attachToken) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Refresh proactivo: si el access_token expira en <60s,
            // refrescamos antes de attach. Esto evita el roundtrip
            // extra del retry post-401 cuando el chofer abre la app
            // despues de un rato. Es best-effort: si falla, igual
            // adjuntamos el token actual y dejamos que el handler
            // reactivo del 401 (mas abajo) cubra el caso.
            //
            // Si la propia request ya es a `/auth/refresh` la salteamos
            // — sino caemos en recursion infinita.
            final esRefreshEndpoint = options.path.endsWith('/auth/refresh');
            if (!esRefreshEndpoint && await _isTokenExpiringSoon()) {
              await _refreshIfPossible();
            }
            final token = await tokenStorage.readAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
          onError: (error, handler) async {
            final req = error.requestOptions;
            final alreadyRetried = req.extra['__retriedRefresh'] == true;
            if (error.response?.statusCode == 401 && !alreadyRetried) {
              final newToken = await _refreshIfPossible();
              if (newToken != null) {
                // Reintentar la request original con el nuevo token.
                req.extra['__retriedRefresh'] = true;
                req.headers['Authorization'] = 'Bearer $newToken';
                try {
                  final retry = await dio.fetch(req);
                  handler.resolve(retry);
                  return;
                } catch (e) {
                  if (e is DioException) {
                    handler.reject(e);
                    return;
                  }
                  handler.reject(error);
                  return;
                }
              }
              // Sin refresh token valido: logout y reject.
              await onUnauthorized();
              handler.reject(
                DioException(
                  requestOptions: req,
                  error: UnauthorizedException(),
                  type: DioExceptionType.badResponse,
                  response: error.response,
                ),
              );
              return;
            }
            handler.next(error);
          },
        ),
      );
    }

    return dio;
  }
}

ApiException mapDioError(Object error, {String fallback = 'Error de red'}) {
  if (error is DioException) {
    if (error.error is ApiException) return error.error as ApiException;
    final code = error.response?.statusCode;
    final data = error.response?.data;
    String message = fallback;
    // 403 dedicado: el token es valido pero el rol/permisos del user
    // no le alcanzan para este endpoint. Mensaje accionable.
    // Si el backend manda un `detail` mas especifico, lo preferimos.
    if (code == 403) {
      if (data is Map && data['detail'] is String) {
        message = data['detail'] as String;
      } else {
        message =
            'Tu cuenta no tiene permisos para esta app. Contactá al administrador.';
      }
      return ApiException(message, statusCode: code, cause: error);
    }
    if (data is Map && data['detail'] is String) {
      message = data['detail'] as String;
    } else if (data is Map && data['message'] is String) {
      message = data['message'] as String;
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      message = 'Tiempo de conexion agotado';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'No se pudo conectar al servidor';
    } else if (error.type == DioExceptionType.badCertificate) {
      message = 'Certificado SSL invalido';
    } else if (error.type == DioExceptionType.badResponse) {
      message = 'Respuesta invalida del servidor (status $code)';
    } else {
      message = '$fallback [${error.type.name}: ${error.message ?? error.error ?? '-'}]';
    }
    return ApiException(message, statusCode: code, cause: error);
  }
  if (error is ApiException) return error;
  return ApiException(fallback, cause: error);
}
