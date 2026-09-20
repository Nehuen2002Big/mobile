// State del checklist de salida (MC-022).
//
// Mantiene el snapshot del checklist por tripId con tres responsabilidades:
//
//   1. Fetch inicial al `build()` (pull del GET /trips/{id}/checklist).
//   2. Toggle optimista: el chofer tilda → la UI cambia inmediato → POST
//      al backend → si falla por red, encolamos para reintentar luego;
//      si falla por permiso/estado, revertimos y reportamos.
//   3. Cola in-memory de items pendientes de sincronizar. Se vacia
//      automaticamente cuando un `refrescar()` exitoso confirma que
//      hay red.
//
// La cola es in-memory por decision deliberada: si el chofer cierra la
// app antes del flush, al reabrir se hace fetch limpio y ve el estado
// real del server. No vale la pena persistir 4 booleans a disco para
// cubrir el caso (raro) de "cerrar la app justo durante un blackout
// de red". Ver MC-022 plan para la justificacion.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../hoja_ruta/data/trip_exceptions.dart';
import '../models/trip_checklist.dart';

/// State expuesto al UI del checklist.
@immutable
class TripChecklistState {
  const TripChecklistState({
    required this.checklist,
    this.loading = false,
    this.error,
  });

  /// Snapshot actual. Para viajes recien cargados es `TripChecklist.empty`
  /// hasta que el primer fetch responda; despues queda sincronizado con
  /// las operaciones optimistas y los responses del backend.
  final TripChecklist checklist;

  /// `true` durante el primer fetch.
  final bool loading;

  /// Mensaje de error de la ultima operacion (fetch o toggle remoto que
  /// no fue por red). Se limpia en el proximo fetch/toggle exitoso. La
  /// UI lo expone como SnackBar via `ref.listen`.
  final String? error;

