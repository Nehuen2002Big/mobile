import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

import '../../../core/providers.dart';
import '../../alertas/data/alert_styles.dart';
import '../../alertas/models/alerta.dart';
import '../../alertas/models/tracking_alert.dart';
import '../../uploads/models/checkpoint_evidence.dart';

/// Pantalla full-screen tipo "llamada entrante" que se dispara cuando llega
/// un mensaje de chat con prefijo `[LLAMADA · ...]` (cascada nivel
/// CALL/T+2min). Bloquea back, suena ringtone en loop y vibra hasta que el
/// chofer responde con uno de los dos botones:
///   - "Estoy bien" → ack la alerta original.
///   - "Necesito ayuda" → crea alerta EMERGENCIA + ack.
///
/// Si `errorMessage` viene seteado, la pantalla rendea un banner rojo arriba
/// y los botones cambian su label a "Reintentar". Esto pasa cuando el ACK
/// optimista fallo y necesitamos que el chofer reintente — lo critico es
/// que NUNCA quede el chofer creyendo que ack-eo cuando en realidad no
/// llego al backend.
class FakeCallScreen extends ConsumerStatefulWidget {
  const FakeCallScreen({
    super.key,
    required this.tripId,
    required this.alertId,
    required this.regla,
    required this.contenido,
    this.errorMessage,
  });

  final String tripId;
  final int? alertId;
  final String regla;
  final String contenido;
  /// Si !=null, la pantalla muestra este mensaje en un banner rojo y los
  /// botones cambian su label a "Reintentar". Lo seta el caller cuando
  /// el ack optimista fallo (POST /alerts/acknowledge dio 5xx/network/etc).
  final String? errorMessage;

  @override
  ConsumerState<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends ConsumerState<FakeCallScreen> {
  final _player = AudioPlayer();
  Timer? _vibrateTimer;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _arrancarRingtone();
    _arrancarVibracion();
  }

