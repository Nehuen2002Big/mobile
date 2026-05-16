import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../models/login_response.dart';
import '../models/user.dart';
import '../../perfil/models/perfil.dart';

part 'auth_state.freezed.dart';

// --- Estado de autenticacion ---

enum AuthStatus { desconocido, autenticado, anonimo }

@freezed
class AuthStateData with _$AuthStateData {
  const factory AuthStateData({
    @Default(AuthStatus.desconocido) AuthStatus status,
    AuthUser? user,
    Perfil? perfil,
    String? error,
    @Default(false) bool loading,
  }) = _AuthStateData;
}

// --- Notifier ---

class AuthNotifier extends Notifier<AuthStateData> {
  @override
  AuthStateData build() {
    return const AuthStateData();
  }

  String? get personId => state.perfil?.person.id;

  /// Restaurar sesion al arranque de la app: si hay tokens guardados
  /// validos, autenticar; si no (o si la sanity check de Persons falla
  /// definitivamente), volver a `anonimo`.
  ///
  /// IMPORTANTE: si `me/profile` confirma que el user **no es chofer**
  /// (driver_profile null o 404), borramos los tokens — no podemos
  /// mantenerlo logueado en una app que no es para el. La excepcion
  /// queda en `state.error` para que la pantalla de login muestre el
  /// motivo del logout automatico.
  Future<void> bootstrap() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final token = await tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      state = state.copyWith(status: AuthStatus.anonimo);
      return;
    }
    try {
      final authRepo = ref.read(authRepoProvider);
      final u = await authRepo.me();
      await tokenStorage.saveUserId(u.id);
      final perfil = await _cargarPerfilConValidacion();
      state = state.copyWith(
        status: AuthStatus.autenticado,
        user: u,
        perfil: perfil,
      );
    } on NoEsConductorException catch (e) {
      await tokenStorage.clear();
      state = state.copyWith(status: AuthStatus.anonimo, error: e.message);
    } on SinPerfilChoferException catch (e) {
      await tokenStorage.clear();
      state = state.copyWith(status: AuthStatus.anonimo, error: e.message);
    } catch (_) {
      // Token invalido / IAM caido / network — volver a login sin
      // mensaje (el chofer puede reintentar tipeando credenciales).
      await tokenStorage.clear();
      state = state.copyWith(status: AuthStatus.anonimo);
    }
  }

  /// Login completo: pega `/auth/login` → guarda tokens con expiry →
  /// pega `/me/profile` → valida que sea chofer → setea state. Si la
  /// sanity check rechaza al user (no es chofer / no tiene perfil),
  /// borramos los tokens recien guardados antes de volver al login.
  Future<bool> login(String identifier, String password) async {
    state = state.copyWith(loading: true, error: null);
    final tokenStorage = ref.read(tokenStorageProvider);
    try {
      final authRepo = ref.read(authRepoProvider);

      final LoginResponse res = await authRepo.login(
        identifier: identifier,
        password: password,
      );
      // Calcular y persistir expires_at para el refresh proactivo del
      // interceptor (DioClient onRequest).
      final expiresAt =
          DateTime.now().add(Duration(seconds: res.expiresIn));
      await tokenStorage.saveTokens(
        accessToken: res.accessToken,
        refreshToken: res.refreshToken,
        expiresAt: expiresAt,
      );
      await tokenStorage.saveUserId(res.user.id);
      // Sanity check: que sea chofer real. Si no, esto tira y
      // bajamos al catch que limpia los tokens recien guardados.
      final perfil = await _cargarPerfilConValidacion();
      state = state.copyWith(
        status: AuthStatus.autenticado,
        user: res.user,
        perfil: perfil,
        loading: false,
      );
      return true;
    } on NoEsConductorException catch (e) {
      // Logueo OK contra IAM pero no es chofer — borrar tokens y
      // mostrar mensaje accionable.
      await tokenStorage.clear();
      state = state.copyWith(
        status: AuthStatus.anonimo,
        loading: false,
        error: e.message,
      );
      return false;
    } on SinPerfilChoferException catch (e) {
      await tokenStorage.clear();
      state = state.copyWith(
        status: AuthStatus.anonimo,
        loading: false,
        error: e.message,
      );
      return false;
    } on ServicioNoDisponibleException catch (e) {
      // Persons caido despues de 3 retries — borrar tokens (no podemos
      // confirmar chofer) y dejar que el chofer reintente login.
      await tokenStorage.clear();
      state = state.copyWith(
        status: AuthStatus.anonimo,
        loading: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      // Error generico de login (credenciales malas, IAM caido, etc).
      // Si los tokens NO se guardaron (ej. fallo el POST /auth/login)
      // no necesitamos limpiar; igual lo hacemos por las dudas.
      try {
        await tokenStorage.clear();
      } catch (_) {}
      state = state.copyWith(error: e.toString(), loading: false);
      return false;
    }
  }

  Future<void> logout() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    await tokenStorage.clear();
    state = const AuthStateData(status: AuthStatus.anonimo);
  }

  /// Limpia el mensaje de error sin tocar el resto del state. Lo usa
  /// la pantalla de login despues de mostrar el snackbar/banner.
  void limpiarError() {
    if (state.error == null) return;
    state = state.copyWith(error: null);
  }

  /// Carga `/me/profile` (Persons) con retry exponencial 1s/2s/4s ante
  /// 5xx o errores de red. Tira excepciones tipadas:
  ///
  ///   - [SinPerfilChoferException] si Persons devuelve 404 (el user
  ///     no tiene Person link).
  ///   - [NoEsConductorException] si devuelve 200 pero
  ///     `driver_profile == null` (es operador/admin).
  ///   - [ServicioNoDisponibleException] si despues de 3 reintentos
  ///     sigue 5xx / network — la UI debe ofrecer "Reintentar".
  ///
  /// 401 NO se retry-ea: si el server dice "no autorizado" para
  /// `/me/profile` con un bearer recien emitido, hay algo mal en
  /// IAM/Persons que no se arregla insistiendo. El interceptor del
  /// DioClient ya reintento una vez con refresh — si igual hay 401,
  /// vamos al catch generico (`AuthStatus.anonimo`).
  Future<Perfil> _cargarPerfilConValidacion() async {
    final perfilRepo = ref.read(perfilRepoProvider);
    final tokenStorage = ref.read(tokenStorageProvider);
    const backoffs = [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ];
    for (var intento = 0; intento <= backoffs.length; intento++) {
      try {
        final p = await perfilRepo.miPerfil();
        if (p.driverProfile == null) {
          // Cuenta valida pero no es chofer — no retry, error final.
          throw NoEsConductorException();
        }
        await tokenStorage.savePersonId(p.person.id);
        return p;
      } on NoEsConductorException {
        rethrow;
      } on SinPerfilChoferException {
        rethrow;
      } catch (e) {
        // Identificar el tipo de error para decidir retry:
        //   - 404 → SinPerfilChofer (no retry)
        //   - 5xx / connection / timeout → retry
        //   - 401 / 4xx restantes → no retry (rethrow generico)
        final status = _statusCodeOf(e);
        if (status == 404) {
          throw SinPerfilChoferException();
        }
        final esRetriable =
            status == null /* network/timeout */ || status >= 500;
        if (!esRetriable) rethrow;
        if (intento < backoffs.length) {
          if (kDebugMode) {
            // ignore: avoid_print
            print('[Auth] me/profile fallo (intento ${intento + 1}), '
                'reintentando en ${backoffs[intento].inSeconds}s — $e');
          }
          await Future<void>.delayed(backoffs[intento]);
          continue;
        }
        // Agotamos retries — degradar a "servicio no disponible" para
        // que la UI lo distinga de credenciales malas u otro 4xx.
        throw ServicioNoDisponibleException();
      }
    }
    // Inalcanzable — el loop siempre return-ea o throw-ea. El throw
    // final es defensivo por si el analizador no lo detecta.
    throw ServicioNoDisponibleException();
  }

  /// Extrae el statusCode de un error si lo tiene (ApiException,
  /// DioException). Devuelve null si no hay status (ej. error de red
  /// sin response).
  int? _statusCodeOf(Object e) {
    if (e is ApiException) return e.statusCode;
    if (e is DioException) return e.response?.statusCode;
    return null;
  }
}
