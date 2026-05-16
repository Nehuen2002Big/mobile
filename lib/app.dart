import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'features/alertas/data/notificaciones_alertas.dart';
import 'features/alertas/ui/operator_directive_overlay.dart';
import 'features/ingest/service/gps_foreground_task.dart' show fgKeyAppForeground;
import 'features/permisos/ui/permisos_gate_screen.dart';
import 'ui/theme/app_theme.dart';

class MobileIsaTechApp extends ConsumerStatefulWidget {
  const MobileIsaTechApp({super.key});

  @override
  ConsumerState<MobileIsaTechApp> createState() => _MobileIsaTechAppState();
}

class _MobileIsaTechAppState extends ConsumerState<MobileIsaTechApp>
    with WidgetsBindingObserver {
  bool _bootstrapped = false;
  bool _permisosOk = false;
  StreamSubscription<NotifTapPayload>? _notifTapSub;

  @override
  void initState() {
    super.initState();
    // Observar lifecycle para que el isolate background del foreground
    // service sepa si la app esta visible. Si lo esta, el bg suprime
    // notif del SO para mensajes y pending-action — el banner
    // persistente / fake-call del foreground ya cubren ese caso, asi
    // evitamos heads-up duplicada al chofer.
    WidgetsBinding.instance.addObserver(this);
    // Marcar foreground al arrancar (acabamos de ser construidos =
    // visibles). El didChangeAppLifecycleState lo va re-actualizando.
    unawaited(FlutterForegroundTask.saveData(
      key: fgKeyAppForeground,
      value: true,
    ));
    // Cuando el chofer toca una notificacion del SO, hacer deep-link al
    // lugar correcto segun el tipo:
    //   - chat    → pantalla del chat del viaje (mensaje normal, L1, supervisor)
    //   - alerta  → pantalla del viaje (donde está el banner "Acción
    //               requerida" con el botón "Recibido" para L2/L3)
    //   - llamada → pantalla fake-call full-screen con botones de respuesta
    _notifTapSub =
        NotificacionesAlertas.instance.tapStream.listen((payload) {
      if (!mounted || !_permisosOk) return;
      final router = ref.read(routerProvider);
      if (payload.esLlamada) {
        final qp = <String, String>{
          if (payload.alertId != null) 'alertId': '${payload.alertId}',
          if (payload.regla != null) 'regla': payload.regla!,
          if (payload.contenido != null) 'contenido': payload.contenido!,
        };
        final query = qp.isEmpty
            ? ''
            : '?${qp.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&')}';
        router.go('/viaje/${payload.tripId}/llamada$query');
      } else if (payload.esAlerta) {
        // L2/L3: la pantalla del viaje muestra el banner persistente con
        // el boton "Recibido" — eso es lo que el chofer necesita ver.
        router.go('/viaje/${payload.tripId}');
      } else if (payload.esViajeListo || payload.esDirectivaOperador) {
        // [VIAJE LISTO] (MC-017) y [OPERADOR · X] (MC-018): el chofer
        // quiere ver el detalle del viaje, no scrollear el chat.
        router.go('/viaje/${payload.tripId}');
      } else {
        router.go('/viaje/${payload.tripId}/chat');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifTapSub?.cancel();
    // Al destruirse la app marcamos foreground=false: si el bg isolate
    // sigue corriendo (apps en background con foreground service de
    // Android), va a empezar a disparar notif del SO normalmente.
    unawaited(FlutterForegroundTask.saveData(
      key: fgKeyAppForeground,
      value: false,
    ));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // resumed = visible y con foco (foreground real).
    // inactive/paused/hidden/detached = no es foreground.
    final isForeground = state == AppLifecycleState.resumed;
    unawaited(FlutterForegroundTask.saveData(
      key: fgKeyAppForeground,
      value: isForeground,
    ));
  }

  void _onPermisosListo() {
    if (_permisosOk) return;
    setState(() => _permisosOk = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_permisosOk) {
      // Pantalla bloqueante hasta que se otorguen Notifications + Location.
      return MaterialApp(
        title: 'IsaTech Conductor',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: PermisosGateScreen(onListo: _onPermisosListo),
      );
    }
    if (!_bootstrapped) {
      _bootstrapped = true;
      Future.microtask(
          () => ref.read(authNotifierProvider.notifier).bootstrap());
    }
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'IsaTech Conductor',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
      // Overlay global para directivas del operador (MC-018). Vive
      // arriba del navegador para que aparezca desde cualquier
      // pantalla (viaje, chat, navegacion, etc) sin interrumpir lo
      // que estaba haciendo el chofer.
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            const OperatorDirectiveOverlay(),
          ],
        );
      },
    );
  }
}
