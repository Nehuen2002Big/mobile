/// Snapshot del estado de pausa de un viaje. El backend lo expone via
/// `GET /trips/{id}/pause/status` y mantiene una pausa activa cuando el
/// chofer creo PARADA_COMER (1 h) o PARADA_DESCANSAR (8 h).
///
/// Cuando NO hay pausa activa, el backend devuelve todos los campos
/// excepto `tripId` y `paused` en `null`. La factory `fromJson` tolera
/// eso sin throw.
class TripPauseStatus {
  const TripPauseStatus({
    required this.tripId,
    required this.paused,
    this.type,
    this.startedAt,
    this.endsAt,
    this.secondsRemaining,
  });

  /// id del trip que pertenece a este snapshot.
  final String tripId;

  /// `true` si hay una pausa activa ahora mismo.
  final bool paused;

  /// `PARADA_COMER` o `PARADA_DESCANSAR`. `null` cuando `paused == false`.
  final String? type;

  /// Inicio de la pausa (UTC). `null` cuando no hay pausa.
  final DateTime? startedAt;

  /// Fin programado de la pausa (UTC). `null` cuando no hay pausa. Es la
  /// fuente de verdad para el countdown — preferila sobre
  /// [secondsRemaining], que puede llegar 30 s desactualizado.
  final DateTime? endsAt;

  /// Segundos restantes informados por el server. Util como sanity check
  /// y para el primer render mientras el ticker local todavia no corrio,
  /// pero el countdown debe usar [endsAt] para que decremente fluido.
  final int? secondsRemaining;

  /// `true` si la pausa corresponde a una alerta tipo descanso. Usado
  /// para colorear/etiquetar el banner.
  bool get esComer => type == 'PARADA_COMER';
  bool get esDescansar => type == 'PARADA_DESCANSAR';

  factory TripPauseStatus.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? raw) {
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw)?.toUtc();
      }
      return null;
    }

    return TripPauseStatus(
      tripId: json['trip_id'] as String? ?? '',
      paused: json['paused'] as bool? ?? false,
      type: json['type'] as String?,
      startedAt: parseDate(json['started_at']),
      endsAt: parseDate(json['ends_at']),
      secondsRemaining: (json['seconds_remaining'] as num?)?.toInt(),
    );
  }
}
