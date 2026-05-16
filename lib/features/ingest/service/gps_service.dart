import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/config/api_config.dart';
import '../data/ingest_repository.dart';
import '../data/phone_location_exceptions.dart';
import 'gps_foreground_task.dart';

/// Resultado de pedir permisos de ubicacion al usuario. Lo expone el
/// GpsService para que la UI muestre el dialog/CTA apropiado.
enum PermisoUbicacionResult {
  /// Permisos otorgados (whileInUse o always).
  ok,
  /// Servicio de ubicacion del sistema apagado (Android / Settings).
  servicioDesactivado,
  /// Usuario rechazo el permiso esta vez. Se puede volver a pedir.
  denegado,
  /// Usuario rechazo "Siempre" o eligio "No volver a preguntar". La unica
  /// salida es que vaya a Configuracion.
  denegadoParaSiempre,
}

/// Servicio que maneja el reporte continuo de GPS al backend.
///
/// En Android delega el envio periodico a un *foreground service* (via
/// `flutter_foreground_task`) para que siga corriendo aun cuando la app
/// este minimizada o la pantalla apagada. La UI sigue viendo `ultimaPosicion`
/// y `ultimoEnvio` por un position stream local que NO hace POSTs (evita
/// duplicar pings).
///
/// Si hay un override de debug activo (simulador de ubicacion), se usa el
/// modo viejo de polling local para que el override se respete sin tener
/// que sincronizarlo con el isolate del foreground service.
class GpsService extends ChangeNotifier {
  GpsService(this._repo, this._config) {
    // Subscribirse al canal del foreground service para recibir eventos
    // del isolate background — especificamente `trip_ended_remotely`
    // que se dispara cuando el backend devuelve 409 al phone-location.
    _attachTaskDataCallback();
  }

  final IngestRepository _repo;
  final ApiConfig _config;

  Timer? _timer;
  StreamSubscription<Position>? _sub;
  Position? _ultima;
  Position? _override;
  String? _imei;
  String? _tripId;
  bool _activo = false;
  bool _foregroundServiceCorriendo = false;
  bool _enBackground = false;
  /// Flag que se prende cuando el backend devuelve 409 (trip ya
  /// FINISHED/CANCELLED) a un phone-location. La pantalla del viaje lo
  /// observa y refresca el detalle del trip para reflejar el estado real.
  bool _tripTerminadoRemoto = false;
  String? _ultimoError;
  String? _ultimoErrorPhone;
  DateTime? _ultimoEnvioPhone;

  /// Engancha el listener al canal de datos que el isolate background
  /// del foreground service emite via `FlutterForegroundTask.sendDataToMain`.
  /// Solo nos interesa el evento `trip_ended_remotely` (409 al
  /// phone-location); el resto se ignora.
  void _attachTaskDataCallback() {
    try {
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
    } catch (e) {
      // El plugin puede no estar inicializado (ej. tests unitarios).
      // No es fatal.
      if (kDebugMode) {
        debugPrint('[GpsService] attach taskData fallo: $e');
      }
    }
  }

  void _onTaskData(Object data) {
    if (data is! Map) return;
    final event = data['event']?.toString();
    if (event != 'trip_ended_remotely') return;
    final remoteTripId = data['tripId']?.toString();
    // Solo prender el flag si coincide con el trip que la app
    // todavia cree activo — sino seria noise de un viaje viejo.
    if (remoteTripId != null && remoteTripId == _tripId) {
      _tripTerminadoRemoto = true;
      // Tambien parar el state local: el foreground service ya se
      // detuvo del lado del bg isolate, pero aca tenemos que
      // marcar _activo=false y _foregroundServiceCorriendo=false
      // para que la UI no muestre el GPS como en marcha.
      _activo = false;
      _foregroundServiceCorriendo = false;
      _timer?.cancel();
      _timer = null;
      _sub?.cancel();
      _sub = null;
      notifyListeners();
    }
  }

  static const Duration _intervaloForeground = Duration(seconds: 15);
  static const Duration _intervaloBackground = Duration(seconds: 60);

  Duration get intervalo =>
      _enBackground ? _intervaloBackground : _intervaloForeground;

  Position? get ultimaPosicion => _ultima;
  bool get activo => _activo;
  bool get enBackground => _enBackground;
  bool get overrideActivo => _override != null;
  Position? get ubicacionOverride => _override;
  bool get tripTerminadoRemoto => _tripTerminadoRemoto;
  String? get ultimoError => _ultimoError;
  String? get ultimoErrorPhone => _ultimoErrorPhone;
  DateTime? get ultimoEnvio => _ultimoEnvioPhone;

