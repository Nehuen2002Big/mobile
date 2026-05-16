import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../models/login_response.dart';
import '../models/user.dart';

class AuthRepository {
  AuthRepository(this._client);

  final DioClient _client;

  Future<LoginResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final res = await _client.iamNoAuth.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'identifier': identifier, 'password': password},
      );
      return LoginResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'Credenciales invalidas');
    }
  }

  Future<LoginResponse> refresh(String refreshToken) async {
    try {
      final res = await _client.iamNoAuth.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return LoginResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo refrescar la sesion');
    }
  }

  Future<AuthUser> me() async {
    try {
      final res = await _client.iam.get<Map<String, dynamic>>('/auth/me');
      return AuthUser.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e, fallback: 'No se pudo obtener el perfil IAM');
    }
  }
}
