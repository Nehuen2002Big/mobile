import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/trip_navigation.dart';

/// Servicio de voz turn-by-turn (MC-021).
///
/// Anuncia la proxima maniobra cuando el chofer cruza ciertos
/// "buckets" de distancia (1 km / 500 m / 200 m / 50 m). Cada
/// maniobra se anuncia maximo una vez por bucket — el `Set<int>` en
/// `_anunciados` evita spam si el GPS jitea entre lecturas dentro
/// del mismo bucket.
///
/// El backend ya entrega `maneuver.instructionEs` pre-armada para
/// algunas maniobras (TTS friendly). Si esta vacia, caemos a una
/// frase generada localmente desde `type` + `modifier` + `exit`.
class TurnByTurnVoice {
  TurnByTurnVoice();

  final FlutterTts _tts = FlutterTts();
  bool _inicializado = false;
  Future<void>? _initFuture;

  /// Buckets de distancia (metros) en orden descendente — implementados
  /// inline en [_bucketParaDistancia]. Cuando la distancia a la maniobra
  /// cae por debajo de uno y todavia no lo anunciamos, hablamos:
  ///   1000 m → "En 1000 metros, ..."
  ///    500 m → "En 500 metros, ..."
  ///    200 m → "En 200 metros, ..."
  ///     50 m → vocaliza la accion sin distancia ("Gire a la derecha").
  ///
  /// Map `'legIdx:stepIdx' → buckets ya anunciados`. Sobrevive entre
  /// ticks de progreso. Cuando cambia el step actual (chofer paso la
  /// maniobra), se limpia el entry anterior para liberar memoria.
  final Map<String, Set<int>> _anunciados = {};

  String? _ultimoKey;

  Future<void> _inicializar() async {
    if (_inicializado) return;
    _initFuture ??= _doInit();
    await _initFuture;
  }

  Future<void> _doInit() async {
    try {
      await _tts.setLanguage('es-AR');
      await _tts.setVolume(0.7);
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      // No usamos awaitSpeakCompletion para que el speak no bloquee
      // el loop de progreso. Anti-spam ya esta en _anunciados.
      _inicializado = true;
    } catch (e) {
      if (kDebugMode) debugPrint('TurnByTurnVoice init fallo: $e');
    }
  }

  /// Procesa un tick de progreso. Decide si hay que hablar y, en su
  /// caso, dispara `_tts.speak`.
  ///
  /// - [legIndex], [stepIndex]: cursor del progreso del backend
  ///   (`progress.currentLegIndex` / `currentStepIndex`).
  /// - [distanceToManeuver]: metros hasta la maniobra de este step.
  /// - [maneuver]: la maniobra actual (con `type`, `modifier`,
  ///   `exit`, `instructionEs`).
  Future<void> onProgress({
    required int legIndex,
    required int stepIndex,
    required double distanceToManeuver,
    required NavigationManeuver maneuver,
  }) async {
    final key = '$legIndex:$stepIndex';
    // Si cambiamos de step, liberamos el cache del anterior.
    if (_ultimoKey != null && _ultimoKey != key) {
      _anunciados.remove(_ultimoKey);
    }
    _ultimoKey = key;

    // Maniobras que no anunciamos: depart (inicio), continue (no
    // hay accion del chofer), unknown.
    final tipo = maneuver.type.toLowerCase();
    if (tipo == 'depart' || tipo == 'continue' || tipo.isEmpty) return;

    final bucket = _bucketParaDistancia(distanceToManeuver);
    if (bucket == null) return;

    final yaAnunciados = _anunciados.putIfAbsent(key, () => <int>{});
    if (yaAnunciados.contains(bucket)) return;
    // Tambien evitamos anunciar buckets "mas lejos" si ya pasamos los
    // mas cercanos en esta sesion (caso jitter de GPS que vuelve a
    // alejar al chofer artificialmente).
    if (yaAnunciados.any((b) => b < bucket)) {
      yaAnunciados.add(bucket);
      return;
    }
    yaAnunciados.add(bucket);

    await _inicializar();
    if (!_inicializado) return;

    final frase = _frase(
      maneuver: maneuver,
      bucket: bucket,
    );
    if (frase.isEmpty) return;
    try {
      await _tts.speak(frase);
    } catch (e) {
      if (kDebugMode) debugPrint('TTS speak fallo: $e');
    }
  }

