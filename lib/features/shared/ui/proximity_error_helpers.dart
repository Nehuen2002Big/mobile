import '../models/proximity_error.dart';

/// Mapea un ProximityError al mensaje que se le muestra al chofer. Centralizado
/// para reusar desde /start y /reach.
String mensajeProximityError(ProximityError e) {
  String fmt(double? m) {
    if (m == null) return '-';
    if (m < 1000) return '${m.toStringAsFixed(0)} m';
    return '${(m / 1000).toStringAsFixed(1)} km';
  }

  switch (e.error) {
    case 'phone_too_far_from_origin':
      return 'Estás a ${fmt(e.distanceM)} del origen. '
          'Acercate a menos de ${fmt(e.maxDistanceM)} para iniciar.';
    case 'phone_too_far_from_checkpoint':
      return 'Estás a ${fmt(e.distanceM)} del checkpoint. '
          'Acercate a menos de ${fmt(e.maxDistanceM)} para marcarlo.';
    case 'phone_too_far_from_destination':
      return 'Estás a ${fmt(e.distanceM)} del destino. '
          'Acercate a menos de ${fmt(e.maxDistanceM)} para finalizar el viaje.';
    case 'device_signal_missing':
      return 'El dispositivo satelital del camión no reportó posición '
          'todavía. Verificá que el camión esté encendido y con vista al '
          'cielo. Reintentá en 30 segundos.';
    case 'device_too_far_from_origin':
      return 'El camión está a ${fmt(e.distanceM)} del origen según el '
          'dispositivo satelital. Asegurate de estar con el camión antes '
          'de iniciar.';
    case 'device_too_far_from_checkpoint':
      return 'El camión está a ${fmt(e.distanceM)} del checkpoint según el '
          'dispositivo satelital. Acercá el camión al punto antes de marcar '
          'la llegada.';
    case 'device_too_far_from_destination':
      return 'El camión está a ${fmt(e.distanceM)} del destino según el '
          'dispositivo satelital. Acercá el camión al destino antes de '
          'finalizar.';
    default:
      return e.message.isNotEmpty ? e.message : 'No se pudo validar la posición.';
  }
}

/// Titulo corto para el dialog segun la fuente del error.
String tituloProximityError(ProximityError e) {
  if (e.esSinSenalSatelital) return 'Sin señal del satelital';
  if (e.esFallaSatelital) return 'El camión está lejos';
  if (e.esFallaTelefono) return 'Estás lejos del punto';
  return 'No se pudo validar la posición';
}
