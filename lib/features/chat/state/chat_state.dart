import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/providers.dart';
import '../../alertas/data/notificaciones_alertas.dart';
import '../../alertas/data/prefijos_alerta.dart';
import '../data/chat_repository.dart';
import '../models/trip_message.dart';
import 'operator_directive.dart';

part 'chat_state.freezed.dart';

/// Ventana de race protection: cuando el chofer ackea, mensajes
/// `[LLAMADA · ...]` o `[ACCION REQUERIDA · ...]` con un alertId ya
/// ackeado que llegan en este lapso son ignorados (estaban en vuelo
/// del paso anterior de la cascada y solo causarian re-disparar la
/// fake-call por nada). Despues del lapso, los mensajes se procesan
/// normal — pero el render del chat sigue marcandolos como Resueltos
/// porque el alertId vive en el map de `alertasAcked` por toda la
/// sesion (ver `ChatState.alertasAcked`).
const Duration kVentanaAckRace = Duration(seconds: 5);

/// Estado del chat por trip.
@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<TripMessage> items,
    @Default(0) int unreadForDriver,
    int? lastId,
    @Default(false) bool loading,
    @Default(false) bool sending,
    String? error,
    /// Mensaje de tipo `[LLAMADA · ...]` recien recibido que la UI debe
    /// disparar como pantalla fake-call. Una vez consumido, se limpia con
    /// `marcarLlamadaConsumida()`.
    TripMessage? pendingCall,
    /// Map de alertIds que el chofer ya ackeo localmente, junto con el
    /// timestamp del ack. Se usa para:
    /// 1) **Race protection (ventana 5s)**: ignorar mensajes con un
    ///    alertId ya ackeado que llegan en este lapso (estaban en
    ///    vuelo del paso anterior de la cascada y dispararian la
    ///    fake-call por nada). Despues de 5s, los mensajes se
    ///    procesan normal; el alertId queda en el map permanentemente.
    /// 2) **Render visual**: el chat muestra mensajes con `msg.alertId`
    ///    en este map como "✓ Resuelto" durante toda la sesion (sin
    ///    TTL — el chofer ve la confirmacion visual del ack).
    @Default(<int, DateTime>{}) Map<int, DateTime> alertasAcked,
  }) = _ChatState;
}

/// Notifier parametrizado por tripId. Arranca polling cada 3s al abrir y se
/// limpia solo via ref.onDispose.
class ChatNotifier extends FamilyNotifier<ChatState, String> {
  Timer? _pollTimer;
  bool _fetchInFlight = false;

  @override
  ChatState build(String tripId) {
    ref.onDispose(() {
      _pollTimer?.cancel();
      _pollTimer = null;
    });
    // Carga inicial + arranque de polling.
    Future.microtask(() async {
      await _fetchFull(tripId);
      _pollTimer ??= Timer.periodic(
        const Duration(seconds: 3),
        (_) => _fetchDelta(tripId),
      );
    });
    return const ChatState(loading: true);
  }

  ChatRepository get _repo => ref.read(chatRepoProvider);

  String? get _driverName {
    final perfil = ref.read(authNotifierProvider).perfil;
    if (perfil == null) return null;
    final n = perfil.person.nombreCompleto;
    return n.isEmpty ? null : n;
  }

