import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../core/providers.dart';
import '../../chat/state/operator_directive.dart';

/// Overlay global para directivas preset del operador (MC-018).
///
/// Se monta una sola vez en el `MaterialApp.builder` arriba del
/// `child` para que aparezca desde cualquier pantalla. Watch-ea el
/// `pendingOperatorDirectiveProvider` y, cuando llega una nueva
/// directiva (cambia el `messageId`):
///
/// 1. Vibra una vez ~200 ms (no sostenido).
/// 2. Suena un chime breve del SO (`SystemSound.alert`).
/// 3. Renderiza un banner azul oscuro con borde dorado en la parte
///    superior con el label de la directiva y el boton "Entendido".
/// 4. Auto-dismiss a los 10 s, o al toque de "Entendido".
///
/// Multiples directivas seguidas: si el operador toca varios chips en
/// pocos segundos, cada `messageId` nuevo reinicia el timer y dispara
/// vibracion/sonido — el banner queda mostrando solo la ultima.
class OperatorDirectiveOverlay extends ConsumerStatefulWidget {
  const OperatorDirectiveOverlay({super.key});

  /// Tiempo que el banner queda en pantalla antes de auto-cerrarse.
  static const Duration autoDismiss = Duration(seconds: 10);

  @override
  ConsumerState<OperatorDirectiveOverlay> createState() =>
      _OperatorDirectiveOverlayState();
}

class _OperatorDirectiveOverlayState
    extends ConsumerState<OperatorDirectiveOverlay> {
  Timer? _dismissTimer;
  int? _ultimoMessageId;

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _onDirectiva(OperatorDirective d) {
    if (_ultimoMessageId == d.messageId) return;
    _ultimoMessageId = d.messageId;
    _dismissTimer?.cancel();
    _dismissTimer = Timer(OperatorDirectiveOverlay.autoDismiss, () {
      if (!mounted) return;
      // Solo limpiar si seguimos mostrando esta misma directiva. Si el
      // chofer toco "Entendido" o llego una directiva nueva, no pisamos.
      final actual = ref.read(pendingOperatorDirectiveProvider);
      if (actual?.messageId == d.messageId) {
        ref.read(pendingOperatorDirectiveProvider.notifier).state = null;
      }
    });
    // Vibracion corta — un solo pulso. Si el dispositivo no tiene
    // vibrador (raro en mobile), Vibration.hasVibrator devuelve false
    // y no hacemos nada.
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 200);
      }
    });
    // Sonido suave del SO — distinto del ringtone de fake-call.
    SystemSound.play(SystemSoundType.alert);
  }

  void _entendido() {
    _dismissTimer?.cancel();
    ref.read(pendingOperatorDirectiveProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OperatorDirective?>(pendingOperatorDirectiveProvider,
        (prev, next) {
      if (next == null) {
        _ultimoMessageId = null;
        _dismissTimer?.cancel();
        return;
      }
      _onDirectiva(next);
    });

    final directiva = ref.watch(pendingOperatorDirectiveProvider);
    if (directiva == null) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.indigo.shade900,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade400,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.campaign, color: Colors.amber.shade300),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Mensaje del operador',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    directiva.label.isNotEmpty
                        ? directiva.label
                        : (directiva.content.isNotEmpty
                            ? directiva.content
                            : 'Atendé indicación del operador'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  if (directiva.label.isNotEmpty &&
                      directiva.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      directiva.content,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _entendido,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.amber.shade300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                      ),
                      child: const Text(
                        'Entendido',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