  /// Dispara una frase inmediata sin pasar por el sistema de buckets
  /// (por ej. "Recalculando ruta" cuando el watcher dispara un
  /// recompute). No queda registro en `_anunciados`.
  Future<void> speakImmediate(String frase) async {
    if (frase.isEmpty) return;
    await _inicializar();
    if (!_inicializado) return;
    try {
      await _tts.speak(frase);
    } catch (e) {
      if (kDebugMode) debugPrint('TTS speakImmediate fallo: $e');
    }
  }

  /// Bucket "activo" para una distancia dada. Devolvemos el bucket
  /// **mas chico** que sea >= distancia — eso garantiza que cada
  /// vez que cruzamos un umbral hacia abajo, hablamos exactamente
  /// una vez. Si la distancia es <50 m, devolvemos 50 (estamos
  /// llegando a la maniobra).
  int? _bucketParaDistancia(double d) {
    if (d <= 0) return null;
    if (d <= 50) return 50;
    if (d <= 200) return 200;
    if (d <= 500) return 500;
    if (d <= 1000) return 1000;
    return null; // demasiado lejos, no anunciamos
  }

  String _frase({
    required NavigationManeuver maneuver,
    required int bucket,
  }) {
    final accion = _accionLocal(maneuver);
    if (accion.isEmpty) return '';
    if (bucket <= 50) return accion;
    return 'En $bucket metros, $accion';
  }

  /// Genera la frase de la maniobra. Prioriza `instructionEs` del
  /// backend si esta presente; si no, arma localmente desde
  /// `type` + `modifier` + `exit`. Devuelve string vacio para tipos
  /// que no queremos vocalizar.
  String _accionLocal(NavigationManeuver m) {
    final instruccion = m.instructionEs.trim();
    if (instruccion.isNotEmpty) {
      // El backend ya da instruccion pulida; la usamos tal cual,
      // bajando la primera letra para que encaje en "En 500 metros,
      // gire a la derecha" (la frase ya tiene mayuscula del backend).
      return instruccion.substring(0, 1).toLowerCase() +
          instruccion.substring(1);
    }
    final tipo = m.type.toLowerCase();
    final mod = (m.modifier ?? '').toLowerCase();
    switch (tipo) {
      case 'turn':
        switch (mod) {
          case 'left':
            return 'gire a la izquierda';
          case 'right':
            return 'gire a la derecha';
          case 'slight left':
            return 'gire suave a la izquierda';
          case 'slight right':
            return 'gire suave a la derecha';
          case 'sharp left':
            return 'gire fuerte a la izquierda';
          case 'sharp right':
            return 'gire fuerte a la derecha';
          case 'uturn':
            return 'haga un giro en U';
          default:
            return 'gire';
        }
      case 'merge':
        return 'incorpórese a la vía principal';
      case 'fork':
        final lado = mod == 'left' ? 'izquierda' : 'derecha';
        return 'tome la bifurcación a la $lado';
      case 'roundabout':
      case 'rotary':
      case 'roundabout turn':
        final n = m.exit ?? 1;
        return 'tome la ${_ordinal(n)} salida de la rotonda';
      case 'exit roundabout':
      case 'exit rotary':
        return 'salga de la rotonda';
      case 'arrive':
        return 'ha llegado a destino';
      case 'on ramp':
        return 'tome la rampa';
      case 'off ramp':
        return 'salga por la rampa';
      case 'end of road':
        if (mod == 'left') return 'al final, doble a la izquierda';
        if (mod == 'right') return 'al final, doble a la derecha';
        return 'al final, continúe';
      default:
        return '';
    }
  }

  String _ordinal(int n) {
    switch (n) {
      case 1:
        return 'primera';
      case 2:
        return 'segunda';
      case 3:
        return 'tercera';
      case 4:
        return 'cuarta';
      case 5:
        return 'quinta';
      default:
        return '$n°';
    }
  }

  /// Liberar el TTS al desmontar la pantalla.
  Future<void> dispose() async {
    try {
      await _tts.stop();
    } catch (_) {}
    _anunciados.clear();
    _ultimoKey = null;
  }
}