  Future<void> _fetchFull(String tripId) async {
    if (_fetchInFlight) return;
    _fetchInFlight = true;
    try {
      final resp = await _repo.listar(tripId);
      state = state.copyWith(
        items: resp.items,
        unreadForDriver: resp.unreadForDriver,
        lastId: resp.items.isEmpty ? null : resp.items.last.id,
        loading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
    } finally {
      _fetchInFlight = false;
    }
  }

  Future<void> _fetchDelta(String tripId) async {
    if (_fetchInFlight) return;
    _fetchInFlight = true;
    try {
      final lastId = state.lastId;
      final resp = await _repo.listar(tripId, afterId: lastId);
      if (resp.items.isEmpty) {
        // Igual actualizo el contador de unread (el monitor puede haber leido).
        if (resp.unreadForDriver != state.unreadForDriver ||
            resp.unreadForMonitor != 0) {
          state = state.copyWith(unreadForDriver: resp.unreadForDriver);
        }
        return;
      }
      // Filtrar mensajes en la VENTANA de race (5s desde el ack). Los
      // mensajes mas viejos con un alertId ackeado **se incluyen** en
      // el chat (es historico legitimo: el chofer ackeo, llego un
      // mensaje viejo al cabo de 10s; queremos verlo en el log con su
      // badge "Resuelto"). Solo dropeamos los que llegan justo despues
      // del ack — esos serian retransmisiones de la cascada que el
      // backend ya canceló.
      final ackedMap = state.alertasAcked;
      final now = DateTime.now();
      final filtrados = resp.items.where((m) {
        final id = m.alertId;
        if (id == null) return true;
        final ackedAt = ackedMap[id];
        if (ackedAt == null) return true;
        // Si esta dentro de la ventana de race, dropear silencioso.
        return now.difference(ackedAt) >= kVentanaAckRace;
      }).toList();
      final merged = [...state.items, ...filtrados];
      // Copia mutable para acumular ack-locales que detectemos en el
      // loop de abajo (ATENDIDO del operador, etc). Se persiste al
      // final del fetch via state.copyWith.
      final ackedActualizado = <int, DateTime>{...ackedMap};
      // Detectar mensajes nuevos del MONITOR. Para cada uno disparamos la
      // notificacion del SO apropiada (chat normal, alerta urgente, o
      // llamada). Tambien guardamos el ultimo `[LLAMADA · ...]` para
      // dispararo el fake-call mientras la app esta en foreground.
      TripMessage? llamada = state.pendingCall;
      for (final m in filtrados) {
        if (m.senderRole.toUpperCase() != 'MONITOR') continue;
        final parsed = parsearPrefijoCascada(m.content);
        // [ATENDIDO ...] — el operador ya ack-eo la alerta desde el bell
        // de la web. Audit-log: lo dejamos en la lista del chat (con
        // render atenuado en chat_screen) pero NO sonamos / vibramos /
        // mostramos heads-up. La alerta a la que refiere ya esta
        // resuelta del lado server, asi que tampoco abrimos fake-call
        // ni banner. Si el alertId esta seteado, lo agregamos al map
        // de ackeados localmente para que un mensaje rezagado de la
        // cascada con el mismo id se filtre o se renderee como Resuelto.
        if (parsed?.tipo == TipoCascada.atendido) {
          final aId = m.alertId;
          if (aId != null && !ackedActualizado.containsKey(aId)) {
            // Si el operador ackeo desde la web, anotamos el alertId
            // localmente para que: (a) un eventual mensaje de la
            // cascada que llegue rezagado se filtre por el filtro de
            // race, y (b) la burbuja del mensaje original tenga el
            // badge "Resuelto" en el render del chat.
            ackedActualizado[aId] = DateTime.now();
          }
          continue;
        }
        // Mensajes de sistema sobre lifecycle de viajes (MC-017). NO
        // disparan cascada, pending-action ni fake-call — son
        // informativos puros. La diferencia entre los 3 prefijos esta
        // en titulo, sonido (silencioso para EN COLA) y deep-link
        // del tap (LISTO va al detalle del viaje, no al chat).
        if (parsed?.tipo == TipoCascada.viajeAsignado) {
          unawaited(NotificacionesAlertas.instance.dispararChat(
            id: m.id,
            titulo: 'Viaje asignado',
            cuerpo: parsed!.contenidoLimpio.isNotEmpty
                ? parsed.contenidoLimpio
                : m.content,
            tripId: tripId,
          ));
          continue;
        }
        if (parsed?.tipo == TipoCascada.viajeEnCola) {
          unawaited(NotificacionesAlertas.instance.dispararChat(
            id: m.id,
            titulo: 'Viaje en cola',
            cuerpo: parsed!.contenidoLimpio.isNotEmpty
                ? parsed.contenidoLimpio
                : m.content,
            tripId: tripId,
            silencioso: true,
          ));
          continue;
        }
        if (parsed?.tipo == TipoCascada.viajeListo) {
          unawaited(NotificacionesAlertas.instance.dispararChat(
            id: m.id,
            titulo: 'Viaje listo para arrancar',
            cuerpo: parsed!.contenidoLimpio.isNotEmpty
                ? parsed.contenidoLimpio
                : m.content,
            tripId: tripId,
            kind: 'trip-ready',
          ));
          continue;
        }
        // Directiva preset del operador (MC-018). Setea el provider
        // global para que el overlay arriba de toda la UI muestre el
        // banner con vibracion corta + sonido suave. La notif del SO
        // tambien sale para el caso "app cerrada / otra pantalla".
        if (parsed?.tipo == TipoCascada.directivaOperador) {
          final label = parsed!.regla;
          ref.read(pendingOperatorDirectiveProvider.notifier).state =
              OperatorDirective(
            messageId: m.id,
            tripId: tripId,
            label: label,
            content: parsed.contenidoLimpio,
          );
          unawaited(NotificacionesAlertas.instance.dispararChat(
            id: m.id,
            titulo: label.isEmpty
                ? 'Mensaje del operador'
                : 'Mensaje del operador · $label',
            cuerpo: parsed.contenidoLimpio.isNotEmpty
                ? parsed.contenidoLimpio
                : label,
            tripId: tripId,
            kind: 'operator-directive',
          ));
          continue;
        }
        // Mensaje libre del monitor o L1/SUPERVISOR (informativos): notif
        // del canal "chat" — sonido suave tipo WhatsApp, tap → chat.
        if (parsed == null ||
            parsed.tipo == TipoCascada.aviso ||
            parsed.tipo == TipoCascada.supervisorInformado) {
          unawaited(_dispararNotifChat(m, tripId, parsed));
          continue;
        }
        // Defensa adicional: si el alertId ya esta en el map (aunque
        // fuera de la ventana de race) NO disparar fake-call ni notif
        // urgente — el chofer ya respondio. El mensaje igual aparece
        // en el chat con su badge Resuelto.
        final aId = m.alertId;
        final yaAckeado = aId != null && ackedMap.containsKey(aId);
        // L2/L3: notif urgente, tap → pantalla del viaje (donde esta el
        // banner persistente con el boton "Recibido").
        if (parsed.tipo == TipoCascada.accionRequerida ||
            parsed.tipo == TipoCascada.escaladoSupervisor) {
          if (yaAckeado) continue;
          unawaited(_dispararNotifAlerta(m, parsed, tripId));
          continue;
        }
        // Llamada: notif full-screen, tap → fake-call directo. Si el
        // alertId ya esta ackeado, no re-disparamos el fake-call.
        if (parsed.tipo == TipoCascada.llamada) {
          if (yaAckeado) continue;
          unawaited(_dispararNotifAlerta(m, parsed, tripId));
          llamada = m;
        }
      }
      state = state.copyWith(
        items: merged,
        unreadForDriver: resp.unreadForDriver,
        lastId: resp.items.last.id,
        pendingCall: llamada,
        // Si en este batch detectamos algun [ATENDIDO ...] del operador,
        // los IDs quedaron en `ackedActualizado` y los persistimos para
        // que el render del chat marque las burbujas correspondientes
        // como Resueltas y el filtro de race los siga ignorando.
        alertasAcked: ackedActualizado,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Chat delta error: $e');
    } finally {
      _fetchInFlight = false;
    }
  }

  Future<void> refrescar(String tripId) => _fetchFull(tripId);

  Future<bool> enviar(String tripId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.length > 2000) {
      state = state.copyWith(error: 'Mensaje demasiado largo (max 2000)');
      return false;
    }
    state = state.copyWith(sending: true, error: null);
    try {
      final msg = await _repo.enviar(
        tripId: tripId,
        content: trimmed,
        senderName: _driverName,
      );
      state = state.copyWith(
        items: [...state.items, msg],
        lastId: msg.id,
        sending: false,
      );
      // El backend auto-ackea las alertas L2/L3 cuando el chofer postea
      // un mensaje (sender_role=DRIVER). Disparamos un tick inmediato
      // del polling de pending-action para que el banner desaparezca
      // sin esperar hasta 12s al proximo poll regular. Es fire-and-forget
      // — si falla el GET, el polling regular lo va a reflejar igual.
      try {
        unawaited(
          ref
              .read(pendingActionNotifierProvider(tripId).notifier)
              .refrescar(tripId),
        );
      } catch (_) {
        // Si el provider no esta vivo (caso raro: chofer mando mensaje
        // sin haber abierto el viaje), ignoramos.
      }
      return true;
    } catch (e) {
      state = state.copyWith(sending: false, error: '$e');
      return false;
    }
  }

  Future<void> marcarTodoLeido(String tripId) async {
    if (state.unreadForDriver == 0) return;
    try {
      await _repo.marcarLeidos(tripId);
      state = state.copyWith(unreadForDriver: 0);
      // Re-fetch full para actualizar read_at en mensajes propios.
      await _fetchFull(tripId);
    } catch (e) {
      if (kDebugMode) debugPrint('Chat markRead error: $e');
    }
  }

  void limpiarError() {
    state = state.copyWith(error: null);
  }

  Future<void> _dispararNotifAlerta(
    TripMessage m,
    CascadaTagParsed parsed,
    String tripId,
  ) async {
    try {
      final urgente = parsed.tipo == TipoCascada.llamada ||
          parsed.tipo == TipoCascada.escaladoSupervisor;
      final titulo = parsed.tipo == TipoCascada.llamada
          ? 'Llamada del monitoreo'
          : parsed.tipo == TipoCascada.escaladoSupervisor
              ? 'Escalado a supervisor — ${parsed.regla}'
              : 'Acción requerida — ${parsed.regla}';
      await NotificacionesAlertas.instance.dispararAlerta(
        id: m.id,
        titulo: titulo,
        cuerpo: parsed.contenidoLimpio.isNotEmpty
            ? parsed.contenidoLimpio
            : m.content,
        urgente: urgente,
        esLlamada: parsed.tipo == TipoCascada.llamada,
        tripId: tripId,
        alertId: m.alertId,
        regla: parsed.regla,
        contenido: parsed.contenidoLimpio,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Notif alerta fallo: $e');
    }
  }

  Future<void> _dispararNotifChat(
    TripMessage m,
    String tripId,
    CascadaTagParsed? parsed,
  ) async {
    try {
      final name = (m.senderName ?? '').trim();
      String titulo;
      String cuerpo;
      if (parsed?.tipo == TipoCascada.aviso) {
        titulo = 'Aviso — ${parsed!.regla}';
        cuerpo = parsed.contenidoLimpio.isNotEmpty
            ? parsed.contenidoLimpio
            : m.content;
      } else if (parsed?.tipo == TipoCascada.supervisorInformado) {
        titulo = 'Supervisor notificado';
        cuerpo = parsed!.contenidoLimpio.isNotEmpty
            ? parsed.contenidoLimpio
            : m.content;
      } else {
        titulo = name.isEmpty ? 'Mensaje del monitoreo' : name;
        cuerpo = m.content;
      }
      await NotificacionesAlertas.instance.dispararChat(
        id: m.id,
        titulo: titulo,
        cuerpo: cuerpo,
        tripId: tripId,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Notif chat fallo: $e');
    }
  }

  /// Limpia el mensaje pendiente de fake-call para que la UI no lo abra
  /// dos veces. Llamado por la pantalla del viaje despues de navegar al
  /// fake-call.
  void marcarLlamadaConsumida() {
    if (state.pendingCall == null) return;
    state = state.copyWith(pendingCall: null);
  }

  /// Registra alertIds que el chofer acaba de acknowledgear con su
  /// timestamp. Sirve para:
  /// (a) **Race window 5s**: dropear mensajes con esos alertIds que
  ///     lleguen en los proximos 5s (estaban en vuelo del paso
  ///     anterior de la cascada — la fake-call ya cerro).
  /// (b) **Render visual**: burbujas con `msg.alertId` en este map se
  ///     renderean como "✓ Resuelto" durante toda la sesion (sin TTL).
  void marcarAlertasAcked(Set<int> ids) {
    if (ids.isEmpty) return;
    final now = DateTime.now();
    final nuevoMap = <int, DateTime>{
      ...state.alertasAcked,
      for (final id in ids) id: now,
    };
    state = state.copyWith(
      alertasAcked: nuevoMap,
      // Si la llamada pendiente apunta a una alerta ackeada, limpiarla.
      pendingCall:
          ids.contains(state.pendingCall?.alertId) ? null : state.pendingCall,
    );
  }
}
