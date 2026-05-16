/// Resultado de parsear el prefijo `[XXX · regla]` que el backend antepone
/// a los mensajes auto-posteados de la cascada de alertas escalonadas.
class CascadaTagParsed {
  const CascadaTagParsed({
    required this.tipo,
    required this.regla,
    required this.contenidoLimpio,
  });

  final TipoCascada tipo;

  /// "Dispositivo sin reportar" / "Velocidad" / etc. Tal cual lo posteó
  /// el backend después del `· `.
  final String regla;

  /// Mensaje del backend sin el prefijo (lo que se muestra en la burbuja).
  final String contenidoLimpio;
}

enum TipoCascada {
  /// `[AVISO · ...]` — informativo, nivel L1.
  aviso,
  /// `[ACCION REQUERIDA · ...]` — nivel L2, requiere ack.
  accionRequerida,
  /// `[ESCALADO A SUPERVISOR · ...]` — nivel L3, ack + supervisor.
  escaladoSupervisor,
  /// `[LLAMADA · ...]` — dispara la pantalla fake-call full-screen.
  llamada,
  /// `[SUPERVISOR] ...` — informativo: el supervisor ya intervino.
  supervisorInformado,
  /// `[ATENDIDO L2] ...` / `[ATENDIDO L3] ...` — mensaje de auditoria
  /// que el backend postea cuando el operador ackea la alerta desde
  /// el bell de la web. La alerta a la que refieren YA esta resuelta
  /// del lado server. La app debe:
  ///   - Renderizar atenuado en el chat (gris suave, opacidad 70%).
  ///   - **NO** disparar fake-call ni banner (no re-alertar al chofer).
  ///   - **NO** sonar / vibrar / dispatchear notif del SO.
  ///   - Mostrar un icono ✓ "atendido" para que el chofer identifique
  ///     que es un evento del operador, no un mensaje conversacional.
  atendido,
  /// `[VIAJE ASIGNADO]` — backend acaba de asignar un viaje al chofer.
  /// Render azul + sonido suave. NO es cascada (ningun ack/fake-call).
  /// (MC-017)
  viajeAsignado,
  /// `[VIAJE EN COLA]` — el chofer ya tenia un viaje activo, este 2do
  /// queda queued hasta que el primero termine. Render gris-azul,
  /// SIN sonido. (MC-017)
  viajeEnCola,
  /// `[VIAJE LISTO]` — un viaje que estaba en cola se desbloqueo
  /// porque el primero termino. Render verde + sonido suave + accion
  /// "Ir al viaje". (MC-017)
  viajeListo,
  /// `[OPERADOR · {label}]` — directiva preset del operador (chips
  /// del SPA: "Espera grua", "Tomate un descanso", etc). Render banner
  /// azul oscuro con borde dorado, vibracion corta, sonido suave,
  /// auto-dismiss 10 s. NO dispara cascada. (MC-018)
  directivaOperador,
}

/// Parsea el prefijo de un mensaje de chat. Devuelve null si el mensaje no
/// es parte de la cascada (mensaje normal del MONITOR o del DRIVER).
CascadaTagParsed? parsearPrefijoCascada(String content) {
  final trimmed = content.trimLeft();
  if (!trimmed.startsWith('[')) return null;
  final endBracket = trimmed.indexOf(']');
  if (endBracket < 0) return null;
  final inside = trimmed.substring(1, endBracket).trim();
  // Texto despues del ']': contenido limpio que se muestra como mensaje.
  final resto = trimmed.substring(endBracket + 1).trim();

  // Casos sin separador "·" (ej. `[SUPERVISOR]`).
  if (inside == 'SUPERVISOR') {
    return CascadaTagParsed(
      tipo: TipoCascada.supervisorInformado,
      regla: '',
      contenidoLimpio: resto,
    );
  }

  // `[ATENDIDO]`, `[ATENDIDO L2]`, `[ATENDIDO L3]` — audit del bell del
  // operador. Sin separador `·`, el "nivel" L2/L3 viene como segunda
  // palabra del prefijo (opcional). Lo guardamos como `regla` para que
  // el render pueda mostrar "Atendido (L3)" si lo desea.
  if (inside.startsWith('ATENDIDO')) {
    final partes = inside.split(RegExp(r'\s+'));
    final nivel = partes.length > 1 ? partes.sublist(1).join(' ').trim() : '';
    return CascadaTagParsed(
      tipo: TipoCascada.atendido,
      regla: nivel,
      contenidoLimpio: resto,
    );
  }

  // Mensajes de sistema sobre lifecycle de viajes (MC-017). Los 3 son
  // prefijos planos sin separador `·` — el contenido viene despues
  // del `]` y la app lo muestra tal cual.
  if (inside == 'VIAJE ASIGNADO') {
    return CascadaTagParsed(
      tipo: TipoCascada.viajeAsignado,
      regla: '',
      contenidoLimpio: resto,
    );
  }
  if (inside == 'VIAJE EN COLA') {
    return CascadaTagParsed(
      tipo: TipoCascada.viajeEnCola,
      regla: '',
      contenidoLimpio: resto,
    );
  }
  if (inside == 'VIAJE LISTO') {
    return CascadaTagParsed(
      tipo: TipoCascada.viajeListo,
      regla: '',
      contenidoLimpio: resto,
    );
  }

  // Resto: formato `TIPO · regla`.
  final dotIdx = inside.indexOf('·');
  if (dotIdx < 0) return null;
  final tipoStr = inside.substring(0, dotIdx).trim().toUpperCase();
  final regla = inside.substring(dotIdx + 1).trim();

  TipoCascada tipo;
  switch (tipoStr) {
    case 'AVISO':
      tipo = TipoCascada.aviso;
      break;
    case 'ACCION REQUERIDA':
    case 'ACCIÓN REQUERIDA':
      tipo = TipoCascada.accionRequerida;
      break;
    case 'ESCALADO A SUPERVISOR':
      tipo = TipoCascada.escaladoSupervisor;
      break;
    case 'LLAMADA':
      tipo = TipoCascada.llamada;
      break;
    case 'OPERADOR':
      // `[OPERADOR · {label}]` — directiva preset del operador (MC-018).
      // El label (`Esperá grúa`, `Continuá ruta`, etc.) queda en `regla`;
      // tratamos el set como prefijo generico para que un label nuevo
      // del SPA no rompa la app.
      tipo = TipoCascada.directivaOperador;
      break;
    default:
      return null;
  }

  return CascadaTagParsed(
    tipo: tipo,
    regla: regla,
    contenidoLimpio: resto,
  );
}

/// Devuelve true si el contenido es un mensaje [LLAMADA · ...] que dispara
/// la pantalla fake-call.
bool esLlamadaCascada(String content) {
  final p = parsearPrefijoCascada(content);
  return p?.tipo == TipoCascada.llamada;
}
