/// Snapshot de una directiva preset del operador (MC-018).
///
/// El operador selecciona un chip en el SPA ("Esperá grúa", "Continuá
/// ruta", etc.) y eso postea al chat un mensaje `[OPERADOR · {label}]`.
/// Cuando el `ChatNotifier` lo detecta, lo levanta a este snapshot y
/// el overlay global lo muestra como banner azul oscuro con borde
/// dorado, vibra corto y suena un chime.
///
/// `messageId` se usa para idempotencia: el overlay solo dispara
/// vibracion + sonido cuando llega un id distinto al ultimo mostrado
/// (evita repetir si el provider se rebuilda con la misma directiva).
class OperatorDirective {
  const OperatorDirective({
    required this.messageId,
    required this.tripId,
    required this.label,
    required this.content,
  });

  /// `id` del `TripMessage` que originó la directiva.
  final int messageId;

  /// `tripId` al que pertenece. El boton "Entendido" (o el tap de la
  /// notif del SO) lleva al chofer al detalle de este trip.
  final String tripId;

  /// Label parseado del prefijo (`Esperá grúa`, `Continuá ruta`, etc.).
  /// Si el operador cambia el set de chips en el SPA, la app lo muestra
  /// tal cual sin hardcodear etiquetas.
  final String label;

  /// Contenido limpio del mensaje (lo que vino despues del `]`). Suele
  /// estar vacio si el operador no agrego texto extra; en ese caso el
  /// banner solo muestra el label.
  final String content;
}
