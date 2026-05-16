import 'package:freezed_annotation/freezed_annotation.dart';

import 'resolved_road_sheet.dart';
import 'road_sheet.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

// --- TripStatus ---

enum TripStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('FINISHED')
  finished,
  @JsonValue('CANCELLED')
  cancelled,
  unknown;
}

extension TripStatusX on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.pending:
        return 'Pendiente';
      case TripStatus.active:
        return 'En curso';
      case TripStatus.finished:
        return 'Finalizado';
      case TripStatus.cancelled:
        return 'Cancelado';
      case TripStatus.unknown:
        return 'Desconocido';
    }
  }
}

// --- Trip ---

@freezed
class Trip with _$Trip {
  const Trip._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Trip({
    required String id,
    @Default('') String imei,
    String? routeId,
    int? vehicleId,
    String? driverPersonId,
    @JsonKey(unknownEnumValue: TripStatus.unknown)
    @Default(TripStatus.unknown)
    TripStatus status,
    double? thresholdM,
    @Default(0) int totalPoints,
    @Default(0) int activeAlerts,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    // Coords del origen/destino (snapshot al crear el viaje).
    double? originLat,
    double? originLon,
    double? destinationLat,
    double? destinationLon,
    // Progreso acumulado (monotonico) y largo total de la ruta planeada.
    @Default(0.0) double maxRouteProgressM,
    double? routeTotalM,
    @Default({}) Map<String, dynamic> params,
  }) = _Trip;

  bool get esActivo => status == TripStatus.active;
  bool get esPendiente => status == TripStatus.pending;
  bool get estaTerminado =>
      status == TripStatus.finished || status == TripStatus.cancelled;

  /// Porcentaje de avance (0..1) si hay total de ruta definido.
  double? get progresoFraccion {
    final total = routeTotalM;
    if (total == null || total <= 0) return null;
    return (maxRouteProgressM / total).clamp(0.0, 1.0);
  }

  /// Parsea la hoja de ruta desde params.road_sheet.
  /// Viajes antiguos (pre 2026-04-18) tienen params vacio.
  RoadSheet get hojaRuta {
    final rs = params['road_sheet'];
    if (rs is Map<String, dynamic>) {
      return RoadSheet.fromJson(rs);
    }
    return const RoadSheet();
  }

  /// Hoja de ruta con nombres y coords de origen/destino YA resueltos
  /// del lado backend (`params.road_sheet._resolved`). Devuelve null
  /// para trips muy viejos que no tienen el campo (pre Camino A) o
  /// si el backend no logro resolver. Los call-sites deben caer al
  /// string raw de `hojaRuta.origin` / `hojaRuta.destination` en ese
  /// caso.
  ResolvedRoadSheet? get roadSheetResolved {
    final rs = params['road_sheet'];
    if (rs is! Map) return null;
    final resolved = rs['_resolved'];
    if (resolved is! Map) return null;
    return ResolvedRoadSheet.fromJson(
      Map<String, dynamic>.from(resolved),
    );
  }

  /// Nombre legible del origen. Prefiere `_resolved.origin_name` del
  /// backend (cubre los 3 formatos: UUID, `new:...`, free-form). Si
  /// el resolved no existe o esta vacio, cae al string raw del
  /// road_sheet. Como ultimo recurso, "-".
  String get nombreOrigen {
    final r = roadSheetResolved?.originName.trim();
    if (r != null && r.isNotEmpty) return r;
    final raw = hojaRuta.origin?.trim();
    if (raw != null && raw.isNotEmpty) return raw;
    return '-';
  }

  /// Nombre legible del destino. Misma estrategia que [nombreOrigen].
  String get nombreDestino {
    final r = roadSheetResolved?.destinationName.trim();
    if (r != null && r.isNotEmpty) return r;
    final raw = hojaRuta.destination?.trim();
    if (raw != null && raw.isNotEmpty) return raw;
    return '-';
  }

  /// Lat del origen con fallback al `_resolved.origin_lat` cuando el
  /// campo top-level del trip esta null (caso defensivo: los trips
  /// nuevos del backend tienen ambos seteados, pero los antiguos
  /// pueden tener solo el _resolved si fue lazy-decoded de un
  /// `new:...`).
  double? get origenLat => originLat ?? roadSheetResolved?.originLat;
  double? get origenLon => originLon ?? roadSheetResolved?.originLon;
  double? get destinoLat =>
      destinationLat ?? roadSheetResolved?.destinationLat;
  double? get destinoLon =>
      destinationLon ?? roadSheetResolved?.destinationLon;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
