import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../state/trip_pause_state.dart';

/// Banner sticky en la pantalla del viaje activo durante una pausa
/// de descanso (MC-015). Muestra:
///
/// - Color por tipo: verde (PARADA_COMER) / violeta (PARADA_DESCANSAR).
/// - Countdown live `H:MM:SS` o `MM:SS` decrementando cada segundo
///   localmente — no parpadea al sincronizar con el server.
/// - Sub-texto explicativo: durante la pausa las alertas operativas
///   (DESVIO/EXCESO_VELOCIDAD/DETENCION_PROLONGADA) estan suprimidas y
///   el chofer puede alejarse del camion sin disparar plausibility.
/// - Boton "Despausar ahora" → POST `/pause/end` con UX optimista.
///
/// Si el chofer pierde conexion, el ticker local sigue corriendo con
/// `endsAt` cacheado. Cuando vuelve la red, el siguiente poll
/// re-sincroniza.
class TripPauseBanner extends ConsumerWidget {
  const TripPauseBanner({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Errores transitorios → SnackBar, sin tirar el banner.
    ref.listen<TripPauseState>(tripPauseNotifierProvider(tripId),
        (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(next.error!),
              duration: const Duration(seconds: 3),
            ),
          );
      }
    });

    final state = ref.watch(tripPauseNotifierProvider(tripId));
    if (!state.paused) return const SizedBox.shrink();

    final esComer = state.status?.esComer == true;
    final color = esComer ? Colors.green.shade700 : Colors.deepPurple.shade400;
    final icon = esComer ? Icons.restaurant : Icons.bedtime;
    final tipoLabel = esComer ? 'comer' : 'descansar';

    return Material(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Viaje en pausa · Parada para $tipoLabel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _formatCountdown(state.secondsRemaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFeatures: [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Las alertas operativas (DESVIO, EXCESO_VELOCIDAD, '
                'DETENCION_PROLONGADA) están suprimidas durante la pausa. '
                'Tu teléfono puede estar lejos del camión sin disparar '
                'alertas. Si el camión se mueve, la pausa se cancela '
                'automáticamente.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: state.ending
                      ? null
                      : () => _despausar(context, ref),
                  icon: state.ending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow, color: Colors.white),
                  label: Text(
                    state.ending ? 'Cancelando...' : 'Despausar ahora',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _despausar(BuildContext context, WidgetRef ref) async {
    await ref
        .read(tripPauseNotifierProvider(tripId).notifier)
        .endPause(tripId);
    // El estado se actualiza via watch — si fue exitoso el banner se
    // oculta solo. Si falla, el listen muestra el SnackBar con el error.
  }

  /// `H:MM:SS` cuando faltan >= 1 h, `MM:SS` cuando es menos. El
  /// formato chiquito le dice al chofer de un vistazo cuanto le queda.
  static String _formatCountdown(int totalSeconds) {
    final s = totalSeconds < 0 ? 0 : totalSeconds;
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = sec.toString().padLeft(2, '0');
    if (h > 0) return '$h:$mm:$ss';
    return '$mm:$ss';
  }
}
