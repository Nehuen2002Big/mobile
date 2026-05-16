import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/providers.dart';
import '../../checkpoints/models/checkpoint_info.dart';
import '../../hoja_ruta/models/route_progress_response.dart';
import '../../hoja_ruta/models/trip.dart';
import '../data/navigation_exceptions.dart';
import '../models/trip_navigation.dart';

part 'navegacion_state.freezed.dart';

@freezed
class NavegacionState with _$NavegacionState {
  const NavegacionState._();

  const factory NavegacionState({
    /// Payload completo de la ruta computada por el backend.
    TripNavigation? navigation,
    /// Cursor live: en que step estoy y cuanto falta a la proxima maniobra.
    RouteProgressResponse? progress,
    /// Para detectar cuando el backend recomputa: si aumenta vs lo guardado,
    /// re-fetcheamos la nav.
    DateTime? lastComputedAt,
    @Default(false) bool loading,
    @Default(false) bool reintentando,
    String? error,
  }) = _NavegacionState;

  /// La maniobra actualmente vigente segun el cursor del backend, o null si
  /// todavia no hay datos.
  NavigationStep? get currentStep {
    final nav = navigation;
    final p = progress;
    if (nav == null || p == null) return null;
    final li = p.currentLegIndex;
    final si = p.currentStepIndex;
    if (li == null || si == null) return null;
    if (li < 0 || li >= nav.legs.length) return null;
    final leg = nav.legs[li];
    if (si < 0 || si >= leg.steps.length) return null;
    return leg.steps[si];
  }

  NavigationLeg? get currentLeg {
    final nav = navigation;
    final p = progress;
    if (nav == null || p == null) return null;
    final li = p.currentLegIndex;
    if (li == null || li < 0 || li >= nav.legs.length) return null;
    return nav.legs[li];
  }

  /// True si el backend dice que el chofer no esta sobre la polyline.
  bool get fueraDeRuta => progress?.isOnRoute == false;
}

class NavegacionNotifier extends FamilyNotifier<NavegacionState, String> {
  Timer? _progressTimer;
  int _progressTicks = 0;
  bool _activo = false;

  static const Duration _intervaloProgress = Duration(seconds: 7);
  /// Cada cuantos ticks chequear si hubo recompute (re-fetch /navigation).
  /// Default ~30 ticks * 7s = 3.5 min. Cuando hay recompute por checkpoint
  /// reached, el backend devuelve el nuevo computed_at en /route-progress
  /// (cuando lo agreguen). Por ahora hacemos check periodico.
  static const int _ticksParaRecomputeCheck = 30;

  @override
  NavegacionState build(String tripId) {
    ref.onDispose(() {
      _activo = false;
      _progressTimer?.cancel();
    });
    return const NavegacionState();
  }

  /// Bootstrap: trae la nav inicial y arranca el polling de progress.
  Future<void> loadFor(String tripId) async {
    _activo = true;
    state = state.copyWith(loading: true, error: null);
    try {
      final nav = await _fetchNavigation(tripId);
      state = state.copyWith(
        navigation: nav,
        lastComputedAt: nav.computedAt,
        loading: false,
        error: null,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Navigation bootstrap error: $e');
      state = state.copyWith(loading: false, error: '$e');
      // Seguimos igual: el polling de progress puede al menos mostrar
      // is_on_route si el backend lo da.
    }
    _arrancarPolling(tripId);
    await _tickProgress(tripId);
  }

  Future<void> recargar(String tripId) => loadFor(tripId);

  void _arrancarPolling(String tripId) {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(
      _intervaloProgress,
      (_) => _tickProgress(tripId),
    );
  }

  Future<void> _tickProgress(String tripId) async {
    if (!_activo) return;
    try {
      final repo = ref.read(navigationRepoProvider);
      final progress = await repo.progreso(tripId);
      state = state.copyWith(progress: progress);
      _progressTicks++;
      if (_progressTicks % _ticksParaRecomputeCheck == 0) {
        await _verificarRecompute(tripId);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Progress tick error: $e');
      // tick fallido — reintenta en el proximo
    }
  }

  /// Pisar el state con un payload nuevo recibido en cliente
  /// (MC-021 — auto-reroute). El `RouteWatcher` llama esto despues
  /// de un POST `/navigation/recompute?start_lat=...&start_lon=...`
  /// exitoso. No hace fetch — el caller ya tiene el `TripNavigation`
  /// del response.
  void aplicarRecompute(TripNavigation nueva) {
    state = state.copyWith(
      navigation: nueva,
      lastComputedAt: nueva.computedAt,
      error: null,
    );
  }

  /// Re-fetch /navigation y compara `computed_at`. Si es nueva, actualiza.
  Future<void> _verificarRecompute(String tripId) async {
    try {
      final nav = await _fetchNavigation(tripId);
      final prev = state.lastComputedAt;
      if (prev == null || nav.computedAt.isAfter(prev)) {
        state = state.copyWith(
          navigation: nav,
          lastComputedAt: nav.computedAt,
        );
      }
    } catch (_) {
      // Best effort
    }
  }

  /// GET /navigation con fallback a recompute si devuelve 404.
  Future<TripNavigation> _fetchNavigation(String tripId) async {
    final repo = ref.read(navigationRepoProvider);
    try {
      return await repo.obtener(tripId);
    } on NavigationNoComputadaException {
      // Disparar recompute y reintentar una vez.
      state = state.copyWith(reintentando: true);
      try {
        await repo.recomputar(tripId);
        final nav = await repo.obtener(tripId);
        state = state.copyWith(reintentando: false);
        return nav;
      } catch (_) {
        state = state.copyWith(reintentando: false);
        rethrow;
      }
    }
  }
}

/// Resuelve el target prominente para el banner: el destino del leg actual,
/// o el destino final si no hay leg.
String? etiquetaDestinoActual(NavegacionState s) {
  final leg = s.currentLeg;
  if (leg != null) return leg.targetLabel;
  final ultimoLeg = s.navigation?.legs.isEmpty ?? true
      ? null
      : s.navigation!.legs.last;
  return ultimoLeg?.targetLabel;
}

/// Resuelve el primer destino "operativo" (proximo target) para el destino
/// fallback cuando no hay GPS todavia. Util para centrar el mapa al abrir.
({double lat, double lon, String etiqueta})? primerDestinoFallback({
  required Trip trip,
  required List<CheckpointInfo> checkpoints,
}) {
  for (final cp in checkpoints) {
    if (!cp.reached && cp.lat != null && cp.lon != null) {
      return (
        lat: cp.lat!,
        lon: cp.lon!,
        etiqueta: cp.name ?? 'Checkpoint ${cp.index + 1}',
      );
    }
  }
  if (trip.destinationLat != null && trip.destinationLon != null) {
    return (
      lat: trip.destinationLat!,
      lon: trip.destinationLon!,
      etiqueta: 'Destino final',
    );
  }
  return null;
}

/// Calcula el bearing (grados, 0 = norte) entre dos puntos.
double bearingEntrePuntos(double lat1, double lon1, double lat2, double lon2) {
  final phi1 = lat1 * math.pi / 180;
  final phi2 = lat2 * math.pi / 180;
  final lambda1 = lon1 * math.pi / 180;
  final lambda2 = lon2 * math.pi / 180;
  final y = math.sin(lambda2 - lambda1) * math.cos(phi2);
  final x = math.cos(phi1) * math.sin(phi2) -
      math.sin(phi1) * math.cos(phi2) * math.cos(lambda2 - lambda1);
  final theta = math.atan2(y, x);
  return (theta * 180 / math.pi + 360) % 360;
}
