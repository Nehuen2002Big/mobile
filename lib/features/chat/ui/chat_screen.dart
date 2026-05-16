import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers.dart';
import '../../alertas/data/alert_styles.dart';
import '../../alertas/data/prefijos_alerta.dart';
import '../../alertas/ui/pending_action_banner.dart';
import '../../uploads/ui/auth_image.dart';
import '../models/message_alert_ref.dart';
import '../models/trip_message.dart';
import '../state/chat_state.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  final _scroll = ScrollController();
  final _inputCtrl = TextEditingController();
  final _inputFocus = FocusNode();
  bool _userScrolledUp = false;
  int _nuevosDesdeUltimoView = 0;
  int _ultimoCountVisto = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scroll.addListener(_onScroll);
    // Marcar como leidos al abrir.
    Future.microtask(() {
      ref
          .read(chatNotifierProvider(widget.tripId).notifier)
          .marcarTodoLeido(widget.tripId);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
          .read(chatNotifierProvider(widget.tripId).notifier)
          .marcarTodoLeido(widget.tripId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _inputCtrl.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final atBottom = _scroll.position.pixels >=
        _scroll.position.maxScrollExtent - 60;
    if (atBottom && _userScrolledUp) {
      setState(() {
        _userScrolledUp = false;
        _nuevosDesdeUltimoView = 0;
      });
    } else if (!atBottom && !_userScrolledUp) {
      setState(() => _userScrolledUp = true);
    }
  }

  void _scrollToEnd({bool animated = true}) {
    if (!_scroll.hasClients) return;
    final target = _scroll.position.maxScrollExtent;
    if (animated) {
      _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  Future<void> _enviar() async {
    final text = _inputCtrl.text;
    if (text.trim().isEmpty) return;
    final notifier = ref.read(chatNotifierProvider(widget.tripId).notifier);
    final ok = await notifier.enviar(widget.tripId, text);
    if (!mounted) return;
    if (ok) {
      _inputCtrl.clear();
      // Dejar que llegue el estado nuevo y scrollear al final.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(chatNotifierProvider(widget.tripId));

    // Mostrar errores como SnackBar.
    ref.listen(chatNotifierProvider(widget.tripId), (prev, next) {
      final err = next.error;
      if (err != null && err != prev?.error) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(err)));
        ref
            .read(chatNotifierProvider(widget.tripId).notifier)
            .limpiarError();
      }
      // Auto-scroll si llegaron mensajes y estoy al final.
      final prevLast = prev?.lastId ?? 0;
      final nextLast = next.lastId ?? 0;
      if (nextLast > prevLast) {
        if (!_userScrolledUp) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
        } else {
          final nuevos = next.items.length - _ultimoCountVisto;
          setState(() => _nuevosDesdeUltimoView = nuevos.clamp(0, 999));
        }
        _ultimoCountVisto = next.items.length;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chat'),
            Text(
              widget.tripId,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refrescar',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(chatNotifierProvider(widget.tripId).notifier)
                .refrescar(widget.tripId),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner persistente: si hay alertas L2/L3 sin ack, las muestra
          // arriba del chat tambien (no solo en la pantalla del viaje).
          PendingActionBanner(tripId: widget.tripId),
          Expanded(
            child: _buildList(st),
          ),
          _Composer(
            controller: _inputCtrl,
            focusNode: _inputFocus,
            sending: st.sending,
            onSend: _enviar,
          ),
        ],
      ),
      floatingActionButton: _userScrolledUp && _nuevosDesdeUltimoView > 0
          ? FloatingActionButton.small(
              onPressed: () {
                _scrollToEnd();
                setState(() => _nuevosDesdeUltimoView = 0);
              },
              child: Badge.count(
                count: _nuevosDesdeUltimoView,
                child: const Icon(Icons.arrow_downward),
              ),
            )
          : null,
    );
  }

  Widget _buildList(ChatState st) {
    if (st.loading && st.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (st.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 48,
                color: Theme.of(context).hintColor,
              ),
              const SizedBox(height: 12),
              Text(
                'Sin mensajes todavia.\nEl monitor te escribira si necesita algo.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ),
        ),
      );
    }
    // Al primer render con items, posicionarse al final sin animacion.
    if (_ultimoCountVisto == 0) {
      _ultimoCountVisto = st.items.length;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToEnd(animated: false),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: st.items.length,
      itemBuilder: (_, i) {
        final msg = st.items[i];
        final prev = i > 0 ? st.items[i - 1] : null;
        final mostrarSeparadorFecha =
            prev == null || !_mismoDia(prev.createdAt, msg.createdAt);
        // alertasAcked paso de Set a Map<int, DateTime> (timestamp del
        // ack para race-window de 5s). El render del chat solo necesita
        // saber "fue ackeada en esta sesion" → containsKey alcanza.
        final acked = msg.alertId != null &&
            st.alertasAcked.containsKey(msg.alertId);
        return Column(
          children: [
            if (mostrarSeparadorFecha) _SeparadorFecha(fecha: msg.createdAt),
            _Burbuja(msg: msg, resuelto: acked),
          ],
        );
      },
    );
  }

  bool _mismoDia(DateTime a, DateTime b) {
    final al = a.toLocal();
    final bl = b.toLocal();
    return al.year == bl.year && al.month == bl.month && al.day == bl.day;
  }
}

