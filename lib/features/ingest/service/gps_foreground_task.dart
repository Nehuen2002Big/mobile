import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../alertas/data/prefijos_alerta.dart';

/// Punto de entrada del isolate del foreground service. Esta funcion se
/// ejecuta en otro isolate que NO comparte estado con la UI: necesita
/// resolver token, tripId y baseUrls por su cuenta.
@pragma('vm:entry-point')
void gpsForegroundCallback() {
  FlutterForegroundTask.setTaskHandler(GpsForegroundTaskHandler());
}

/// Keys de FlutterSecureStorage compartidas con TokenStorage del main isolate.
const _kAccess = 'isatech_access_token';
const _kRefresh = 'isatech_refresh_token';

/// Keys que el main isolate guarda via FlutterForegroundTask.saveData para
/// que el TaskHandler las lea al arrancar.
const fgKeyTripId = 'fg_trip_id';
const fgKeyTrackingBase = 'fg_tracking_base';
const fgKeyIamBase = 'fg_iam_base';
const fgKeyLastMsgId = 'fg_last_msg_id';

/// Flag que el main isolate setea/borra al cambiar el lifecycle de la
/// app (resumed/paused). Cuando es `true`, el bg isolate suprime las
/// notif del SO que dispararia para alertas L2/L3 y mensajes del
/// MONITOR — porque el banner persistente y el fake-call del foreground
/// ya cubren ese caso. Cuando es `false` o ausente, dispatch normal.
const fgKeyAppForeground = 'fg_app_foreground';

/// JSON list de alertIds (L2/L3) ya notificados al chofer via la barra
/// del SO desde el polling de `/alerts/pending-action`. Sirve para no
/// re-disparar la misma notif en cada tick. Una alerta que desaparece
/// de pending-action (porque fue ackeada) se purga automaticamente del
/// set — si vuelve a aparecer es una nueva instancia y se re-notifica.
const fgKeyNotifiedAlertIds = 'fg_notified_alert_ids';

/// JSON list de trip_ids ya conocidos por el chofer (MC-019). Cada vez
/// que el FG service hace `GET /trips`, diffea contra este set y
/// dispara una notif del SO por cada trip nuevo. Persistido para que
/// si el service se reinicia (kill + cold-start) no spamee notifs de
/// viajes que el chofer ya vio antes.
///
/// **TODO MC-010**: cuando se implemente push real con FCM/APNs, este
/// flow se vuelve obsoleto — el backend mandara push directamente sin
/// que el FG isolate tenga que pollear `/trips`. Borrar `_pollearTrips`
/// y este key cuando llegue MC-010.
const fgKeyKnownTripIds = 'fg_known_trip_ids';

/// Canal de notificaciones del SO usado tambien desde el background isolate.
/// Tiene que coincidir con los IDs que crea el main isolate en
/// `NotificacionesAlertas.inicializar()`.
const _kCanalChat = 'isatech_chat';
const _kCanalChatSilencioso = 'isatech_chat_silencioso';
const _kCanalAlertas = 'isatech_alertas_criticas';

/// Action IDs de los botones que aparecen en la notif de pending-action
/// (L2/L3). El handler `onBackgroundNotifAction` los rutea al ack
/// correspondiente.
const _kNotifActionAck = 'ack_pending';
const _kNotifActionOpen = 'open_trip';

/// Handler que se ejecuta cuando el chofer toca un boton de la notif
/// (`Estoy bien` / `Abrir`) **estando la app cerrada o en otro isolate**.
/// El SO despierta este isolate, parsea el payload de la notif y, si
/// la action es `ack_pending`, pega `POST /alerts/acknowledge` con los
/// IDs que se snapshotearon al disparar la notif.
///
/// Tiene que ser una funcion top-level + `@pragma('vm:entry-point')`
/// para que el AOT compiler la conserve y `flutter_local_notifications`
/// la pueda invocar desde el isolate background del SO.
@pragma('vm:entry-point')
void onBackgroundNotifAction(NotificationResponse response) async {
  final actionId = response.actionId;
  // Si tocaron la notif sin elegir action, o eligieron "Abrir app",
  // dejamos que el comportamiento default abra la app y el deep-link
  // del main isolate se ocupe (no hay nada que ackear desde aca).
  if (actionId != _kNotifActionAck) return;
  final raw = response.payload;
  if (raw == null || raw.isEmpty) return;
  Map<String, dynamic> payload;
  try {
    payload = jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return;
  }
  final ids = (payload['pendingIds'] as List?)
      ?.map((e) => (e as num).toInt())
      .toList();
  if (ids == null || ids.isEmpty) return;

  final storage = const FlutterSecureStorage();
  final token = await storage.read(key: _kAccess);
  if (token == null || token.isEmpty) return;

  final trackingBase =
      await FlutterForegroundTask.getData<String>(key: fgKeyTrackingBase);
  if (trackingBase == null || trackingBase.isEmpty) return;

  final dio = Dio(
    BaseOptions(
      baseUrl: trackingBase,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 12),
      headers: {'Accept': 'application/json'},
    ),
  );
  try {
    await dio.post<Map<String, dynamic>>(
      '/api/v1/alerts/acknowledge',
      data: {'alert_ids': ids},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    // Marcar los IDs ackeados como ya-notificados-pero-resueltos para
    // que el proximo tick del polling de pending-action no re-spawnee
    // la notif si todavia no se actualizo el set por la response.
    // (En la practica, /pending-action reflejara el ack a los <2s y
    // los IDs salen del set automaticamente — esto es defensivo.)
    final notifiedJson =
        await FlutterForegroundTask.getData<String>(key: fgKeyNotifiedAlertIds);
    final Set<int> notified = (notifiedJson != null && notifiedJson.isNotEmpty)
        ? (jsonDecode(notifiedJson) as List)
            .map((e) => (e as num).toInt())
            .toSet()
        : <int>{};
    notified.addAll(ids);
    await FlutterForegroundTask.saveData(
      key: fgKeyNotifiedAlertIds,
      value: jsonEncode(notified.toList()),
    );
    // ignore: avoid_print
    print('[FG-NOTIF-ACTION] ack OK ids=$ids');
  } catch (e) {
    // ignore: avoid_print
    print('[FG-NOTIF-ACTION] ack fallo: $e (ids=$ids)');
    // No reintentamos aqui — el polling siguiente vera que la alerta
    // sigue pendiente y volvera a notificar al chofer.
  }
}