  /// Se llama cuando la UI ya consumio el flag (ej. refresco la lista de
  /// viajes y el detalle). Limpia para no disparar refrescos repetidos.
  void marcarTerminoRemotoConsumido() {
    if (!_tripTerminadoRemoto) return;
    _tripTerminadoRemoto = false;
    notifyListeners();
  }

  /// Cambia la frecuencia segun foreground/background. Solo afecta el modo
  /// fallback con override (debug); el foreground service real corre con
  /// frecuencia fija.
  void setBackground(bool value) {
    if (_enBackground == value) return;
    _enBackground = value;
    if (_activo && _override != null) {
      _timer?.cancel();
      _timer = Timer.periodic(intervalo, (_) => _enviarAhora());
    }
    notifyListeners();
  }

  /// Override de debug: simula ubicacion fija. En este modo no se usa el
  /// foreground service — el polling es local para que el override se
  /// respete inmediatamente sin sincronizar isolates.
  void setOverride(double lat, double lon) {
    _override = Position(
      latitude: lat,
      longitude: lon,
      timestamp: DateTime.now().toUtc(),
      accuracy: 1.0,
      altitude: 0.0,
      altitudeAccuracy: 1.0,
      heading: 0.0,
      headingAccuracy: 1.0,
      speed: 0.0,
      speedAccuracy: 1.0,
      isMocked: true,
    );
    _ultima = _override;
    _sub?.cancel();
    _sub = null;
    // Si estabamos en modo foreground service, lo paramos y caemos a
    // polling local respetando el override.
    if (_foregroundServiceCorriendo) {
      _detenerForegroundService();
    }
    if (_activo) {
      _timer?.cancel();
      _timer = Timer.periodic(intervalo, (_) => _enviarAhora());
    }
    notifyListeners();
  }

  Future<void> clearOverride() async {
    _override = null;
    notifyListeners();
    if (_activo) {
      // Volver a modo normal: foreground service.
      _timer?.cancel();
      _timer = null;
      await _arrancarForegroundService();
      _abrirStreamLocalParaUi();
    }
  }

  Future<bool> _asegurarPermiso() async {
    final r = await pedirPermisoUbicacion();
    return r == PermisoUbicacionResult.ok;
  }

