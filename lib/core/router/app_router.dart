import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/alertas/ui/fake_call_screen.dart';
import '../../features/auth/state/auth_state.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/chat/ui/chat_screen.dart';
import '../../features/debug/ui/simulador_ubicacion_screen.dart';
import '../../features/hoja_ruta/ui/trips_list_screen.dart';
import '../../features/navegacion/ui/navegacion_screen.dart';
import '../../features/viaje/ui/viaje_activo_screen.dart';
import '../providers.dart';

/// Provider del GoRouter que escucha cambios de auth via Listenable bridge.
final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    refreshListenable: listenable,
    initialLocation: '/',
    redirect: (context, state) {
      final auth = ref.read(authNotifierProvider);
      final loc = state.matchedLocation;
      switch (auth.status) {
        case AuthStatus.desconocido:
          return '/splash';
        case AuthStatus.anonimo:
          return loc == '/login' ? null : '/login';
        case AuthStatus.autenticado:
          if (loc == '/login' || loc == '/splash' || loc == '/') {
            return '/viajes';
          }
          // Gate de /debug/ubicacion (simulador): solo admin en debug
          // builds. Defensa en profundidad sobre el gate del boton del
          // AppBar — por si alguien intenta navegar por URL directa.
          if (loc == '/debug/ubicacion') {
            final esAdmin = auth.user?.esAdmin ?? false;
            if (!kDebugMode || !esAdmin) return '/viajes';
          }
          return null;
      }
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const _Blank()),
      GoRoute(path: '/splash', builder: (_, __) => const _Splash()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/viajes', builder: (_, __) => const TripsListScreen()),
      GoRoute(
        path: '/viaje/:tripId',
        builder: (_, st) =>
            ViajeActivoScreen(tripId: st.pathParameters['tripId']!),
      ),
      GoRoute(
        path: '/viaje/:tripId/chat',
        builder: (_, st) =>
            ChatScreen(tripId: st.pathParameters['tripId']!),
      ),
      GoRoute(
        path: '/viaje/:tripId/llamada',
        builder: (_, st) {
          final tripId = st.pathParameters['tripId']!;
          final params = st.uri.queryParameters;
          final alertIdRaw = params['alertId'];
          // `error` (opcional) es un query param que el FakeCall usa
          // para mostrar el banner rojo de "ack fallo, reintentar". Lo
          // setea el deep-link de una notif si quisieramos forzar el
          // estado de error desde afuera; el reintentar interno (mismo
          // FakeCall) usa la ruta `/fake-call` con `extra` en su lugar.
          return FakeCallScreen(
            tripId: tripId,
            alertId: alertIdRaw != null ? int.tryParse(alertIdRaw) : null,
            regla: params['regla'] ?? 'Alerta',
            contenido: params['contenido'] ?? '',
            errorMessage:
                (params['error'] ?? '').isEmpty ? null : params['error'],
          );
        },
      ),
      GoRoute(
        path: '/viaje/:tripId/navegacion',
        builder: (_, st) =>
            NavegacionScreen(tripId: st.pathParameters['tripId']!),
      ),
      GoRoute(
        path: '/debug/ubicacion',
        builder: (_, __) => const SimuladorUbicacionScreen(),
      ),
      GoRoute(
        path: '/viaje/:tripId/fake-call',
        builder: (_, st) {
          final extra = st.extra as Map<String, dynamic>? ?? {};
          // `errorMessage` viene cuando el ack optimista del fake-call
          // anterior fallo (5xx/network) y la pantalla se reabre con
          // banner rojo + boton "Reintentar". Ver _onEstoyBien() en
          // fake_call_screen.dart.
          final err = extra['errorMessage'] as String?;
          return FakeCallScreen(
            tripId: st.pathParameters['tripId']!,
            alertId: extra['alertId'] as int?,
            regla: extra['regla'] as String? ?? '',
            contenido: extra['contenido'] as String? ?? '',
            errorMessage: (err == null || err.isEmpty) ? null : err,
          );
        },
      ),
    ],
  );
});

/// Bridge: notifica a GoRouter cuando cambia el estado de auth.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this._ref) {
    _sub = _ref.listen<AuthStateData>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AuthStateData> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

class _Blank extends StatelessWidget {
  const _Blank();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _Splash extends StatelessWidget {
  const _Splash();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
