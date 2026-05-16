import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/utils/geo.dart';
import '../models/trip_navigation.dart';

/// Detector de desvio sostenido + disparador de auto-reroute (MC-021).
///
/// Reglas:
///   - Threshold de desvio: 50 m de la polyline planeada.
///   - Debounce: hay que estar desviado >= 10 s antes de pedir
///     recompute. Eso filtra jitter de GPS (un solo ping malo no
///     dispara un reroute).
///   - Solo un recompute en vuelo a la vez (`_inFlight`) — evita que
///     dos ticks consecutivos disparen 2 requests si el primero
///     tarda en responder.
///   - Si el recompute falla (red caida, OSRM down), NO mostramos
///     error al chofer — el polyline anterior sigue siendo valido
///     como fallback. La proxima vez que cruce el debounce, vuelve
///     a intentar.
class RouteWatcher {
  RouteWatcher();

  /// Distancia (m) sobre la cual consideramos al chofer "fuera de
  /// ruta". El backend tiene 30 m como threshold operativo del SPA,
  /// pero el navegador es mas conservador (~50 m) para no recomputar
  /// por errores de GPS de tipo zonas urbanas con muros.
  static const double thresholdM = 50.0;

  /// Cuanto tiempo tiene que estar el chofer "off-route" antes de
  /// disparar el recompute. Filtra jitter.
  static const Duration debounce = Duration(seconds: 10);

  DateTime? _firstDeviationAt;
  bool _inFlight = false;

  /// Recibe un tick de GPS + la navegacion vigente. Calcula la
  /// distancia del chofer al polyline y, si supera el threshold por
  /// mas del tiempo de debounce, dispara un recompute via los
  /// callbacks.
  ///
  /// - [onSay]: callback para vocalizar/notificar "Recalculando
  ///   ruta". Suele apuntar a `voice.speakImmediate(...)` +
  ///   snackbar.
  /// - [onRecompute]: callback que efectivamente hace el POST y
  ///   devuelve el nuevo `TripNavigation`. Si devuelve `null`,
  ///   asumimos que fallo y no actualizamos.
  /// - [onApply]: callback que aplica el nuevo `TripNavigation` al
  ///   state (ej. `notifier.aplicarRecompute(nav)`).
  Future<void> onPositionUpdate({
    required double lat,
    required double lon,
    required TripNavigation navigation,
    required Future<TripNavigation?> Function(double startLat, double startLon)
        onRecompute,
    required void Function(String frase) onSay,
    required void Function(TripNavigation nuevo) onApply,
  }) async {
    final coords = navigation.geometry.coordinates;
    if (coords.length < 2) return;

    final proj = projectOnPolyline(lat: lat, lon: lon, coords: coords);
    if (proj.distM < thresholdM) {
      // Estamos sobre la ruta. Limpiar el timer si estaba corriendo.
      _firstDeviationAt = null;
      return;
    }

    // Fuera de ruta. Inicializar / chequear debounce.
    _firstDeviationAt ??= DateTime.now();
    final desviadoHace = DateTime.now().difference(_firstDeviationAt!);
    if (desviadoHace < debounce) return;
    if (_inFlight) return;

    _inFlight = true;
    onSay('Recalculando ruta');
    try {
      final nueva = await onRecompute(lat, lon);
      if (nueva != null) {
        onApply(nueva);
        // Resetear deviation: con el nuevo polyline, el chofer esta
        // por definicion al inicio de la ruta.
        _firstDeviationAt = null;
      }
      // Si nueva es null (request fallo), dejamos `_firstDeviationAt`
      // como esta — el proximo tick va a esperar otra ventana de
      // debounce y reintentar. Sin loop infinito.
    } catch (e) {
      if (kDebugMode) debugPrint('RouteWatcher recompute fallo: $e');
      // Reseteamos para que vuelva a entrar en debounce desde 0 en
      // vez de spamear retries.
      _firstDeviationAt = DateTime.now();
    } finally {
      _inFlight = false;
    }
  }

  /// Resetear el state. Util al cambiar de trip o salir de la
  /// pantalla de navegacion.
  void reset() {
    _firstDeviationAt = null;
    _inFlight = false;
  }
}