  Future<PermisoUbicacionResult> pedirPermisoUbicacion() async {
    final habilitado = await Geolocator.isLocationServiceEnabled();
    if (!habilitado) {
      _ultimoError = 'Servicio de ubicacion desactivado';
      notifyListeners();
      return PermisoUbicacionResult.servicioDesactivado;
    }
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.deniedForever) {
      _ultimoError =
          'Permiso de ubicacion denegado permanentemente. Habilitalo desde Configuracion.';
      notifyListeners();
      return PermisoUbicacionResult.denegadoParaSiempre;
    }
    if (p == LocationPermission.denied) {
      _ultimoError = 'Permiso de ubicacion denegado';
      notifyListeners();
      return PermisoUbicacionResult.denegado;
    }
    return PermisoUbicacionResult.ok;
  }

  Future<Position?> ubicacionActual({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (_override != null) {
      _ultima = _override;
      return _override;
    }
    if (!await _asegurarPermiso()) return _ultima;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 0,
          timeLimit: timeout,
        ),
      ).timeout(timeout);
      _ultima = pos;
      notifyListeners();
      return pos;
    } catch (e) {
      debugPrint(
        'ubicacionActual timeout/error: $e. Fallback a ultima posicion conocida',
      );
      _ultimoError = '$e';
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          _ultima = last;
          notifyListeners();
          return last;
        }
      } catch (_) {}
      notifyListeners();
      return _ultima;
    }
  }

  Future<void> iniciar({required String imei, required String tripId}) async {
    if (_activo && _imei == imei && _tripId == tripId) return;
    await detener();
    if (_override == null && !await _asegurarPermiso()) return;
    _imei = imei;
    _tripId = tripId;
    _activo = true;
    _ultimoError = null;
    notifyListeners();

    if (_override == null) {
      // Modo normal: el envio lo hace el foreground service, que sobrevive
      // a la app minimizada. La UI igual mantiene un stream local para ver
      // posicion en vivo.
      await _arrancarForegroundService();
      _abrirStreamLocalParaUi();
    } else {
      // Modo override (debug): polling local con timer.
      _timer = Timer.periodic(intervalo, (_) => _enviarAhora());
      unawaited(_enviarAhora());
    }
  }

  Future<void> detener() async {
    _timer?.cancel();
    _timer = null;
    await _sub?.cancel();
    _sub = null;
    if (_foregroundServiceCorriendo) {
      await _detenerForegroundService();
    }
    _activo = false;
    notifyListeners();
  }

  // ─── Foreground service ───────────────────────────────────────────────

  Future<void> _arrancarForegroundService() async {
    if (_foregroundServiceCorriendo) {
      print('[GpsService] foreground service ya corriendo — skip');
      return;
    }
    final tripId = _tripId;
    if (tripId == null) {
      print('[GpsService] _arrancarForegroundService SKIP — sin tripId');
      return;
    }
    print('[GpsService] arrancando foreground service trip=$tripId '
        'base=${_config.trackingBaseUrl}');

    // Configurar canal de notificacion una vez (init es idempotente).
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'isatech_gps_tracking',
        channelName: 'IsaTech Conductor — GPS',
        channelDescription:
            'Reporta ubicación al monitoreo durante el viaje activo.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(
          _intervaloForeground.inMilliseconds,
        ),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    // Pasar config al isolate del task handler via SharedPreferences.
    await FlutterForegroundTask.saveData(key: fgKeyTripId, value: tripId);
    await FlutterForegroundTask.saveData(
      key: fgKeyTrackingBase,
      value: _config.trackingBaseUrl,
    );
    await FlutterForegroundTask.saveData(
      key: fgKeyIamBase,
      value: _config.iamBaseUrl,
    );

    final result = await FlutterForegroundTask.startService(
      notificationTitle: 'IsaTech Conductor',
      notificationText: 'Reportando ubicación al monitoreo',
      callback: gpsForegroundCallback,
    );
    _foregroundServiceCorriendo = result is ServiceRequestSuccess;
    print('[GpsService] foreground service started=$_foregroundServiceCorriendo'
        ' result=${result.runtimeType}');
  }

  Future<void> _detenerForegroundService() async {
    if (!_foregroundServiceCorriendo) return;
    try {
      await FlutterForegroundTask.stopService();
    } catch (e) {
      debugPrint('[GpsService] stopService fallo: $e');
    }
    _foregroundServiceCorriendo = false;
  }

  /// Stream local de GPS solo para que la UI vea la ultima posicion. NO
  /// hace POSTs — esos los hace el foreground service en otro isolate.
  void _abrirStreamLocalParaUi() {
    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (pos) {
        _ultima = pos;
        // El foreground service ya esta posteando — no duplicamos POST.
        // Solo refrescamos last-seen para la UI.
        _ultimoEnvioPhone = DateTime.now();
        notifyListeners();
      },
      onError: (e) {
        _ultimoError = '$e';
        notifyListeners();
      },
    );
  }

  // ─── Polling local (solo modo override / debug) ───────────────────────

  Future<void> _enviarAhora() async {
    final tripId = _tripId;
    if (!_activo || tripId == null) return;
    final pos = _override ?? _ultima ?? await ubicacionActual();
    if (pos == null) return;

    final speedKmh = (pos.speed * 3.6).clamp(0, 400).toDouble();
    final recordedAt = pos.timestamp;
    await _ejecutarPhoneLocation(
      tripId: tripId,
      lat: pos.latitude,
      lon: pos.longitude,
      speedKmh: speedKmh,
      recordedAt: recordedAt,
    );
    notifyListeners();
  }

  Future<void> _ejecutarPhoneLocation({
    required String tripId,
    required double lat,
    required double lon,
    required double speedKmh,
    required DateTime recordedAt,
  }) async {
    try {
      debugPrint('Phone location POST trip=$tripId lat=$lat lon=$lon');
      await _repo.enviarPhoneLocation(
        tripId: tripId,
        lat: lat,
        lon: lon,
        speedKmh: speedKmh,
        recordedAt: recordedAt,
      );
      _ultimoEnvioPhone = DateTime.now();
      _ultimoErrorPhone = null;
      debugPrint('Phone location OK');
    } catch (e) {
      _ultimoErrorPhone = '$e';
      debugPrint('Phone location error: $e');
      if (e is TripYaTerminadoException) {
        debugPrint('GpsService: viaje terminado en backend, deteniendo tracking');
        _tripTerminadoRemoto = true;
        await detener();
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    try {
      FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    } catch (_) {}
    detener();
    super.dispose();
  }
}