/// Maneja el ciclo de vida del foreground service: se queda corriendo aunque
/// la app este minimizada o pantalla apagada, hace POST de phone-location
/// cada N segundos, y refresca el JWT cuando expira.
class GpsForegroundTaskHandler extends TaskHandler {
  String? _tripId;
  String? _trackingBase;
  String? _iamBase;
  Dio? _dio;
  final _storage = const FlutterSecureStorage();
  final _notif = FlutterLocalNotificationsPlugin();
  bool _notifInicializado = false;
  int? _lastMsgId;
  int _exitosos = 0;
  int _fallidos = 0;
  bool _refrescando = false;
  /// Cuando el backend devuelve 423 (QA pause), el ingest de phone-location
  /// esta pausado hasta este timestamp. Mientras `now < _pausedUntil`,
  /// `onRepeatEvent` saltea el POST de GPS (los polls de mensajes y
  /// pending-action siguen corriendo — esos endpoints no estan
  /// afectados por la pausa). Al expirar, reanuda automatico. Solo
  /// pasa con el simulador del operador; en produccion real este
  /// codigo nunca se ejecuta.
  DateTime? _pausedUntil;
  /// Counter para throttle del polling de `/trips` (MC-019). Se hace
  /// cada 2 ticks (~30 s, el tick base es ~15 s) para no saturar el
  /// endpoint con un request relativamente caro. La detección de
  /// alertas (cada tick) es la que tiene tiempo de respuesta critico.
  int _tripsTickCounter = 0;
  /// Cache en memoria de los trip_ids conocidos. Se hidrata desde
  /// `fgKeyKnownTripIds` en el primer poll y se persiste despues de
  /// cada tick exitoso. `null` significa "nunca seedeado todavía" —
  /// el primer poll va a hacer el seed sin notificar.
  Set<String>? _knownTripIds;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _tripId = await FlutterForegroundTask.getData<String>(key: fgKeyTripId);
    _trackingBase =
        await FlutterForegroundTask.getData<String>(key: fgKeyTrackingBase);
    _iamBase = await FlutterForegroundTask.getData<String>(key: fgKeyIamBase);
    _lastMsgId =
        await FlutterForegroundTask.getData<int>(key: fgKeyLastMsgId);
    // Hidratar el cache de trip_ids conocidos (MC-019). Si esta vacio
    // o no existe, queda null y el primer poll hace seed sin notificar.
    final knownTripsJson =
        await FlutterForegroundTask.getData<String>(key: fgKeyKnownTripIds);
    if (knownTripsJson != null && knownTripsJson.isNotEmpty) {
      try {
        _knownTripIds = (jsonDecode(knownTripsJson) as List)
            .map((e) => e.toString())
            .toSet();
      } catch (_) {
        _knownTripIds = null;
      }
    }
    _dio = Dio(
      BaseOptions(
        baseUrl: _trackingBase ?? '',
        connectTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );
    await _inicializarNotifs();
    // Si _lastMsgId no esta seedeado (primer arranque del service en este
    // trip), buscar el id maximo actual SIN disparar notifs para todos los
    // mensajes ya existentes. Si la red esta caida, el seed falla y queda
    // null — _pollearMensajes tiene un fallback que tampoco spammea en ese
    // caso.
    final tripId = _tripId;
    final dio = _dio;
    if (_lastMsgId == null && tripId != null && dio != null) {
      await _seedLastMsgId(dio, tripId);
    }
    print('[FG-GPS] onStart trip=$_tripId base=$_trackingBase '
        'lastMsgId=$_lastMsgId');
  }

