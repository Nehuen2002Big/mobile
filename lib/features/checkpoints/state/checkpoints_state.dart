import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/providers.dart';
import '../../uploads/models/checkpoint_evidence.dart';
import '../data/checkpoints_repository.dart';
import '../models/checkpoint_info.dart';
import '../models/checkpoint_reach_request.dart';
import '../models/checkpoint_reach_response.dart';

part 'checkpoints_state.freezed.dart';

@freezed
class CheckpointsState with _$CheckpointsState {
  const factory CheckpointsState({
    @Default([]) List<CheckpointInfo> checkpoints,
    int? nextCheckpointIndex,
    @Default(0) int reachedCount,
    @Default(0) int total,
    @Default(false) bool loading,
    @Default(false) bool marking,
    String? error,
  }) = _CheckpointsState;
}

class CheckpointsNotifier extends FamilyNotifier<CheckpointsState, String> {
  Timer? _pollTimer;
  bool _fetchInFlight = false;

  @override
  CheckpointsState build(String tripId) {
    ref.onDispose(() {
      _pollTimer?.cancel();
      _pollTimer = null;
    });
    Future.microtask(() async {
      await _fetch(tripId);
      _pollTimer ??= Timer.periodic(
        const Duration(seconds: 10),
        (_) => _fetch(tripId),
      );
    });
    return const CheckpointsState(loading: true);
  }

  CheckpointsRepository get _repo => ref.read(checkpointsRepoProvider);

  Future<void> _fetch(String tripId) async {
    if (_fetchInFlight) return;
    _fetchInFlight = true;
    try {
      final resp = await _repo.listar(tripId);
      state = state.copyWith(
        checkpoints: resp.checkpoints,
        nextCheckpointIndex: resp.nextCheckpointIndex,
        reachedCount: resp.reachedCount,
        total: resp.total,
        loading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
      if (kDebugMode) debugPrint('Checkpoints fetch error: $e');
    } finally {
      _fetchInFlight = false;
    }
  }

  Future<void> refrescar(String tripId) => _fetch(tripId);

  /// Marca un checkpoint. Lanza la excepcion hacia arriba para que la UI
  /// muestre dialogs especificos (CheckpointLejosException, etc).
  Future<CheckpointReachResponse> marcar({
    required String tripId,
    required int index,
    required double lat,
    required double lon,
    String? notes,
    List<CheckpointEvidence> evidences = const [],
  }) async {
    state = state.copyWith(marking: true, error: null);
    try {
      final res = await _repo.marcarLlegada(
        tripId: tripId,
        index: index,
        payload: CheckpointReachRequest(
          lat: lat,
          lon: lon,
          notes: notes?.isEmpty ?? true ? null : notes,
          evidences: evidences,
        ),
      );
      await _fetch(tripId);
      state = state.copyWith(marking: false);
      return res;
    } catch (e) {
      state = state.copyWith(marking: false, error: '$e');
      rethrow;
    }
  }

  void limpiarError() => state = state.copyWith(error: null);
}