  Future<void> _arrancarRingtone() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      // Tono del sistema: notification ringtone via UrlSource. Como no hay
      // asset propio (todavia), usamos un beep generado por audioplayers
      // con la API de tone via Url. Si no hay archivo, queda silencioso —
      // la vibracion sostenida igual avisa.
      // Para mejorar UX, se puede agregar un asset en
      // assets/sounds/ringtone.mp3 y cambiar a AssetSource.
      await _player.setVolume(1.0);
      await _player.play(
        AssetSource('sounds/ringtone.mp3'),
      );
    } catch (e) {
      // Ringtone no disponible (asset faltante) — seguimos con vibracion.
      debugPrint('[FakeCall] no se pudo iniciar ringtone: $e');
    }
  }

  Future<void> _arrancarVibracion() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != true) return;
    // Patron: corto-corto-largo cada 1.5s.
    _vibrateTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 600]);
    });
    // Primer ciclo inmediato.
    Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 600]);
  }

  @override
  void dispose() {
    _vibrateTimer?.cancel();
    Vibration.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  /// ACK todas las alertas L2/L3 pendientes del trip (no solo la del
  /// overlay actual). Le dice al backend "el chofer atendio todo, parar la
  /// cascada entera". Se ejecuta DESPUES de cerrar el overlay para no
  /// hacer esperar al chofer.
  ///
  /// IMPORTANTE: este metodo se llama ANTES del pop, asi capturamos los
  /// refs ahora y los usamos en el future. Despues del pop el widget esta
  /// disposed y `ref.read` tira "Cannot use ref after disposed". Por eso
  /// el caller hace `_ackTodosLosPending()` antes de `navigator.pop()`.
  Future<bool> _ackTodosLosPending() async {
    // Capturar todos los refs SINCRONO antes de cualquier await.
    final repo = ref.read(alertasRepoProvider);
    final chatNotifier =
        ref.read(chatNotifierProvider(widget.tripId).notifier);
    final pendingNotifier =
        ref.read(pendingActionNotifierProvider(widget.tripId).notifier);
    try {
      // Traer la lista completa de pending para ack-earlos juntos.
      final pend = await repo.pendingAction(widget.tripId);
      final ids = <int>{...pend.items.map((a) => a.id)};
      // Garantizar que el alertId del overlay este incluido (por si recien
      // se posteo y todavia no aparece en la lista).
      if (widget.alertId != null) ids.add(widget.alertId!);
      if (ids.isEmpty) return true;
      await repo.acknowledge(ids.toList());
      // Apuntar localmente los IDs ackeados — el ChatNotifier los usa para
      // ignorar mensajes que lleguen tarde con el mismo alert_id (race).
      // Usamos las refs capturadas, no `ref.read`, porque el widget puede
      // estar disposed en este punto (el caller hizo pop antes).
      chatNotifier.marcarAlertasAcked(ids);
      // Refrescar el banner persistente.
      pendingNotifier.refrescar(widget.tripId);
      return true;
    } catch (e) {
      debugPrint('[FakeCall] ack fallo: $e');
      return false;
    }
  }

  /// Cierre optimista del overlay: corta ringtone+vibracion al instante y
  /// dispara el ACK en background. Si el ACK falla, mostramos snackbar y
  /// volvemos a abrir el fake-call (lo crea de nuevo el ChatNotifier en el
  /// proximo poll si la cascada sigue).
  Future<void> _onEstoyBien() async {
    if (_enviando) return;
    setState(() => _enviando = true);
    // 1) OPTIMISTIC: detener ringtone y vibracion AL TOQUE — sin esperar
    //    el round-trip. El ticket MC-002 lo pide explicitamente: <100ms
    //    percibido entre tap y silencio.
    _detenerSenales();
    final navigator = GoRouter.of(context);
    final tripId = widget.tripId;
    // 2) Arrancar el ACK ANTES del pop. `_ackTodosLosPending` captura
    //    los refs (sync) con el widget aun montado — asi el future
    //    sigue OK incluso si el navigator nos desmonta a continuacion.
    final ackFuture = _ackTodosLosPending();
    // 3) Cerrar la pantalla. Si entramos por push (foreground) popeamos.
    //    Si entramos cold-start desde notif (deep-link a /llamada como
    //    primera pantalla), no hay nada para popear → `go` al viaje.
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.go('/viaje/$tripId');
    }
    // 4) Esperar el resultado. Si OK, el chat ya marca la alerta como
    //    Resuelta (ChatNotifier.marcarAlertasAcked) y la pantalla queda
    //    cerrada. Si FALLA, REABRIR el fake-call con un banner rojo y
    //    botones renombrados a "Reintentar". Critico: nunca dejar al
    //    chofer creyendo que ack-eo cuando no — el monitor podria estar
    //    viendo "cascada activa, chofer no respondio" mientras el chofer
    //    asume que ya atendio.
    final ok = await ackFuture;
    if (ok) return;
    // Re-abrir con el mismo regla/contenido pero con errorMessage:
    // como el route /viaje/:tripId/fake-call usa `extra`, lo aprovechamos
    // para mantener el alertId int (el route /llamada usa query params,
    // donde alertId quedaria como string).
    navigator.push(
      '/viaje/$tripId/fake-call',
      extra: <String, dynamic>{
        'alertId': widget.alertId,
        'regla': widget.regla,
        'contenido': widget.contenido,
        'errorMessage':
            'No pudimos confirmar al monitoreo. Tocá Reintentar.',
      },
    );
  }

  /// Detiene ringtone y vibracion sin tocar el resto del state. Idempotente.
  void _detenerSenales() {
    _vibrateTimer?.cancel();
    _vibrateTimer = null;
    Vibration.cancel();
    _player.stop();
  }

  /// "Necesito ayuda" tiene que ser **infalible**: garantiza que el
  /// monitoreo se entera aunque cualquier paso individual falle.
  ///
  /// Orden de operaciones (todos paralelos despues del cierre del overlay):
  ///   1. Cierre optimista + corte de ruido (ringtone/vibracion).
  ///   2. POST al chat con un mensaje de panico identificable. Es el
  ///      canal mas barato (no requiere foto) y el supervisor lo ve YA.
  ///   3. POST /trips/{id}/alerts intentando crear EMERGENCIA estructurada.
  ///      Si falla por foto u otro motivo, no bloquea — el mensaje del
  ///      chat ya cubrio el aviso.
  ///   4. ACK de todos los pending para que la cascada original pare.
  ///   5. SnackBar al chofer: "Aviso enviado al monitoreo".
  Future<void> _onNecesitoAyuda() async {
    if (_enviando) return;
    setState(() => _enviando = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = GoRouter.of(context);

    // Capturar TODOS los refs ANTES del pop (despues el widget se disposea
    // y `ref.read` tira excepcion). Tambien el chatNotifier que usamos
    // mas abajo para refrescar el chat.
    final perfil = ref.read(authNotifierProvider).perfil;
    final driverName = perfil?.person.nombreCompleto;
    final chatRepo = ref.read(chatRepoProvider);
    final alertasRepo = ref.read(alertasRepoProvider);
    final gps = ref.read(gpsServiceProvider);
    final chatNotifier =
        ref.read(chatNotifierProvider(widget.tripId).notifier);

    // 1) Arrancar el ack en paralelo (captura sus refs antes del pop).
    final ackFuture = _ackTodosLosPending();

    // 2) Cerrar overlay y cortar ruido. Igual que en _onEstoyBien: si no
    //    podemos popear (deep-link cold-start), `go` al viaje activo.
    _detenerSenales();
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.go('/viaje/${widget.tripId}');
    }

    bool chatOk = false;
    bool emergenciaOk = false;

    // 3) Mensaje al chat — canal garantizado, no requiere foto.
    final textoChat = '🚨 EMERGENCIA — el chofer respondió '
        '"Necesito ayuda" en la llamada por: ${widget.regla}. '
        '${widget.contenido.trim().isNotEmpty ? widget.contenido : ''}';
    try {
      await chatRepo.enviar(
        tripId: widget.tripId,
        content: textoChat,
        senderName: driverName == null || driverName.isEmpty
            ? 'Chofer (emergencia)'
            : driverName,
      );
      chatOk = true;
      // Refrescar el chat para que el chofer vea su propio mensaje.
      // Usamos el notifier capturado, no `ref.read` (widget disposed).
      chatNotifier.refrescar(widget.tripId);
    } catch (e) {
      debugPrint('[FakeCall] mensaje chat de emergencia fallo: $e');
    }

    // 4) Intentar crear alerta EMERGENCIA estructurada (best-effort).
    try {
      final pos = await gps.ubicacionActual();
      final lat = pos?.latitude ?? 0.0;
      final lon = pos?.longitude ?? 0.0;
      await alertasRepo.enviar(
        tripId: widget.tripId,
        payload: AlertaPayload(
          alertType: 'EMERGENCIA',
          lat: lat,
          lon: lon,
          message: 'EMERGENCIA — fake-call por ${widget.regla}',
          evidences: const <CheckpointEvidence>[],
        ),
      );
      emergenciaOk = true;
    } catch (e) {
      // Si la API rechaza por falta de foto u otro motivo, no bloquear:
      // el mensaje al chat ya cubrió el aviso al supervisor.
      debugPrint('[FakeCall] crear EMERGENCIA estructurada fallo: $e');
    }

    // 5) Esperar el ack original (ya estaba corriendo en paralelo).
    await ackFuture;

    // 6) Sacar el spinner si por algun motivo seguimos montados (caso
    //    deep-link cold-start si el `go` no logra desmontar). En el flujo
    //    normal `mounted == false` y este setState es noop.
    if (mounted) {
      setState(() => _enviando = false);
    }

    // 7) Feedback al chofer.
    if (chatOk || emergenciaOk) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Pedido de ayuda enviado al monitoreo. Te van a contactar en breve.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo contactar al monitoreo. Revisá tu conexión y volvé a intentar.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto-close: si el backend auto-ack-ea (porque el chofer mando un
    // mensaje al chat o creo otra alerta) y `total` baja a 0, cerramos
    // el fake-call sin esperar al chofer. Esto cubre el escenario del
    // criterio MC-002 #7: "Si el chofer postea un mensaje mientras la
    // fake-call esta abierta, en el siguiente poll de pending-action
    // la fake-call se cierra sola".
    ref.listen(pendingActionNotifierProvider(widget.tripId), (prev, next) {
      if (!mounted || _enviando) return;
      // Solo disparar en transition de "habia pendientes" → "ya no hay".
      // Si arrancamos con total==0 (caso raro: route abierto manualmente),
      // no disparamos porque no es un evento.
      final habia = (prev?.total ?? 0) > 0;
      final yaNoHay = !next.loading && next.total == 0;
      if (!habia || !yaNoHay) return;
      _detenerSenales();
      // Cerramos pop o go (mismo razonamiento que en _onEstoyBien).
      final navigator = GoRouter.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        navigator.go('/viaje/${widget.tripId}');
      }
    });

    final hayError = (widget.errorMessage ?? '').isNotEmpty;
    final labelOk = hayError ? 'Reintentar' : 'Estoy bien';

    // Buscamos en el state de pending-action la alerta que disparo este
    // FakeCall (matchea por alertId). Si la encontramos, usamos su
    // alertType y escalationLevel para que el header tenga icon+color
    // del tipo (en lugar del generico phone-in-talk). Si no, fallback
    // al rojo + phone-in-talk como antes.
    final pendingState =
        ref.watch(pendingActionNotifierProvider(widget.tripId));
    TrackingAlert? alertaDelCall;
    if (widget.alertId != null) {
      for (final a in pendingState.items) {
        if (a.id == widget.alertId) {
          alertaDelCall = a;
          break;
        }
      }
    }
    final tipoStyle = alertaDelCall != null
        ? alertTypeStyle(alertaDelCall.alertType)
        : null;
    final nivelStyle = alertaDelCall != null
        ? escalationStyle(alertaDelCall.escalationLevel)
        : null;
    // Si no tenemos info del tipo, mantener el look rojo de "llamada"
    // generica (heredado). Si la tenemos, tinte por color del tipo.
    final headerColor = tipoStyle?.color ?? Colors.red.shade700;
    final headerIcon = tipoStyle?.icon ?? Icons.phone_in_talk;
    final headerLabelTipo = tipoStyle?.label;

    return PopScope(
      canPop: false, // bloquear back
      child: Scaffold(
        backgroundColor: const Color(0xFF111827),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text(
                  'LLAMADA DEL SISTEMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hayError) ...[
                  const SizedBox(height: 12),
                  _BannerError(message: widget.errorMessage!),
                ],
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: headerColor,
                      boxShadow: [
                        BoxShadow(
                          color: headerColor.withValues(alpha: 0.7),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      headerIcon,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sistema de monitoreo IsaTech',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Linea con tipo de alerta + badge L1/L2/L3 cuando los
                // tenemos del state de pending-action. Reemplaza el
                // generico "regla" plano de antes (que siempre venia
                // del payload de la notif y podia no estar tipado).
                if (headerLabelTipo != null || nivelStyle != null) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (headerLabelTipo != null)
                        Text(
                          headerLabelTipo.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      if (nivelStyle != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            nivelStyle.label,
                            style: TextStyle(
                              color: nivelStyle.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                if (widget.regla.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.regla,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade200,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.contenido.isEmpty
                        ? 'El sistema está intentando contactarte. '
                            'Confirmá que estás bien o si necesitás ayuda.'
                        : widget.contenido,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: _BotonGrande(
                        color: Colors.green.shade700,
                        icon: Icons.check_circle,
                        label: labelOk,
                        loading: _enviando,
                        onTap: _onEstoyBien,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BotonGrande(
                        color: Colors.red.shade700,
                        icon: Icons.warning,
                        label: 'Necesito ayuda',
                        loading: _enviando,
                        onTap: _onNecesitoAyuda,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'No podés cerrar esta pantalla hasta responder.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Banner rojo arriba del fake-call que aparece cuando un ack optimista
/// fallo y el chofer tiene que reintentar. Se renderea con el mismo
/// theme oscuro de la pantalla pero con borde rojo + icono de warning.
class _BannerError extends StatelessWidget {
  const _BannerError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade400, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonGrande extends StatelessWidget {
  const _BotonGrande({
    required this.color,
    required this.icon,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String label;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: loading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              else
                Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
