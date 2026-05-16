import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Payload que emite [NotificacionesAlertas.tapStream] cuando el chofer toca
/// una notificacion. La UI principal lo usa para hacer deep-link al lugar
/// correcto: chat normal, fake-call, etc.
class NotifTapPayload {
  const NotifTapPayload({
    required this.kind,
    required this.tripId,
    this.alertId,
    this.regla,
    this.contenido,
  });

  /// "chat" | "alerta" | "llamada" | "trip-ready" | "operator-directive"
  final String kind;
  final String tripId;
  final int? alertId;
  final String? regla;
  final String? contenido;

  bool get esLlamada => kind == 'llamada';
  bool get esChat => kind == 'chat';
  bool get esAlerta => kind == 'alerta';

  /// `[VIAJE LISTO]` — el chofer toca la notif para ver el viaje
  /// recien desbloqueado. Deep-link directo al detalle del trip.
  bool get esViajeListo => kind == 'trip-ready';

  /// `[OPERADOR · X]` — directiva del operador. Tap → detalle del
  /// viaje. El overlay ya se encarga del banner; la nav solo trae al
  /// chofer al lugar donde se va a aplicar la directiva.
  bool get esDirectivaOperador => kind == 'operator-directive';
}

/// Wrapper para disparar notificaciones del SO. Maneja dos canales:
///   - `isatech_chat`: importancia DEFAULT, para mensajes normales del
///     monitoreo. Suena como un mensaje cualquiera (WhatsApp-style).
///   - `isatech_alertas_criticas`: importancia HIGH/MAX, vibracion y
///     sonido fuerte, para alertas L2/L3 y `[LLAMADA · ...]`.
class NotificacionesAlertas {
  NotificacionesAlertas._();
  static final NotificacionesAlertas instance = NotificacionesAlertas._();

  final _plugin = FlutterLocalNotificationsPlugin();
  final _tapController = StreamController<NotifTapPayload>.broadcast();
  bool _inicializado = false;
  static const _canalAlertas = 'isatech_alertas_criticas';
  static const _canalChat = 'isatech_chat';
  /// Canal silencioso para mensajes informativos puros que NO deben
  /// sonar ni vibrar (ej. `[VIAJE EN COLA]`). En Android la importance
  /// del canal es la fuente de verdad — un override en runtime no
  /// alcanza si el canal ya esta creado con sonido.
  static const _canalChatSilencioso = 'isatech_chat_silencioso';

  /// Emite cada vez que el chofer toca una notificacion. La UI principal
  /// escucha y hace deep-link segun el `kind`.
  Stream<NotifTapPayload> get tapStream => _tapController.stream;

  Future<void> inicializar() async {
    if (_inicializado) return;
    _inicializado = true;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // Canal alertas criticas (L2/L3, llamadas).
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _canalAlertas,
        'Alertas críticas IsaTech',
        description: 'Alertas que requieren acción inmediata del chofer.',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      ),
    );
    // Canal chat normal (mensajes del monitor sin urgencia).
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _canalChat,
        'Mensajes del monitoreo',
        description: 'Mensajes normales del centro de monitoreo durante el viaje.',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    );
    // Canal silencioso para mensajes de sistema sin urgencia
    // (ej. `[VIAJE EN COLA]` — informativo, el chofer lo ve cuando
    // abra el chat). Sin sonido ni vibracion.
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _canalChatSilencioso,
        'Avisos silenciosos del sistema',
        description: 'Mensajes informativos sin sonido ni vibracion.',
        importance: Importance.low,
        enableVibration: false,
        playSound: false,
      ),
    );
    // App abierta tocando una notif desde el SO (cuando estaba matada).
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _onTap(launch!.notificationResponse);
    }
  }

  /// Notificacion de mensaje normal del monitor (no es alerta de cascada).
  /// Por default suena/vibra suave y el tap abre el chat del viaje.
  ///
  /// [silencioso]: si true, usa el canal silencioso (sin sonido ni
  /// vibracion). Apto para mensajes informativos puros como
  /// `[VIAJE EN COLA]` (MC-017).
  ///
  /// [kind]: payload del tap. `chat` (default) abre el chat. `trip-ready`
  /// (MC-017) y `operator-directive` (MC-018) llevan al detalle del
  /// viaje, no al chat — el chofer en general quiere ver el viaje, no
  /// scrollear conversacion.
  Future<void> dispararChat({
    required int id,
    required String titulo,
    required String cuerpo,
    required String tripId,
    bool silencioso = false,
    String kind = 'chat',
  }) async {
    if (!_inicializado) await inicializar();
    final payload = jsonEncode({'kind': kind, 'tripId': tripId});
    await _plugin.show(
      id,
      titulo,
      cuerpo,
      NotificationDetails(
        android: AndroidNotificationDetails(
          silencioso ? _canalChatSilencioso : _canalChat,
          silencioso ? 'Avisos silenciosos del sistema' : 'Mensajes del monitoreo',
          importance: silencioso ? Importance.low : Importance.high,
          priority: silencioso ? Priority.low : Priority.high,
          category: AndroidNotificationCategory.message,
          enableVibration: !silencioso,
          playSound: !silencioso,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: !silencioso,
          presentBadge: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Notificacion de alerta de cascada (L2/L3) o llamada urgente. Tap:
  ///   - kind="alerta" → abre el chat (normal).
  ///   - kind="llamada" → abre la pantalla fake-call (full-screen con
  ///     botones Estoy bien / Necesito ayuda).
  Future<void> dispararAlerta({
    required int id,
    required String titulo,
    required String cuerpo,
    required String tripId,
    required bool urgente,
    bool esLlamada = false,
    int? alertId,
    String? regla,
    String? contenido,
  }) async {
    if (!_inicializado) await inicializar();
    final payload = jsonEncode({
      'kind': esLlamada ? 'llamada' : 'alerta',
      'tripId': tripId,
      if (alertId != null) 'alertId': alertId,
      if (regla != null) 'regla': regla,
      if (contenido != null) 'contenido': contenido,
    });
    await _plugin.show(
      id,
      titulo,
      cuerpo,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _canalAlertas,
          'Alertas críticas IsaTech',
          importance: urgente ? Importance.max : Importance.high,
          priority: urgente ? Priority.max : Priority.high,
          category: AndroidNotificationCategory.call,
          fullScreenIntent: esLlamada || urgente,
          ongoing: false,
          enableVibration: true,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      payload: payload,
    );
  }

  void _onTap(NotificationResponse? r) {
    final raw = r?.payload;
    if (raw == null || raw.isEmpty) return;
    try {
      final data = jsonDecode(raw);
      if (data is! Map) return;
      final tripId = data['tripId'];
      if (tripId is! String) return;
      _tapController.add(
        NotifTapPayload(
          kind: data['kind']?.toString() ?? 'chat',
          tripId: tripId,
          alertId: data['alertId'] is int ? data['alertId'] as int : null,
          regla: data['regla']?.toString(),
          contenido: data['contenido']?.toString(),
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('NotificacionesAlertas: payload invalido $e');
    }
  }
}