class _SeparadorFecha extends StatelessWidget {
  const _SeparadorFecha({required this.fecha});
  final DateTime fecha;

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final f = fecha.toLocal();
    String label;
    if (f.year == hoy.year && f.month == hoy.month && f.day == hoy.day) {
      label = 'Hoy';
    } else if (f.year == hoy.year &&
        f.month == hoy.month &&
        f.day == hoy.day - 1) {
      label = 'Ayer';
    } else {
      label = DateFormat('dd/MM/yyyy').format(f);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({required this.msg, required this.resuelto});

  final TripMessage msg;
  /// True cuando la alerta ligada a este mensaje (msg.alertId) ya fue
  /// ackeada por el chofer. Se renderiza en gris atenuado con badge
  /// "✓ Resuelto" para no parecer activa.
  final bool resuelto;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final propio = msg.esPropio;
    final esAlerta = msg.esAlerta;

    // Detectar mensajes audit `[ATENDIDO ...]` que el backend postea
    // cuando el operador acknowledged la alerta desde el bell de la
    // web. Render atenuado (gris suave) con icono ✓ — son audit, no
    // requieren acción del chofer. La detección ya filtró el sonido /
    // notif del SO en el ChatNotifier; aca solo afecta el render.
    final cascadaParsed = parsearPrefijoCascada(msg.content);
    final esAtendidoAudit = cascadaParsed?.tipo == TipoCascada.atendido;
    // Mensajes de sistema sobre lifecycle del viaje (MC-017) y
    // directivas preset del operador (MC-018). Se renderean con look
    // distintivo (color por tipo + icono + label) para que el chofer
    // los identifique de un vistazo y los diferencie del chat normal.
    final esViajeAsignado = cascadaParsed?.tipo == TipoCascada.viajeAsignado;
    final esViajeEnCola = cascadaParsed?.tipo == TipoCascada.viajeEnCola;
    final esViajeListo = cascadaParsed?.tipo == TipoCascada.viajeListo;
    final esDirectivaOp =
        cascadaParsed?.tipo == TipoCascada.directivaOperador;
    final esSistemaTrip = esViajeAsignado || esViajeEnCola || esViajeListo;

    // Colores: las alertas tienen fondo rojizo con borde, los mensajes
    // normales usan primary para propios y surfaceContainerHighest para los
    // del monitor. Resueltas se atenuan para no destacar visualmente.
    // Mensajes ATENDIDO van con un look propio mas suave aun (es audit,
    // no es conversacional). Sistema-trip y directiva del operador
    // tienen sus propios paletas (azul / gris-azul / verde / azul oscuro).
    final Color fondo;
    final Color textoColor;
    Border? border;
    if (esViajeAsignado) {
      fondo = Colors.blue.shade50;
      textoColor = Colors.blue.shade900;
      border = Border.all(color: Colors.blue.shade300);
    } else if (esViajeEnCola) {
      fondo = Colors.blueGrey.shade50;
      textoColor = Colors.blueGrey.shade800;
      border = Border.all(color: Colors.blueGrey.shade300);
    } else if (esViajeListo) {
      fondo = Colors.green.shade50;
      textoColor = Colors.green.shade900;
      border = Border.all(color: Colors.green.shade400, width: 1.5);
    } else if (esDirectivaOp) {
      // Mismo look que el overlay (azul oscuro + borde dorado) para
      // que el chofer reconozca la directiva al scrollear el historial.
      fondo = Colors.indigo.shade900;
      textoColor = Colors.white;
      border = Border.all(color: Colors.amber.shade400, width: 1.5);
    } else if (esAtendidoAudit) {
      // Look explicito de "evento del operador, ya resuelto" — distinto
      // del look de mensaje conversacional del MONITOR para que el
      // chofer lo identifique de un vistazo.
      fondo = scheme.surfaceContainerHighest.withValues(alpha: 0.5);
      textoColor = Theme.of(context).hintColor;
      border = Border.all(
        color: Colors.green.withValues(alpha: 0.35),
        style: BorderStyle.solid,
      );
    } else if (esAlerta && resuelto) {
      fondo = scheme.surfaceContainerHighest.withValues(alpha: 0.6);
      textoColor = Theme.of(context).hintColor;
      border = Border.all(color: Theme.of(context).dividerColor);
    } else if (esAlerta) {
      fondo = Colors.red.shade900.withValues(alpha: 0.25);
      textoColor = scheme.onSurface;
      border = Border.all(color: Colors.red.shade700.withValues(alpha: 0.5));
    } else if (propio) {
      fondo = scheme.primary;
      textoColor = scheme.onPrimary;
    } else {
      fondo = scheme.surfaceContainerHighest;
      textoColor = scheme.onSurface;
    }

    final hora = DateFormat('HH:mm').format(msg.createdAt.toLocal());
    final name = (msg.senderName ?? '').trim();
    final imgs = msg.alert?.evidences.where((e) => e.esImagen).toList() ??
        const <MessageAlertEvidence>[];

    return Align(
      alignment: propio ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: propio ? 40 : 8,
            right: propio ? 8 : 40,
          ),
          child: Column(
            crossAxisAlignment:
                propio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!esAlerta && !propio && name.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                decoration: BoxDecoration(
                  color: fondo,
                  border: border,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14),
                    bottomLeft: Radius.circular(propio ? 14 : 2),
                    bottomRight: Radius.circular(propio ? 2 : 14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (esViajeAsignado) ...[
                      _SystemTripHeader(
                        icono: Icons.assignment,
                        label: 'VIAJE ASIGNADO',
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(height: 6),
                    ] else if (esViajeEnCola) ...[
                      _SystemTripHeader(
                        icono: Icons.hourglass_top,
                        label: 'VIAJE EN COLA',
                        color: Colors.blueGrey.shade700,
                      ),
                      const SizedBox(height: 6),
                    ] else if (esViajeListo) ...[
                      _SystemTripHeader(
                        icono: Icons.check_circle,
                        label: 'VIAJE LISTO',
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 6),
                    ] else if (esDirectivaOp) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.campaign,
                            size: 14,
                            color: Colors.amber.shade300,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            cascadaParsed!.regla.isEmpty
                                ? 'MENSAJE DEL OPERADOR'
                                : 'OPERADOR · ${cascadaParsed.regla.toUpperCase()}',
                            style: TextStyle(
                              color: Colors.amber.shade300,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ] else if (esAtendidoAudit) ...[
                      // Header del mensaje audit del operador. Sin
                      // badge de tipo / nivel — el chofer no necesita
                      // accionar; solo informarse.
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Colors.green.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            cascadaParsed!.regla.isEmpty
                                ? 'ATENDIDO POR EL OPERADOR'
                                : 'ATENDIDO ${cascadaParsed.regla} '
                                    '· POR EL OPERADOR',
                            style: TextStyle(
                              color: Colors.green.shade400,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ] else if (esAlerta) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _AlertBadge(alertType: msg.alert!.alertType),
                          if (msg.alert!.escalationLevel != null)
                            _NivelBadge(nivel: msg.alert!.escalationLevel!),
                          if (resuelto) const _ResueltoBadge(),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                    SelectableText(
                      // Para mensajes audit del operador (ATENDIDO),
                      // sistema-trip (VIAJE *) y directivas del operador
                      // mostramos el contenido limpio (sin el prefijo
                      // literal). Para el resto, tal cual viene del
                      // backend. Si el contenido limpio quedo vacio
                      // (ej. directiva sin mensaje extra), caemos al
                      // label del prefijo.
                      _bodyTexto(msg, cascadaParsed,
                          esAtendidoAudit: esAtendidoAudit,
                          esSistemaTrip: esSistemaTrip,
                          esDirectivaOp: esDirectivaOp),
                      style: TextStyle(
                        color: textoColor,
                        fontStyle:
                            esAtendidoAudit ? FontStyle.italic : null,
                        fontWeight: (esSistemaTrip || esDirectivaOp)
                            ? FontWeight.w600
                            : null,
                      ),
                    ),
                    if (esViajeListo) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.go('/viaje/${msg.tripId}'),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Ir al viaje'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    // Sub-texto explicativo para casos donde el chofer
                    // puede malinterpretar el scope (DEVICE_OFFLINE: no
                    // es la app la que perdio senal, es el rastreador
                    // satelital del camion). El helper devuelve null si
                    // el caso no aplica → render se saltea.
                    if (esAlerta) ...[
                      Builder(
                        builder: (_) {
                          final sub = alertSubtitle(
                            alertType: msg.alert!.alertType,
                            ruleType: msg.alert!.ruleType,
                          );
                          if (sub == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              sub,
                              style: TextStyle(
                                color: textoColor.withValues(alpha: 0.78),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                height: 1.3,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    if (imgs.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _AlertImagesGrid(evidences: imgs),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hora,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    if (propio) ...[
                      const SizedBox(width: 4),
                      Icon(
                        msg.leidoPorElOtro ? Icons.done_all : Icons.done,
                        size: 14,
                        color: msg.leidoPorElOtro
                            ? scheme.primary
                            : Theme.of(context).hintColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// `_AlertConfig.from` se eliminó: la fuente de verdad ahora vive en
// `lib/features/alertas/data/alert_styles.dart` (`alertTypeStyle`).
// Antes habia duplicacion entre este switch y el `_tituloAlerta` del
// banner; los unifique en MC-004 para que un tipo nuevo se registre en
// un solo lugar.

/// Devuelve el texto que se renderiza dentro de la burbuja segun el
/// tipo de mensaje. Para [ATENDIDO ...], los `[VIAJE *]` y los
/// `[OPERADOR · X]` mostramos el `contenidoLimpio` (sin prefijo). Si
/// el contenido limpio quedo vacio (ej. directiva preset sin texto
/// extra del operador), caemos al `regla` (label) o al label fijo
/// "Atendé indicación del operador".
String _bodyTexto(
  TripMessage msg,
  CascadaTagParsed? parsed, {
  required bool esAtendidoAudit,
  required bool esSistemaTrip,
  required bool esDirectivaOp,
}) {
  if (parsed == null) return msg.content;
  if (esAtendidoAudit || esSistemaTrip) {
    return parsed.contenidoLimpio.isEmpty
        ? msg.content
        : parsed.contenidoLimpio;
  }
  if (esDirectivaOp) {
    if (parsed.contenidoLimpio.isNotEmpty) return parsed.contenidoLimpio;
    if (parsed.regla.isNotEmpty) return parsed.regla;
    return 'Atendé indicación del operador';
  }
  return msg.content;
}

/// Header chico para mensajes de sistema sobre lifecycle de viaje
/// (`[VIAJE ASIGNADO]` / `[VIAJE EN COLA]` / `[VIAJE LISTO]`). Mismo
/// formato que el header de los mensajes ATENDIDO/Operador para
/// mantener consistencia visual.
class _SystemTripHeader extends StatelessWidget {
  const _SystemTripHeader({
    required this.icono,
    required this.label,
    required this.color,
  });

  final IconData icono;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Badge "✓ Resuelto" que aparece al lado del badge de alerta cuando el
/// chofer ya acknowledgeo la alerta. Indica visualmente que el mensaje
/// pasado ya no requiere accion.
class _ResueltoBadge extends StatelessWidget {
  const _ResueltoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.18),
        border: Border.all(color: Colors.green.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 11, color: Colors.green),
          SizedBox(width: 3),
          Text(
            'Resuelto',
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge chico de nivel de escalamiento (L1/L2/L3) que se muestra al lado
/// del badge de tipo cuando el backend setea `escalationLevel`. El
/// estilo viene del helper compartido `escalationStyle` para mantener
/// consistencia con el banner persistente y el FakeCall.
class _NivelBadge extends StatelessWidget {
  const _NivelBadge({required this.nivel});
  final String nivel;

  @override
  Widget build(BuildContext context) {
    final style = escalationStyle(nivel);
    // Si el nivel es desconocido (alerta pre-cascada / chofer), no
    // renderear nada — alertasAcked / _ResueltoBadge ya cubren info.
    if (style == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.2),
        border: Border.all(color: style.color.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({required this.alertType});
  final String alertType;

  @override
  Widget build(BuildContext context) {
    final style = alertTypeStyle(alertType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.2),
        border: Border.all(color: style.color.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13, color: style.color),
          const SizedBox(width: 4),
          Text(
            'ALERTA · ${style.label}',
            style: TextStyle(
              color: style.color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertImagesGrid extends StatelessWidget {
  const _AlertImagesGrid({required this.evidences});
  final List<MessageAlertEvidence> evidences;

  @override
  Widget build(BuildContext context) {
    // Una imagen → ancho completo. Dos o más → grid de 2 columnas.
    if (evidences.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => abrirAuthImageFullscreen(
            context: context,
            url: evidences.first.fileUrl!,
            title: evidences.first.description,
          ),
          child: AuthImage(
            url: evidences.first.fileUrl!,
            height: 180,
          ),
        ),
      );
    }
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        for (final ev in evidences)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () => abrirAuthImageFullscreen(
                context: context,
                url: ev.fileUrl!,
                title: ev.description,
              ),
              child: AuthImage(url: ev.fileUrl!, height: 110),
            ),
          ),
      ],
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool sending;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.enter): () {
                    onSend();
                  },
                },
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 2000,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Escribi un mensaje...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    isDense: true,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: sending ? null : () => onSend(),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: sending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
