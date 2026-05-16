import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/providers.dart';
import '../models/tracking_alert.dart';

part 'pending_action_state.freezed.dart';

@freezed
class PendingActionState with _$PendingActionState {
  const PendingActionState._();

  const factory PendingActionState({
    @Default([]) List<TrackingAlert> items,
    @Default(0) int total,
    @Default(false) bool loading,
    @Default(false) acking,
    String? error,
  }) = _PendingActionState;

  bool get hayPendientes => items.isNotEmpty;
  bool get hayL3 => items.any((a) => a.esL3);
}

/// Polea las alertas L2/L3 pendientes de acknowledge. Se ejecuta mientras
/// el chofer esta en el detalle del viaje activo. Al hacer ack, invalida
/// el state y refetcha.
class PendingActionNotifier
    extends FamilyNotifier<PendingActionState, String> {
  Timer? _timer;

  static const Duration _intervalo = Duration(seconds: 12);

  @override
  PendingActionState build(String tripId) {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    Future.microtask(() => _arrancar(tripId));
    return const PendingActionState(loading: true);
  }

  void _arrancar(String tripId) {
    _refrescar(tripId);
    _timer?.cancel();
    _timer = Timer.periodic(_intervalo, (_) => _refrescar(tripId));
  }

  Future<void> refrescar(String tripId) => _refrescar(tripId);

  Future<void> _refrescar(String tripId) async {
    try {
      final repo = ref.read(alertasRepoProvider);
      final res = await repo.pendingAction(tripId);
      state = state.copyWith(
        items: res.items,
        total: res.total,
        loading: false,
        error: null,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('PendingAction fetch error: $e');
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  /// Envia POST /alerts/acknowledge con todos los ids dados.
  ///
  /// **Estrategia optimista**: ocultamos el banner ANTES del POST
  /// (items=[], total=0). Si el POST falla, restauramos el snapshot
  /// previo para que la UI vuelva a mostrar el banner sin esperar
  /// 12s al proximo poll. En el camino exitoso, el `_refrescar` final
  /// confirma con la verdad del backend (que tambien cancela toda la
  /// cascada — los proximos `[LLAMADA]/[ACCION REQUERIDA]` no salen
  /// del lado server).
  Future<bool> acknowledge(String tripId, List<int> ids) async {
    if (ids.isEmpty) return false;
    final snapshot = state;
    state = state.copyWith(
      items: const [],
      total: 0,
      acking: true,
      error: null,
    );
    try {
      final repo = ref.read(alertasRepoProvider);
      await repo.acknowledge(ids);
      await _refrescar(tripId);
      state = state.copyWith(acking: false);
      return true;
    } catch (e) {
      // Restaurar para que el chofer vea que sigue pendiente.
      state = snapshot.copyWith(acking: false, error: '$e');
      return false;
    }
  }

  /// Ack especifico para alertas `SIN_SENAL + MOVEMENT_DURING_PAUSE`
  /// (MC-016). El chofer responde "¿Fuiste vos manejando?":
  ///
  ///   - `fueElChofer == true` ("Sí, fui yo"): solo POST de ack. La
  ///     pausa ya fue cancelada del lado backend; el chofer cierra
  ///     la cascada y sigue su viaje normal.
  ///   - `fueElChofer == false` ("No fui yo — alertar"): POST de ack
  ///     + posteo al chat con prefijo `[CHOFER · ALERTA ROBO]` para
  ///     que el operador reciba la novedad inmediato. Si el backend
  ///     auto-acka L2/L3 cuando el chofer postea al chat (MC-006),
  ///     el ack explicito puede ser redundante — lo mandamos igual
  ///     para no depender del ordering.
  ///
  /// Estrategia optimista igual que [acknowledge]: removemos los ids
  /// dados del state ANTES de los POST. Si alguno falla, restauramos
  /// snapshot.
  Future<bool> acknowledgeMovementDuringPause(
    String tripId,
    List<int> ids, {
    required bool fueElChofer,
  }) async {
    if (ids.isEmpty) return false;
    final snapshot = state;
    final restantes = state.items.where((a) => !ids.contains(a.id)).toList();
    state = state.copyWith(
      items: restantes,
      total: restantes.length,
      acking: true,
      error: null,
    );
    try {
      // Si "no fui yo", postear primero la alerta de robo al chat.
      // Si el chat falla, abortamos sin hacer ack — el chofer puede
      // reintentar para que el operador efectivamente se entere.
      if (!fueElChofer) {
        final chatRepo = ref.read(chatRepoProvider);
        final perfil = ref.read(authNotifierProvider).perfil;
        final senderName = perfil?.person.nombreCompleto;
        await chatRepo.enviar(
          tripId: tripId,
          content: '[CHOFER · ALERTA ROBO] Reporto movimiento no autorizado',
          senderName:
              (senderName ?? '').isEmpty ? null : senderName,
        );
      }
      final alertasRepo = ref.read(alertasRepoProvider);
      await alertasRepo.acknowledge(ids);
      await _refrescar(tripId);
      state = state.copyWith(acking: false);
      return true;
    } catch (e) {
      state = snapshot.copyWith(acking: false, error: '$e');
      return false;
    }
  }
}
