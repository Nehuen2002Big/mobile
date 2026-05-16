import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../models/trip_pause_status.dart';

/// State del banner de pausa del viaje (MC-015).
///
/// `secondsRemaining` se recalcula localmente cada 1 s desde
/// [TripPauseStatus.endsAt] para que el countdown decremente fluido sin
/// esperar al proximo poll de 30 s. Cuando llega a 0 disparamos un
/// poll extra para confirmar `paused: false` y ocultar el banner sin
/// esperar al siguiente tick programado.
@immutable
class TripPauseState {
  const TripPauseState({
    this.status,
    this.secondsRemaining = 0,
    this.loading = false,
    this.ending = false,
    this.error,
  });

  /// `null` mientras no hubo primer poll. Una vez que respondio el
  /// server, queda con `paused: true|false` segun corresponda.
  final TripPauseStatus? status;

  /// Segundos calculados localmente desde `status.endsAt`. Es lo que
  /// muestra el countdown del banner.
  final int secondsRemaining;

  /// `true` durante el primer fetch.
  final bool loading;

  /// `true` mientras esta en vuelo el POST `/pause/end` (boton
  /// "Despausar ahora").
  final bool ending;

  /// Mensaje de error de la ultima operacion (poll o end). El banner lo
  /// muestra como SnackBar via `ref.listen` y se limpia en el siguiente
  /// poll exitoso.
  final String? error;

  bool get paused => status?.paused == true;
  String? get type => status?.type;

  TripPauseState copyWith({
    TripPauseStatus? status,
    bool clearStatus = false,
    int? secondsRemaining,
    bool? loading,
    bool? ending,
    String? error,
    bool clearError = false,
  }) {
    return TripPauseState(
      status: clearStatus ? null : (status ?? this.status),
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      loading: loading ?? this.loading,
      ending: ending ?? this.ending,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Polea `/trips/{id}/pause/status` cada 30 s y mantiene un ticker
/// local de 1 Hz que decrementa el countdown sin esperar al server.
///
/// Patron equivalente al `PendingActionNotifier` (timer + family por
/// tripId), con la suma del ticker para fluidez visual.
class TripPauseNotifier extends FamilyNotifier<TripPauseState, String> {
  Timer? _pollTimer;
  Timer? _tickTimer;

  /// Frecuencia del poll al backend. El countdown visual no depende de
  /// esto — corre con el ticker local de 1 Hz.
  static const Duration _pollInterval = Duration(seconds: 30);

  @override
  TripPauseState build(String tripId) {
    ref.onDispose(() {
      _pollTimer?.cancel();
      _pollTimer = null;
      _tickTimer?.cancel();
      _tickTimer = null;
    });
    Future.microtask(() => _arrancar(tripId));
    return const TripPauseState(loading: true);
  }

  void _arrancar(String tripId) {
    _refrescar(tripId);
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _refrescar(tripId));
  }

  /// Forzar un poll inmediato. Llamarlo desde callsites externos cuando
  /// pasa algo que invalida el cache (ej. el chofer creo una alerta de
  /// descanso y queremos ver el banner sin esperar 30 s).
  Future<void> refrescar(String tripId) => _refrescar(tripId);

  Future<void> _refrescar(String tripId) async {
    try {
      final repo = ref.read(tripsRepoProvider);
      final status = await repo.pauseStatus(tripId);
      state = state.copyWith(
        status: status,
        secondsRemaining: _calcRemaining(status),
        loading: false,
        clearError: true,
      );
      _resyncTicker(tripId);
    } catch (e) {
      if (kDebugMode) debugPrint('TripPause poll error: $e');
      // Conservamos el ultimo `status` cacheado — el ticker sigue
      // corriendo offline. Solo seteamos error como informativo.
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  /// Reaccion al cambio de `paused`: arranca o detiene el ticker local
  /// segun corresponda. Idempotente.
  void _resyncTicker(String tripId) {
    if (state.paused) {
      _tickTimer ??= Timer.periodic(
        const Duration(seconds: 1),
        (_) => _onTick(tripId),
      );
    } else {
      _tickTimer?.cancel();
      _tickTimer = null;
    }
  }

  void _onTick(String tripId) {
    final status = state.status;
    if (status == null || !status.paused) {
      _tickTimer?.cancel();
      _tickTimer = null;
      return;
    }
    final remaining = _calcRemaining(status);
    final cruzoCero = state.secondsRemaining > 0 && remaining <= 0;
    state = state.copyWith(secondsRemaining: remaining);
    if (cruzoCero) {
      // Llegamos a 0 localmente — disparamos un poll extra para
      // confirmar `paused: false` del lado server (cleanup lazy del
      // backend) y ocultar el banner sin esperar 30 s.
      _refrescar(tripId);
    }
  }

  static int _calcRemaining(TripPauseStatus status) {
    if (!status.paused) return 0;
    final endsAt = status.endsAt;
    if (endsAt == null) return status.secondsRemaining ?? 0;
    final diff = endsAt.difference(DateTime.now().toUtc()).inSeconds;
    return diff < 0 ? 0 : diff;
  }

  /// Cancela la pausa anticipadamente. UX optimista: ocultamos el
  /// banner inmediato y, si el POST falla, restauramos el snapshot.
  Future<bool> endPause(String tripId) async {
    if (!state.paused) return true;
    final snapshot = state;
    state = state.copyWith(
      status: TripPauseStatus(tripId: tripId, paused: false),
      secondsRemaining: 0,
      ending: true,
      clearError: true,
    );
    _tickTimer?.cancel();
    _tickTimer = null;
    try {
      final repo = ref.read(tripsRepoProvider);
      final res = await repo.endPause(tripId);
      state = state.copyWith(
        status: res,
        secondsRemaining: _calcRemaining(res),
        ending: false,
      );
      _resyncTicker(tripId);
      return true;
    } catch (e) {
      // Restauramos: el chofer ve que la pausa sigue y puede reintentar.
      state = snapshot.copyWith(
        ending: false,
        error: 'No se pudo cancelar la pausa, reintentá',
      );
      _resyncTicker(tripId);
      return false;
    }
  }
}