  TripChecklistState copyWith({
    TripChecklist? checklist,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return TripChecklistState(
      checklist: checklist ?? this.checklist,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier del checklist por trip.
///
/// Patron equivalente a `TripPauseNotifier` (family por tripId, fetch
/// en `build`, refresh manual). La diferencia es que aca el dueno de
/// la mutacion es el propio chofer en el dispositivo (no hay polling
/// programado — el unico refresh adicional es pull-to-refresh).
class TripChecklistNotifier
    extends FamilyNotifier<TripChecklistState, String> {
  /// Items que el chofer toco mientras no habia red. Cada entry es el
  /// estado deseado final (`true` = quiere tildar, `false` = quiere
  /// destildar). Se vacia cuando un refrescar exitoso confirma red.
  /// In-memory por decision; ver doc del archivo.
  final Map<String, bool> _pendientes = {};

  @override
  TripChecklistState build(String tripId) {
    Future.microtask(() => _refrescar(tripId));
    return TripChecklistState(
      checklist: TripChecklist.empty(tripId),
      loading: true,
    );
  }

  /// Pull-to-refresh y refresh post-fetch. Se llama tambien
  /// implicitamente despues de un toggle exitoso para incorporar
  /// cualquier cambio de meta (ej. checked_at del server).
  Future<void> refrescar(String tripId) => _refrescar(tripId);

  Future<void> _refrescar(String tripId) async {
    try {
      final repo = ref.read(tripsRepoProvider);
      final fresh = await repo.getChecklist(tripId);
      state = state.copyWith(
        checklist: fresh,
        loading: false,
        clearError: true,
      );
      // El fetch confirmo red. Aprovechamos a vaciar la cola en orden
      // (best-effort: si vuelve a caer la red, el item se mantiene en
      // la cola y se reintenta al proximo refresh).
      await _flushPendientes(tripId);
    } catch (e) {
      if (kDebugMode) debugPrint('TripChecklist fetch error: $e');
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  /// Toggle optimista del item identificado por [itemKey]. Si el server
  /// rechaza por red, el cambio queda en la cola y se ve tildado local
  /// hasta que se sincronice. Si rechaza por permiso/estado (403/404/
  /// 409), se revierte y se notifica via `state.error`.
  Future<void> toggle(String tripId, String itemKey) async {
    final current = state.checklist;
    final item = current.items.firstWhere(
      (it) => it.key == itemKey,
      orElse: () => const ChecklistItem(key: '', label: '', checked: false),
    );
    if (item.key.isEmpty) return; // item desconocido, no-op defensivo.

    final nuevoChecked = !item.checked;
    // 1) Actualizacion optimista (UI inmediata).
    final itemOptimista = item.copyWith(
      checked: nuevoChecked,
      // Stamps locales provisorios; el server pisa con valores reales en el
      // refresh subsiguiente o en la respuesta del POST.
      checkedAt: nuevoChecked ? DateTime.now().toUtc() : null,
      clearMeta: !nuevoChecked,
    );
    state = state.copyWith(
      checklist: current.withItem(itemOptimista),
      clearError: true,
    );

    // 2) POST al backend.
    final repo = ref.read(tripsRepoProvider);
    try {
      final actualizado = nuevoChecked
          ? await repo.checkChecklistItem(tripId: tripId, itemKey: itemKey)
          : await repo.uncheckChecklistItem(tripId: tripId, itemKey: itemKey);
      // Reemplazamos el optimista con la respuesta autoritativa del server.
      state = state.copyWith(
        checklist: state.checklist.withItem(actualizado),
        clearError: true,
      );
      _pendientes.remove(itemKey);
    } on ChecklistNoAutorizadoException catch (e) {
      _revertir(itemKey, item, mensaje: e.message);
    } on ChecklistItemNoEncontradoException catch (e) {
      _revertir(itemKey, item, mensaje: e.message);
      // Forzamos refresh: el item posiblemente fue borrado/reasignado
      // del lado backend.
      unawaited(_refrescar(tripId));
    } on ChecklistTripCerradoException catch (e) {
      _revertir(itemKey, item, mensaje: e.message);
      // El trip ya esta cerrado: descartamos toda la cola — nada que
      // sincronizar — y refrescamos para mostrar el estado final
      // read-only.
      _pendientes.clear();
      unawaited(_refrescar(tripId));
    } catch (e) {
      // Falla de red (timeout, sin conexion, 5xx). Dejamos el tilde
      // optimista visible y encolamos para reintentar al proximo
      // refresh. No marcamos `state.error` para no interrumpir al
      // chofer — la realidad visual ya muestra el item como tildado.
      _pendientes[itemKey] = nuevoChecked;
      if (kDebugMode) debugPrint('TripChecklist toggle queued: $e');
    }
  }

  void _revertir(
    String itemKey,
    ChecklistItem snapshotPrevio, {
    required String mensaje,
  }) {
    state = state.copyWith(
      checklist: state.checklist.withItem(snapshotPrevio),
      error: mensaje,
    );
    _pendientes.remove(itemKey);
  }

  Future<void> _flushPendientes(String tripId) async {
    if (_pendientes.isEmpty) return;
    final repo = ref.read(tripsRepoProvider);
    // Copia para iterar sin race: cada toggle exitoso elimina su entry
    // de _pendientes via la firma del try.
    final entries = Map<String, bool>.from(_pendientes);
    for (final entry in entries.entries) {
      try {
        final actualizado = entry.value
            ? await repo.checkChecklistItem(
                tripId: tripId,
                itemKey: entry.key,
              )
            : await repo.uncheckChecklistItem(
                tripId: tripId,
                itemKey: entry.key,
              );
        state = state.copyWith(
          checklist: state.checklist.withItem(actualizado),
        );
        _pendientes.remove(entry.key);
      } on ChecklistTripCerradoException {
        // Trip cerrado mientras estabamos offline: descartamos toda la
        // cola y dejamos que el siguiente refresh muestre el estado
        // final.
        _pendientes.clear();
        return;
      } catch (e) {
        // Sigue sin red o el server rechazo por otra cosa puntual.
        // Mantenemos el item en la cola — proximo refresh reintenta.
        if (kDebugMode) debugPrint('TripChecklist flush error: $e');
      }
    }
  }
}