  /// Busca el id maximo del chat del viaje y lo persiste como baseline
  /// para que el polling solo notifique mensajes que llegan DESPUES de
  /// arrancar el service. Pagina hasta drenar la cola.
  Future<void> _seedLastMsgId(Dio dio, String tripId) async {
    final token = await _storage.read(key: _kAccess);
    if (token == null || token.isEmpty) return;
    int afterId = 0;
    int maxId = 0;
    try {
      // Loop bounded: a lo sumo total/200 paginas. Para evitar runaway en
      // un trip con un chat absurdamente largo, cortar a 20 paginas
      // (4000 mensajes) — mas que suficiente para cualquier viaje real.
      for (var pagina = 0; pagina < 20; pagina++) {
        final res = await dio.get<Map<String, dynamic>>(
          '/api/v1/trips/$tripId/messages',
          queryParameters: {'after_id': afterId, 'limit': 200},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        final items = (res.data?['items'] as List?) ?? const [];
        if (items.isEmpty) break;
        for (final raw in items) {
          if (raw is! Map) continue;
          final id = (raw['id'] as num?)?.toInt() ?? 0;
          if (id > maxId) maxId = id;
        }
        if (items.length < 200) break;
        afterId = maxId;
      }
      _lastMsgId = maxId;
      await FlutterForegroundTask.saveData(
        key: fgKeyLastMsgId,
        value: maxId,
      );
      print('[FG-GPS] seed lastMsgId=$maxId');
    } catch (e) {
      print('[FG-GPS] seed lastMsgId fallo: $e');
      // _lastMsgId queda null; _pollearMensajes detectara y no spammeara.
    }
  }

  /// Inicializa el plugin de notif en el isolate background. El callback
  /// de tap simple (sin action) sigue manejandose por el main isolate al
  /// despertar via `getNotificationAppLaunchDetails`. Lo nuevo aca es el
  /// `onDidReceiveBackgroundNotificationResponse` que recibe los taps en
  /// los **action buttons** ("Estoy bien" / "Abrir app") de la notif de
  /// pending-action — ese callback corre en otro isolate aunque la app
  /// este cerrada, y pega el ack al backend sin abrir la UI.
  /// Tambien crea los canales en este isolate como defensa: si el sistema
  /// los borro o el main isolate todavia no los creo, los recreamos. Es
  /// idempotente — Android ignora canales ya creados con mismo id.
  Future<void> _inicializarNotifs() async {
    if (_notifInicializado) return;
    try {
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _notif.initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse: onBackgroundNotifAction,
        onDidReceiveNotificationResponse: onBackgroundNotifAction,
      );
      final androidPlugin = _notif.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      // Canal alertas criticas (L2/L3, llamadas) — debe matchear los IDs
      // que crea NotificacionesAlertas.inicializar() en el main isolate.
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _kCanalAlertas,
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
          _kCanalChat,
          'Mensajes del monitoreo',
          description:
              'Mensajes normales del centro de monitoreo durante el viaje.',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      );
      // Canal silencioso para informativos puros que no deben sonar
      // (ej. `[VIAJE EN COLA]` de MC-017). Mismo id que el main isolate
      // — Android es idempotente con canales ya creados.
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _kCanalChatSilencioso,
          'Avisos silenciosos del sistema',
          description: 'Mensajes informativos sin sonido ni vibracion.',
          importance: Importance.low,
          enableVibration: false,
          playSound: false,
        ),
      );
      _notifInicializado = true;
      print('[FG-GPS] notifs inicializadas (canales chat+silencioso+alertas)');
    } catch (e) {
      print('[FG-GPS] notif init fallo: $e');
    }
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    final tripId = _tripId;
    final dio = _dio;
    if (tripId == null || dio == null) {
      print('[FG-GPS] onRepeatEvent SKIP — trip=$tripId dio=${dio != null}');
      return;
    }
    print('[FG-GPS] tick @${timestamp.toIso8601String()} '
        'exitos=$_exitosos fallos=$_fallidos');
    // Si el simulador del operador puso el ingest en pausa (QA),
    // saltamos el POST de GPS hasta que expire — los polls de mensajes
    // y pending-action de abajo igual corren porque esos endpoints no
    // estan afectados por la pausa. Sin esto recibimos 423 en cada
    // tick durante toda la ventana de pausa (15-30s), generando ruido.
    final paused = _pausedUntil;
    final ahora = DateTime.now();
    final enPausa = paused != null && ahora.isBefore(paused);
    if (enPausa) {
      print('[FG-GPS] phone-ingest pausado por QA hasta '
          '${paused.toIso8601String()} — skip POST GPS');
    } else {
      // Limpiar el flag si ya expiro, asi no comparamos en cada tick.
      if (paused != null && !ahora.isBefore(paused)) {
        _pausedUntil = null;
      }
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
            timeLimit: Duration(seconds: 12),
          ),
        ).timeout(const Duration(seconds: 14));
        final ok = await _enviarPunto(dio, tripId, pos);
        if (ok) {
          _exitosos++;
          _actualizarNotificacion(timestamp, exito: true);
        } else {
          _fallidos++;
          _actualizarNotificacion(timestamp, exito: false);
        }
      } catch (e) {
        _fallidos++;
        print('[FG-GPS] tick error: $e');
        _actualizarNotificacion(timestamp, exito: false);
      }
    }
    // Despues del GPS:
    //   - /messages → notif por mensajes nuevos del MONITOR (LLAMADA,
    //     AVISO L1, supervisor informado). NO dispara notif para
    //     [ACCION REQUERIDA · ...] / [ESCALADO A SUPERVISOR · ...] —
    //     esos los cubre el polling de pending-action de abajo, que
    //     tiene los alertIds estructurales para el ack desde el boton.
    //   - /alerts/pending-action → notif por alertas L2/L3 vigentes
    //     que requieren ack del chofer. Mantiene un set persistido de
    //     IDs ya notificados para no spammear cada 15s.
    unawaited(_pollearMensajes(dio, tripId));
    unawaited(_pollearPendingAction(dio, tripId));
    // MC-019: poll de `/trips` cada 2 ticks (~30 s) para detectar
    // viajes recien asignados al chofer y notificar al SO.
    _tripsTickCounter++;
    if (_tripsTickCounter % 2 == 0) {
      unawaited(_pollearTrips(dio));
    }
  }

  Future<bool> _enviarPunto(
    Dio dio,
    String tripId,
    Position pos,
  ) async {
    final token = await _storage.read(key: _kAccess);
    if (token == null || token.isEmpty) return false;
    try {
      await dio.post<Map<String, dynamic>>(
        '/api/v1/trips/$tripId/phone-location',
        data: {
          'lat': pos.latitude,
          'lon': pos.longitude,
          'speed_kmh': (pos.speed * 3.6).clamp(0, 400),
          'recorded_at':
              (pos.timestamp).toUtc().toIso8601String(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token expirado: intentar refresh y reintentar una vez.
        final ok = await _refrescarToken();
        if (!ok) return false;
        final nuevoToken = await _storage.read(key: _kAccess);
        if (nuevoToken == null) return false;
        try {
          await dio.post<Map<String, dynamic>>(
            '/api/v1/trips/$tripId/phone-location',
            data: {
              'lat': pos.latitude,
              'lon': pos.longitude,
              'speed_kmh': (pos.speed * 3.6).clamp(0, 400),
              'recorded_at': pos.timestamp.toUtc().toIso8601String(),
            },
            options: Options(
              headers: {'Authorization': 'Bearer $nuevoToken'},
            ),
          );
          return true;
        } catch (e2) {
          debugPrint('[FG-GPS] retry post-refresh fallo: $e2');
          return false;
        }
      }
      // 409 trip ya FINISHED/CANCELLED → detener el service. No tiene
      // sentido seguir mandando GPS de un viaje cerrado, ademas spamea
      // logs del backend. Avisar al main isolate para que sincronice
      // la UI (toast + volver al listado de viajes).
      if (e.response?.statusCode == 409) {
        print('[FG-GPS] backend 409 (trip terminado), deteniendo servicio + '
            'avisando al main isolate');
        // Notificar al main isolate ANTES de stopService — una vez
        // detenido, el isolate puede morir y la data no sale. Se
        // recibe en gps_service via FlutterForegroundTask.streamData.
        try {
          FlutterForegroundTask.sendDataToMain({
            'event': 'trip_ended_remotely',
            'tripId': tripId,
          });
        } catch (e2) {
          // Si el envio falla (el main isolate puede no estar
          // escuchando todavia), igual el GpsService va a detectar el
          // service caido cuando el chofer vuelva a la pantalla del
          // viaje. Best effort.
          print('[FG-GPS] sendDataToMain fallo: $e2');
        }
        // No await porque podria deadlockear el isolate.
        FlutterForegroundTask.stopService();
        return false;
      }
      // 423 Locked — el simulador del operador pauso temporalmente el
      // ingest de pings PHONE para que sus puntos simulados no se
      // sobrescriban. Drop SILENCIOSO: NO mostramos error al chofer y
      // NO hacemos backoff agresivo. El proximo tick normal va a
      // encontrar la pausa expirada y va a reanudar el envio. Solo
      // pasa durante QA — en prod real este branch nunca corre.
      //
      // Si el response trae `seconds_remaining` en el body o
      // `Retry-After` en headers, lo guardamos en `_pausedUntil` para
      // que `onRepeatEvent` saltee los proximos N segundos en vez de
      // intentar (y volver a recibir 423) cada 15s.
      if (e.response?.statusCode == 423) {
        Duration? espera;
        try {
          final data = e.response?.data;
          final detail = (data is Map) ? data['detail'] : null;
          if (detail is Map) {
            final secs = (detail['seconds_remaining'] as num?)?.toInt();
            if (secs != null && secs > 0) {
              espera = Duration(seconds: secs);
            }
          }
        } catch (_) {}
        if (espera == null) {
          final retryAfter = e.response?.headers.value('retry-after');
          final secs = int.tryParse(retryAfter ?? '');
          if (secs != null && secs > 0) {
            espera = Duration(seconds: secs);
          }
        }
        if (espera != null) {
          _pausedUntil = DateTime.now().add(espera);
          print('[FG-GPS] phone-ingest QA pause — silenciando '
              '${espera.inSeconds}s');
        } else {
          print('[FG-GPS] phone-ingest QA pause — silenciando (sin retry-after)');
        }
        return false;
      }
      // 422 implausible / 4xx generico — solo loguear.
      debugPrint('[FG-GPS] POST status=${e.response?.statusCode}');
      return false;
    }
  }

  /// Polling de mensajes nuevos del MONITOR. Se ejecuta despues del POST GPS.
  /// Cuando la app esta minimizada o cerrada, este isolate sigue vivo y es la
  /// unica fuente de notificaciones del SO. En foreground, [ChatNotifier]
  /// tambien dispara notif con los mismos IDs — Android usa onlyAlertOnce
  /// para no re-alertar duplicado.
  Future<void> _pollearMensajes(Dio dio, String tripId) async {
    final token = await _storage.read(key: _kAccess);
    if (token == null || token.isEmpty) {
      print('[FG-GPS] poll msgs SKIP — no token');
      return;
    }
    // Si _lastMsgId esta null aca es porque el seed en onStart fallo (red
    // caida al arrancar). En ese caso usamos este poll como recovery seed:
    // grabamos la baseline pero NO dispatcheamos notifs (asi no spammeamos
    // mensajes ya leidos antes de que el service arrancara).
    final esRecoverySeed = _lastMsgId == null;
    final lastId = _lastMsgId ?? 0;
    Response<Map<String, dynamic>>? res;
    try {
      res = await dio.get<Map<String, dynamic>>(
        '/api/v1/trips/$tripId/messages',
        queryParameters: {
          'after_id': lastId,
          'limit': 50,
          '_t': DateTime.now().millisecondsSinceEpoch,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token expirado: refrescar y reintentar una vez.
        final ok = await _refrescarToken();
        if (!ok) return;
        final nuevo = await _storage.read(key: _kAccess);
        if (nuevo == null || nuevo.isEmpty) return;
        try {
          res = await dio.get<Map<String, dynamic>>(
            '/api/v1/trips/$tripId/messages',
            queryParameters: {
              'after_id': lastId,
              'limit': 50,
              '_t': DateTime.now().millisecondsSinceEpoch,
            },
            options: Options(headers: {'Authorization': 'Bearer $nuevo'}),
          );
        } catch (e2) {
          print('[FG-GPS] poll msgs retry fallo: $e2');
          return;
        }
      } else {
        // 502/timeout/etc — solo loguear, el proximo tick reintenta.
        print('[FG-GPS] poll msgs status=${e.response?.statusCode}');
        return;
      }
    } catch (e) {
      print('[FG-GPS] poll msgs error: $e');
      return;
    }
    final body = res.data;
    if (body == null) return;
    final items = (body['items'] as List?) ?? const [];
    print('[FG-GPS] poll msgs OK after_id=$lastId items=${items.length} '
        'recovery=$esRecoverySeed');
    if (items.isEmpty) {
      // Recovery seed sin mensajes: grabar baseline 0 para que el proximo
      // tick deje de estar en modo recovery y dispatch normal.
      if (esRecoverySeed) {
        _lastMsgId = 0;
        await FlutterForegroundTask.saveData(key: fgKeyLastMsgId, value: 0);
      }
      return;
    }
    int maxId = lastId;
    int dispatched = 0;
    int skipped = 0;
    for (final raw in items) {
      if (raw is! Map) continue;
      final id = (raw['id'] as num?)?.toInt();
      if (id == null) continue;
      if (id > maxId) maxId = id;
      // En modo recovery seed, solo grabamos baseline — no dispatch.
      if (esRecoverySeed) continue;
      final senderRole = (raw['sender_role'] ?? '').toString().toUpperCase();
      if (senderRole != 'MONITOR') continue;
      final content = (raw['content'] ?? '').toString();
      final senderName = (raw['sender_name'] ?? '').toString();
      final alertId = (raw['alert_id'] as num?)?.toInt();
      final parsed = parsearPrefijoCascada(content);
      // L2/L3 los cubre el polling de pending-action (con action
      // buttons "Estoy bien" para ackear desde la notif). Si tambien
      // disparamos desde messages, el chofer ve dos notif para el
      // mismo evento. Las llamadas si las dejamos pasar por aca
      // (necesitan fullScreenIntent del FakeCall) y los AVISO L1 +
      // supervisor informado tambien (no estan en pending-action).
      if (parsed?.tipo == TipoCascada.accionRequerida ||
          parsed?.tipo == TipoCascada.escaladoSupervisor) {
        skipped++;
        continue;
      }
      // MC-019: `[VIAJE ASIGNADO]` y `[VIAJE EN COLA]` los cubre
      // `_pollearTrips` con su propia notif (un canal por nuevo
      // trip detectado en `/trips`). Si tambien disparamos desde
      // mensajes, llegan dos notif por el mismo evento. `[VIAJE
      // LISTO]` SI pasa por aca — `_pollearTrips` no detecta
      // unblock (el trip ya estaba en el snapshot, solo cambia
      // queued_behind), asi que el mensaje del chat es la senal
      // canonica del unblock para la app.
      if (parsed?.tipo == TipoCascada.viajeAsignado ||
          parsed?.tipo == TipoCascada.viajeEnCola) {
        skipped++;
        continue;
      }
      await _mostrarNotifMensaje(
        msgId: id,
        tripId: tripId,
        senderName: senderName,
        content: content,
        alertId: alertId,
        parsed: parsed,
      );
      dispatched++;
    }
    print('[FG-GPS] dispatched=$dispatched skipped=$skipped maxId=$maxId');
    if (esRecoverySeed || maxId != (_lastMsgId ?? 0)) {
      _lastMsgId = maxId;
      // Persistir para que el proximo onStart (despues de un kill) arranque
      // desde donde quedo y no re-spamee notifs viejas.
      await FlutterForegroundTask.saveData(
        key: fgKeyLastMsgId,
        value: maxId,
      );
    }
  }

  /// Polling de alertas L2/L3 vigentes (`/alerts/pending-action`). Es la
  /// fuente de verdad para las notif del SO con action buttons "Estoy
  /// bien" / "Abrir app", porque ese endpoint da el set canonico de
  /// IDs que el chofer debe ackear — el polling de `/messages` no los
  /// tiene de forma estructurada.
  ///
  /// Se mantiene un Set persistido (`fgKeyNotifiedAlertIds`) con los IDs
  /// ya notificados al SO. En cada tick:
  ///   - se calcula `nuevos = pending_actuales - ya_notificados`,
  ///   - si hay nuevos y la app NO esta en foreground, se dispara
  ///     una notif consolidada (titulo prioriza L3 sobre L2),
  ///   - se persiste `notified = pending_actuales` (los que se cayeron
  ///     porque fueron ackeados desaparecen del set y son "elegibles"
  ///     para re-notificar si vuelven a aparecer).
  Future<void> _pollearPendingAction(Dio dio, String tripId) async {
    final token = await _storage.read(key: _kAccess);
    if (token == null || token.isEmpty) return;
    Response<Map<String, dynamic>>? res;
    try {
      res = await dio.get<Map<String, dynamic>>(
        '/api/v1/trips/$tripId/alerts/pending-action',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final ok = await _refrescarToken();
        if (!ok) return;
        final nuevo = await _storage.read(key: _kAccess);
        if (nuevo == null || nuevo.isEmpty) return;
        try {
          res = await dio.get<Map<String, dynamic>>(
            '/api/v1/trips/$tripId/alerts/pending-action',
            options: Options(headers: {'Authorization': 'Bearer $nuevo'}),
          );
        } catch (e2) {
          print('[FG-PENDING] retry fallo: $e2');
          return;
        }
      } else {
        print('[FG-PENDING] status=${e.response?.statusCode}');
        return;
      }
    } catch (e) {
      print('[FG-PENDING] error: $e');
      return;
    }
    final body = res.data;
    if (body == null) return;
    final items = (body['items'] as List?) ?? const [];

    // Set de alertIds vigentes ahora + map id→raw para poder priorizar.
    final currentIds = <int>{};
    final byId = <int, Map<String, dynamic>>{};
    for (final raw in items) {
      if (raw is! Map) continue;
      final id = (raw['id'] as num?)?.toInt();
      if (id == null) continue;
      currentIds.add(id);
      byId[id] = Map<String, dynamic>.from(raw);
    }

    // Cargar set previamente notificados.
    final notifiedJson = await FlutterForegroundTask.getData<String>(
      key: fgKeyNotifiedAlertIds,
    );
    Set<int> previouslyNotified = <int>{};
    if (notifiedJson != null && notifiedJson.isNotEmpty) {
      try {
        previouslyNotified = (jsonDecode(notifiedJson) as List)
            .map((e) => (e as num).toInt())
            .toSet();
      } catch (_) {
        previouslyNotified = <int>{};
      }
    }

    // Purga: si una alerta ya no esta en pending (fue ackeada), la
    // sacamos del set para que sea re-notificable si vuelve.
    final stillRelevant = previouslyNotified.intersection(currentIds);
    final newIds = currentIds.difference(stillRelevant);

    print('[FG-PENDING] poll OK pending=${currentIds.length} '
        'previouslyNotified=${previouslyNotified.length} '
        'new=${newIds.length}');

    if (newIds.isNotEmpty) {
      // Solo disparar notif si la app NO esta en foreground — cuando
      // el chofer la tiene abierta, el banner persistente / fake-call
      // del foreground ya cubre la alerta.
      final appFg = await FlutterForegroundTask.getData<bool>(
        key: fgKeyAppForeground,
      );
      if (appFg == true) {
        print('[FG-PENDING] app en foreground, suprimimos notif del SO '
            '(banner cubre)');
      } else {
        // Elegir alerta principal: L3 prioritaria, sino la primera nueva.
        Map<String, dynamic>? principal;
        for (final id in newIds) {
          final a = byId[id];
          if (a == null) continue;
          if (a['escalation_level'] == 'L3') {
            principal = a;
            break;
          }
          principal ??= a;
        }
        if (principal != null) {
          await _mostrarNotifAlertaPending(
            tripId: tripId,
            principal: principal,
            todosLosIds: currentIds.toList()..sort(),
            cantidad: currentIds.length,
          );
        }
      }
    }

    // Persistir el set actual (lo que esta en pending ahora). Si no hay
    // pending, persistir set vacio para limpiar el storage.
    await FlutterForegroundTask.saveData(
      key: fgKeyNotifiedAlertIds,
      value: jsonEncode(currentIds.toList()),
    );
  }

  /// Polling de `GET /trips` (MC-019). Detecta viajes recien asignados
  /// al chofer y dispara una notif del SO por cada nuevo trip:
  ///
  ///   - Trip "normal" → canal `_kCanalChat` (sonido suave) con titulo
  ///     "Nuevo viaje asignado". Tap → /viaje/{id}.
  ///   - Trip "queued" (params.queued_behind != null) → canal silencioso
  ///     `_kCanalChatSilencioso` con titulo "Tenés un viaje en cola".
  ///     Tap → chat (consistente con MC-017).
  ///
  /// El primer poll despues de un cold-start del service hace SEED
  /// (guarda el snapshot actual sin notificar) — sin esto el chofer
  /// recibiria N notifs por todos los viajes que ya tenia asignados.
  ///
  /// Suprime notif si la app esta en foreground (la lista de viajes
  /// se actualiza al volver, MC-017 ya cubre el render del mensaje).
  ///
  /// **Limitacion conocida**: este flow solo corre cuando el FG service
  /// esta vivo, y el FG service solo arranca cuando hay un trip
  /// activo. Caso "chofer ocioso recibe el primer viaje del dia" no
  /// va a disparar notif — eso queda gap hasta MC-010 (FCM real).
  Future<void> _pollearTrips(Dio dio) async {
    final token = await _storage.read(key: _kAccess);
    if (token == null || token.isEmpty) return;
    Response<dynamic>? res;
    try {
      res = await dio.get<dynamic>(
        '/api/v1/trips',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final ok = await _refrescarToken();
        if (!ok) return;
        final nuevo = await _storage.read(key: _kAccess);
        if (nuevo == null || nuevo.isEmpty) return;
        try {
          res = await dio.get<dynamic>(
            '/api/v1/trips',
            options: Options(headers: {'Authorization': 'Bearer $nuevo'}),
          );
        } catch (e2) {
          print('[FG-TRIPS] retry fallo: $e2');
          return;
        }
      } else {
        print('[FG-TRIPS] status=${e.response?.statusCode}');
        return;
      }
    } catch (e) {
      print('[FG-TRIPS] error: $e');
      return;
    }
    final body = res.data;
    final List rawList = body is List
        ? body
        : (body is Map ? (body['items'] as List? ?? const []) : const []);
    // Construir el set actual + map id → params para detectar queued.
    final currentIds = <String>{};
    final byId = <String, Map<String, dynamic>>{};
    for (final raw in rawList) {
      if (raw is! Map) continue;
      final id = raw['id'];
      if (id is! String || id.isEmpty) continue;
      currentIds.add(id);
      byId[id] = Map<String, dynamic>.from(raw);
    }
    print('[FG-TRIPS] poll OK total=${currentIds.length} '
        'known=${_knownTripIds?.length ?? -1}');

    // Primer poll del lifetime del service (no hubo seed previo): solo
    // grabar baseline, no disparar notif. Sin esto el chofer recibe
    // notif spam por todos los viajes que ya tenia asignados.
    if (_knownTripIds == null) {
      _knownTripIds = currentIds;
      await FlutterForegroundTask.saveData(
        key: fgKeyKnownTripIds,
        value: jsonEncode(currentIds.toList()),
      );
      print('[FG-TRIPS] seed baseline ids=${currentIds.length}');
      return;
    }

    final newIds = currentIds.difference(_knownTripIds!);
    if (newIds.isEmpty) {
      // Persistir igual el set actual: cubre el caso de un trip
      // borrado del lado backend (FINISHED/CANCELLED) — al desaparecer
      // de `/trips`, sale del set y queda elegible para re-notificar
      // si vuelve a aparecer (no deberia pasar pero es defensivo).
      _knownTripIds = currentIds;
      await FlutterForegroundTask.saveData(
        key: fgKeyKnownTripIds,
        value: jsonEncode(currentIds.toList()),
      );
      return;
    }

    final appFg = await FlutterForegroundTask.getData<bool>(
      key: fgKeyAppForeground,
    );
    if (appFg == true) {
      print('[FG-TRIPS] app en foreground, suprimimos notif (lista cubre)');
    } else {
      for (final tripId in newIds) {
        final trip = byId[tripId];
        if (trip == null) continue;
        final params = trip['params'];
        final queuedBehind = (params is Map)
            ? (params['queued_behind'] as String?)
            : null;
        final isQueued = queuedBehind != null && queuedBehind.isNotEmpty;
        await _mostrarNotifTripNuevo(
          tripId: tripId,
          isQueued: isQueued,
        );
      }
    }

    _knownTripIds = currentIds;
    await FlutterForegroundTask.saveData(
      key: fgKeyKnownTripIds,
      value: jsonEncode(currentIds.toList()),
    );
  }

  /// Notif del SO para un trip recien asignado (MC-019). Dos variantes:
  /// queued (silenciosa) o no-queued (sonido suave del canal chat).
  Future<void> _mostrarNotifTripNuevo({
    required String tripId,
    required bool isQueued,
  }) async {
    if (!_notifInicializado) await _inicializarNotifs();
    final canalId = isQueued ? _kCanalChatSilencioso : _kCanalChat;
    final canalNombre = isQueued
        ? 'Avisos silenciosos del sistema'
        : 'Mensajes del monitoreo';
    final titulo = isQueued
        ? 'Tenés un viaje en cola'
        : 'Nuevo viaje asignado';
    final cuerpo = isQueued
        ? 'Vas a poder iniciarlo cuando termine el actual ($tripId)'
        : 'Viaje $tripId — tocá para ver detalles';
    // Usamos `kind: trip-ready` para que el tap navegue a /viaje/{id}
    // (no al chat). Para queued, kind=chat → abre el chat del trip.
    final kind = isQueued ? 'chat' : 'trip-ready';
    final payload = jsonEncode({
      'kind': kind,
      'tripId': tripId,
    });
    // Notification id: hash determinista del tripId (string) para no
    // chocar con otros ids enteros (msgId / alertId) que ya usamos.
    final notifId = (tripId.hashCode & 0x7FFFFFFF) | 0x40000000;
    try {
      await _notif.show(
        notifId,
        titulo,
        cuerpo,
        NotificationDetails(
          android: AndroidNotificationDetails(
            canalId,
            canalNombre,
            importance: isQueued ? Importance.low : Importance.high,
            priority: isQueued ? Priority.low : Priority.high,
            category: AndroidNotificationCategory.message,
            enableVibration: !isQueued,
            playSound: !isQueued,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: !isQueued,
            presentBadge: true,
          ),
        ),
        payload: payload,
      );
      print('[FG-TRIPS] notif OK trip=$tripId queued=$isQueued');
    } catch (e) {
      print('[FG-TRIPS] notif fallo: $e');
    }
  }

  /// Construye la notif consolidada del SO para alertas pending-action
  /// con dos action buttons: "Estoy bien" (ack en bg) y "Abrir app"
  /// (deep link al viaje). Usa el canal `_kCanalAlertas` con
  /// `Importance.max`. NO usamos `fullScreenIntent` aca — eso queda
  /// solo para `[LLAMADA · ...]` (FakeCall full-screen). El payload
  /// incluye `pendingIds` con TODOS los IDs visibles ahora, asi el
  /// boton "Estoy bien" puede ackear-los todos sin abrir la app.
  Future<void> _mostrarNotifAlertaPending({
    required String tripId,
    required Map<String, dynamic> principal,
    required List<int> todosLosIds,
    required int cantidad,
  }) async {
    if (!_notifInicializado) await _inicializarNotifs();

    final escLevel = (principal['escalation_level'] ?? '').toString();
    final regla = (principal['rule_type'] ?? 'Alerta').toString();
    final mensaje = (principal['message'] ?? '').toString();
    final esL3 = escLevel == 'L3';
    final principalId = (principal['id'] as num?)?.toInt() ?? 0;

    String titulo = esL3
        ? 'Escalado a supervisor — $regla'
        : 'Acción requerida — $regla';
    if (cantidad > 1) {
      titulo += ' (+${cantidad - 1})';
    }

    final cuerpo = mensaje.isNotEmpty
        ? mensaje
        : 'El monitoreo necesita que confirmes que estás bien.';

    // Mismo shape que `NotificacionesAlertas` espera al hacer deep-link
    // en el main isolate al tap simple. `pendingIds` es nuevo y solo lo
    // usa `onBackgroundNotifAction` para ackear desde la notif.
    final payload = jsonEncode({
      'kind': 'alerta',
      'tripId': tripId,
      'alertId': principalId,
      'regla': regla,
      'contenido': cuerpo,
      'pendingIds': todosLosIds,
    });

    try {
      await _notif.show(
        principalId,
        titulo,
        cuerpo,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _kCanalAlertas,
            'Alertas críticas IsaTech',
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.call,
            // Sin fullScreenIntent: solo LLAMADA usa eso. L2/L3 alcanza
            // con heads-up + sound + action buttons.
            fullScreenIntent: false,
            enableVibration: true,
            playSound: true,
            // Ongoing impide que el chofer la cierre con swipe sin haber
            // ackeado o abierto la app. autoCancel:false para preservar.
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            actions: const [
              AndroidNotificationAction(
                _kNotifActionAck,
                'Estoy bien',
                cancelNotification: true,
                showsUserInterface: false,
              ),
              AndroidNotificationAction(
                _kNotifActionOpen,
                'Abrir app',
                cancelNotification: false,
                showsUserInterface: true,
              ),
            ],
          ),
          iOS: const DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
            categoryIdentifier: 'isatech_alerta_pending',
          ),
        ),
        payload: payload,
      );
      print('[FG-PENDING] show notif OK id=$principalId '
          'pending=${todosLosIds.length} L3=$esL3');
    } catch (e) {
      print('[FG-PENDING] show notif fallo: $e');
    }
  }

  /// Construye y dispara la notificacion del SO para un mensaje del MONITOR.
  /// El payload JSON tiene el mismo formato que [NotificacionesAlertas] —
  /// asi cuando el chofer toca la notif, el main isolate (cold-start o warm)
  /// la parsea via getNotificationAppLaunchDetails / onDidReceiveNotificationResponse
  /// y deep-linkea al lugar correcto (chat / banner viaje / fake-call).
  Future<void> _mostrarNotifMensaje({
    required int msgId,
    required String tripId,
    required String senderName,
    required String content,
    required int? alertId,
    required CascadaTagParsed? parsed,
  }) async {
    // Si la app esta en foreground, suprimimos la notif del SO desde
    // este isolate — el ChatNotifier en el main isolate ya esta poliando
    // y va a disparar su propia notif (con sus refs y deep link). De
    // este modo evitamos heads-up duplicada cuando el chofer ya tiene
    // la app a la vista. La excepcion es LLAMADA: dejamos que ambos
    // canales disparen porque el FakeCall fullScreen es importante.
    final appFg = await FlutterForegroundTask.getData<bool>(
      key: fgKeyAppForeground,
    );
    final esLlamada = parsed?.tipo == TipoCascada.llamada;
    if (appFg == true && !esLlamada) {
      print('[FG-GPS] notif suprimida (app en foreground, no es LLAMADA)');
      return;
    }
    if (!_notifInicializado) await _inicializarNotifs();
    String kind;
    String canalId;
    String canalNombre;
    bool urgente;
    bool fullScreen;
    String titulo;
    String cuerpo;
    if (parsed == null ||
        parsed.tipo == TipoCascada.aviso ||
        parsed.tipo == TipoCascada.supervisorInformado) {
      // Informativos: mensaje libre del monitor, L1 AVISO, o supervisor
      // notificado. Canal "chat" — suena suave, tap → chat.
      kind = 'chat';
      canalId = _kCanalChat;
      canalNombre = 'Mensajes del monitoreo';
      urgente = false;
      fullScreen = false;
      if (parsed?.tipo == TipoCascada.aviso) {
        titulo = 'Aviso — ${parsed!.regla}';
        cuerpo = parsed.contenidoLimpio.isNotEmpty
            ? parsed.contenidoLimpio
            : content;
      } else if (parsed?.tipo == TipoCascada.supervisorInformado) {
        titulo = 'Supervisor notificado';
        cuerpo = parsed!.contenidoLimpio.isNotEmpty
            ? parsed.contenidoLimpio
            : content;
      } else {
        final n = senderName.trim();
        titulo = n.isEmpty ? 'Mensaje del monitoreo' : n;
        cuerpo = content;
      }
    } else if (parsed.tipo == TipoCascada.viajeListo) {
      // MC-017: trip queued se desbloqueo. Tap → /viaje/{id}.
      kind = 'trip-ready';
      canalId = _kCanalChat;
      canalNombre = 'Mensajes del monitoreo';
      urgente = false;
      fullScreen = false;
      titulo = 'Viaje listo para arrancar';
      cuerpo = parsed.contenidoLimpio.isNotEmpty
          ? parsed.contenidoLimpio
          : content;
    } else if (parsed.tipo == TipoCascada.directivaOperador) {
      // MC-018: directiva preset del operador. Tap → /viaje/{id}.
      // El overlay de la app ya maneja el banner cuando esta abierta;
      // esto cubre el caso "app cerrada / minimizada".
      kind = 'operator-directive';
      canalId = _kCanalChat;
      canalNombre = 'Mensajes del monitoreo';
      urgente = false;
      fullScreen = false;
      titulo = parsed.regla.isEmpty
          ? 'Mensaje del operador'
          : 'Mensaje del operador · ${parsed.regla}';
      cuerpo = parsed.contenidoLimpio.isNotEmpty
          ? parsed.contenidoLimpio
          : (parsed.regla.isEmpty ? content : parsed.regla);
    } else if (parsed.tipo == TipoCascada.llamada) {
      // Llamada urgente — fullScreenIntent para que aparezca encima de todo
      // y, al tocar, abra el fake-call directamente.
      kind = 'llamada';
      canalId = _kCanalAlertas;
      canalNombre = 'Alertas críticas IsaTech';
      urgente = true;
      fullScreen = true;
      titulo = 'Llamada del monitoreo';
      cuerpo = parsed.contenidoLimpio.isNotEmpty
          ? parsed.contenidoLimpio
          : content;
    } else {
      // L2 (accion requerida) o L3 (escalado a supervisor): canal alertas
      // criticas, tap → /viaje/{id} donde se ve el banner persistente.
      kind = 'alerta';
      canalId = _kCanalAlertas;
      canalNombre = 'Alertas críticas IsaTech';
      urgente = parsed.tipo == TipoCascada.escaladoSupervisor;
      fullScreen = false;
      titulo = parsed.tipo == TipoCascada.escaladoSupervisor
          ? 'Escalado a supervisor — ${parsed.regla}'
          : 'Acción requerida — ${parsed.regla}';
      cuerpo = parsed.contenidoLimpio.isNotEmpty
          ? parsed.contenidoLimpio
          : content;
    }
    final payload = jsonEncode({
      'kind': kind,
      'tripId': tripId,
      if (alertId != null) 'alertId': alertId,
      if (parsed != null && parsed.regla.isNotEmpty) 'regla': parsed.regla,
      if (parsed != null && parsed.contenidoLimpio.isNotEmpty)
        'contenido': parsed.contenidoLimpio,
    });
    try {
      await _notif.show(
        msgId,
        titulo,
        cuerpo,
        NotificationDetails(
          android: AndroidNotificationDetails(
            canalId,
            canalNombre,
            importance: urgente ? Importance.max : Importance.high,
            priority: urgente ? Priority.max : Priority.high,
            category: kind == 'chat'
                ? AndroidNotificationCategory.message
                : AndroidNotificationCategory.call,
            fullScreenIntent: fullScreen,
            enableVibration: true,
            playSound: true,
            // Si el foreground (ChatNotifier) ya disparo este id, evitar
            // re-vibrar/re-sonar; el SO solo actualiza el contenido.
            onlyAlertOnce: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
          ),
        ),
        payload: payload,
      );
      print('[FG-GPS] show notif OK id=$msgId kind=$kind canal=$canalId');
    } catch (e) {
      print('[FG-GPS] show notif fallo: $e');
    }
  }

  Future<bool> _refrescarToken() async {
    if (_refrescando) return false;
    _refrescando = true;
    try {
      final base = _iamBase;
      if (base == null) return false;
      final refresh = await _storage.read(key: _kRefresh);
      if (refresh == null || refresh.isEmpty) return false;
      final iamDio = Dio(
        BaseOptions(
          baseUrl: base,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final res = await iamDio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refresh},
      );
      final newAccess = res.data?['access_token'] as String?;
      final newRefresh = res.data?['refresh_token'] as String? ?? refresh;
      if (newAccess == null) return false;
      await _storage.write(key: _kAccess, value: newAccess);
      await _storage.write(key: _kRefresh, value: newRefresh);
      debugPrint('[FG-GPS] token refrescado');
      return true;
    } catch (e) {
      debugPrint('[FG-GPS] refresh fallo: $e');
      return false;
    } finally {
      _refrescando = false;
    }
  }

  void _actualizarNotificacion(DateTime ts, {required bool exito}) {
    final hora = DateFormat('HH:mm:ss').format(ts);
    FlutterForegroundTask.updateService(
      notificationTitle: 'IsaTech Conductor',
      notificationText: exito
          ? 'Reportando ubicación · último envío $hora'
          : 'Sin red — reintentando ($_fallidos fallos)',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    debugPrint(
      '[FG-GPS] onDestroy exitosos=$_exitosos fallidos=$_fallidos',
    );
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }

  @override
  void onReceiveData(Object data) {
    // El main isolate puede mandar mensajes (ej. cambio de tripId).
    if (data is Map) {
      final tripId = data['tripId']?.toString();
      if (tripId != null && tripId.isNotEmpty) _tripId = tripId;
    }
  }
}
