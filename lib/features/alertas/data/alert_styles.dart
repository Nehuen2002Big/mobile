import 'package:flutter/material.dart';

/// Estilo visual de una alerta segun su `alert_type` (string crudo del
/// backend en SCREAMING_SNAKE_CASE). Lo consumen el chat (badge de
/// burbuja), el banner persistente, el FakeCall y la lista de alertas.
///
/// **Por que NO usamos un enum dart:** el backend puede agregar tipos
/// nuevos en cualquier release. Si esto fuera un enum cerrado y llega
/// `"DESVIO_HORARIO"` antes de que actualicemos el cliente, la
/// deserializacion crashea (o lo mapea a un default). Manteniendo el
/// tipo como `String` y el helper con `default → estilo generico`
/// garantizamos que la app no se rompa con tipos futuros — solo los
/// muestra con icon ❗ + label raw hasta que actualicemos esta tabla.
class AlertTypeStyle {
  const AlertTypeStyle({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;

  /// Label corto en español para mostrar en badges. Siempre Title Case.
  final String label;
}

/// `true` si la alerta es la combinacion `SIN_SENAL +
/// MOVEMENT_DURING_PAUSE` que el backend genera cuando el camion se
/// mueve (>8 km/h) durante una pausa activa (PARADA_COMER /
/// PARADA_DESCANSAR). Es L3 — render rojo + flow especifico de
/// confirmacion en el banner persistente (MC-016).
///
/// Posible robo desde el punto de vista del operador. La app le
/// pregunta al chofer "¿Fuiste vos?" y, si dice "No fui yo", postea
/// `[CHOFER · ALERTA ROBO]` al chat.
bool isMovementDuringPause({String? alertType, String? ruleType}) {
  return (alertType ?? '').toUpperCase() == 'SIN_SENAL' &&
      (ruleType ?? '').toUpperCase() == 'MOVEMENT_DURING_PAUSE';
}

/// Estilo visual para el HEADER de una alerta: igual que
/// [alertTypeStyle] pero contemplando combinaciones especiales de
/// `alertType + ruleType` que merecen un override del icono / label /
/// color.
///
/// Hoy hay un solo override:
///   - `SIN_SENAL + MOVEMENT_DURING_PAUSE` → icono warning_amber rojo,
///     label "Movimiento en pausa". El backend manda `alertType=SIN_SENAL`
///     por reusar el canal de "alerta operativa pasiva", pero para el
///     chofer es algo radicalmente distinto a una perdida de senal.
///
/// El render del banner persistente, el sheet de detalles y la
/// burbuja del chat consumen este helper en vez de [alertTypeStyle]
/// para no duplicar la logica de override.
AlertTypeStyle alertHeaderStyle({String? alertType, String? ruleType}) {
  if (isMovementDuringPause(alertType: alertType, ruleType: ruleType)) {
    return const AlertTypeStyle(
      icon: Icons.warning_amber,
      color: Color(0xFFEF4444), // rojo
      label: 'Movimiento en pausa',
    );
  }
  return alertTypeStyle(alertType);
}

/// Resuelve el estilo del tipo de alerta. Si el tipo no esta en la
/// tabla (caso defensivo: backend introduce un tipo nuevo antes de que
/// actualicemos esta lista), devuelve un estilo generico con icono
/// `error_outline` y el `alertType` raw como label — la app NO crashea.
AlertTypeStyle alertTypeStyle(String? alertType) {
  switch ((alertType ?? '').toUpperCase()) {
    // ── Generadas por el backend (motor de reglas) ────────────────
    case 'DESVIO':
      return const AlertTypeStyle(
        icon: Icons.alt_route,
        color: Color(0xFFEF4444), // rojo
        label: 'Desvío',
      );
    case 'RECUPERA_RUTA':
      return const AlertTypeStyle(
        icon: Icons.alt_route,
        color: Color(0xFF22C55E), // verde
        label: 'En ruta',
      );
    case 'SIN_SENAL':
      return const AlertTypeStyle(
        icon: Icons.signal_wifi_off,
        color: Color(0xFFFBBF24), // amarillo
        label: 'Sin señal',
      );
    case 'RECUPERA_SENAL':
      return const AlertTypeStyle(
        icon: Icons.signal_wifi_4_bar,
        color: Color(0xFF22C55E), // verde
        label: 'Señal OK',
      );
    case 'EXCESO_VELOCIDAD':
      return const AlertTypeStyle(
        icon: Icons.speed,
        color: Color(0xFFFB923C), // naranja
        label: 'Velocidad',
      );
    case 'DETENCION_PROLONGADA':
      return const AlertTypeStyle(
        icon: Icons.pause_circle,
        color: Color(0xFFFBBF24), // ambar
        label: 'Detenido',
      );
    case 'DESVIO_HORARIO':
      return const AlertTypeStyle(
        icon: Icons.schedule,
        color: Color(0xFF8B5CF6), // violeta
        label: 'Atraso',
      );
    // ── Reportadas por el chofer (botones de AlertasPanel) ────────
    case 'TRAFICO':
      return const AlertTypeStyle(
        icon: Icons.warning_amber,
        color: Color(0xFFFB923C), // naranja
        label: 'Tráfico',
      );
    case 'PARADA_COMER':
      return const AlertTypeStyle(
        icon: Icons.restaurant,
        color: Color(0xFFA78BFA), // violeta-claro
        label: 'Parada',
      );
    case 'AVERIA':
      return const AlertTypeStyle(
        icon: Icons.build,
        color: Color(0xFFEF4444), // rojo
        label: 'Avería',
      );
    case 'ACCIDENTE':
      return const AlertTypeStyle(
        icon: Icons.local_hospital,
        color: Color(0xFFF43F5E), // rojo-rosa
        label: 'Accidente',
      );
    case 'EMERGENCIA':
      return const AlertTypeStyle(
        icon: Icons.emergency,
        color: Color(0xFFDC2626), // rojo-fuerte
        label: 'Emergencia',
      );
    default:
      // Tipo desconocido. Lo mostramos con label raw para que al menos
      // el chofer + nosotros podamos identificarlo desde la UI.
      final raw = (alertType ?? '').trim();
      return AlertTypeStyle(
        icon: Icons.error_outline,
        color: Colors.grey,
        label: raw.isEmpty ? 'Alerta' : raw,
      );
  }
}

/// Estilo visual del nivel de escalación L1/L2/L3.
class EscalationStyle {
  const EscalationStyle({
    required this.color,
    required this.label,
    required this.descripcion,
  });

  /// Color de tinte del badge.
  final Color color;

  /// Texto principal del badge (siempre "L1"/"L2"/"L3").
  final String label;

  /// Descripcion corta en español para tooltips o subtítulos.
  final String descripcion;
}

/// Resuelve el estilo del nivel de escalación. Devuelve `null` si el
/// nivel es desconocido o nulo — la UI debe omitir el badge en ese
/// caso (alerta pre-cascada o creada por el chofer).
EscalationStyle? escalationStyle(String? level) {
  switch ((level ?? '').toUpperCase()) {
    case 'L1':
      // Gris: aviso solo informativo (no requiere accion).
      return const EscalationStyle(
        color: Color(0xFF6B7280),
        label: 'L1',
        descripcion: 'Aviso',
      );
    case 'L2':
      // Ambar: el chofer debe ackear (banner + sonido).
      return EscalationStyle(
        color: Colors.amber.shade800,
        label: 'L2',
        descripcion: 'Requiere acción',
      );
    case 'L3':
      // Rojo: critico (fake-call full-screen + cascada activa).
      return EscalationStyle(
        color: Colors.red.shade700,
        label: 'L3',
        descripcion: 'Crítico',
      );
    default:
      return null;
  }
}

/// Sub-texto explicativo que se muestra debajo del título de la alerta
/// en casos donde el chofer puede confundirse del scope. Devuelve
/// `null` si no aplica (la mayoria de las alertas no necesitan
/// aclaracion extra).
///
/// Casos actuales cubiertos:
///   - **DEVICE_OFFLINE** (rule_type) sobre alerta SIN_SENAL: el
///     dispositivo satelital del camion dejo de reportar. La app del
///     chofer sigue funcionando — hay que aclararle que el problema
///     no es su telefono.
///   - **MOVEMENT_DURING_PAUSE** (rule_type) sobre alerta SIN_SENAL:
///     el camion se movio durante una pausa activa. El subtitulo
///     incluye el tipo de pausa cuando viene en `extra.pause_type`
///     ("comer" / "descansar") — sino cae al texto generico.
String? alertSubtitle({
  String? alertType,
  String? ruleType,
  Map<String, dynamic>? extra,
}) {
  final at = (alertType ?? '').toUpperCase();
  final rt = (ruleType ?? '').toUpperCase();
  if (at == 'SIN_SENAL' && rt == 'DEVICE_OFFLINE') {
    return 'El dispositivo satelital del camión no está reportando. '
        'Mientras tu app siga funcionando, el operador puede verte. '
        'Si llegás a destino y no funciona, avisá al taller.';
  }
  if (at == 'SIN_SENAL' && rt == 'MOVEMENT_DURING_PAUSE') {
    final pauseType = (extra?['pause_type'] as String?)?.toUpperCase();
    final etiqueta = pauseType == 'PARADA_COMER'
        ? 'comer'
        : pauseType == 'PARADA_DESCANSAR'
            ? 'descansar'
            : null;
    if (etiqueta != null) {
      return 'Tu camión empezó a moverse durante una pausa de '
          '$etiqueta. La pausa fue cancelada.';
    }
    return 'Tu camión empezó a moverse durante una pausa activa. '
        'La pausa fue cancelada.';
  }
  return null;
}
