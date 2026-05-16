/// Snapshot de la hoja de ruta con los nombres y coordenadas de
/// origen/destino YA resueltos del lado backend.
///
/// Vive en `trip.params.road_sheet._resolved` y lo computa el backend
/// de tracking en `POST /trips` (eager) o lazy en `GET /trips/{id}`
/// para trips antiguos sin el campo persistido.
///
/// **Por que existe**: el campo `origin`/`destination` del road_sheet
/// soporta 3 formatos historicos:
///   1. UUID puro (apunta a una location en `isatech_routes`).
///   2. Synthetic `new:<lat>,<lon>:<base64-name>` para puntos marcados
///      por el operador sin guardar como Location persistente.
///   3. Free-form string (legacy).
///
/// La app mobile no tiene scope para llamar `isatech_routes` ni
/// puede asumir un formato unico. Por eso el backend resuelve los 3
/// y deja todo en `_resolved` con shape predecible. Si por algun
/// motivo `_resolved` no esta (trip antiguo sin lazy resolve, error
/// server), los call-sites caen al string raw del road_sheet — feo
/// pero no crashea.
///
/// **Garantia del backend**: `originName` y `destinationName` SIEMPRE
/// son strings no-nulos (puede ser "Origen sin definir" o el UUID
/// crudo como fallback, pero nunca null). Las coords si pueden ser
/// null (caso free-form sin geolocalizacion).
class ResolvedRoadSheet {
  const ResolvedRoadSheet({
    required this.originName,
    required this.destinationName,
    this.originLat,
    this.originLon,
    this.destinationLat,
    this.destinationLon,
  });

  final String originName;
  final String destinationName;
  final double? originLat;
  final double? originLon;
  final double? destinationLat;
  final double? destinationLon;

  factory ResolvedRoadSheet.fromJson(Map<String, dynamic> json) {
    double? num2d(Object? raw) => raw is num ? raw.toDouble() : null;
    return ResolvedRoadSheet(
      originName: (json['origin_name'] as String?) ?? '',
      destinationName: (json['destination_name'] as String?) ?? '',
      originLat: num2d(json['origin_lat']),
      originLon: num2d(json['origin_lon']),
      destinationLat: num2d(json['destination_lat']),
      destinationLon: num2d(json['destination_lon']),
    );
  }
}
