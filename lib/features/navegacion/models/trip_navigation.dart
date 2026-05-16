import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_navigation.freezed.dart';
part 'trip_navigation.g.dart';

/// Payload completo de navegacion turn-by-turn calculado por el backend.
/// Contiene la geometria total + un leg por destino intermedio (checkpoint)
/// y el destino final, con su lista de steps con maniobras.
@freezed
class TripNavigation with _$TripNavigation {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TripNavigation({
    required String tripId,
    required DateTime computedAt,
    @Default('osrm') String routingEngine,
    @Default(0.0) double totalDistanceM,
    @Default(0.0) double totalDurationS,
    required GeoJsonLineString geometry,
    @Default([]) List<NavigationLeg> legs,
  }) = _TripNavigation;

  factory TripNavigation.fromJson(Map<String, dynamic> json) =>
      _$TripNavigationFromJson(json);
}

/// GeoJSON LineString. Coordinates en formato [[lon, lat], ...].
@freezed
class GeoJsonLineString with _$GeoJsonLineString {
  const factory GeoJsonLineString({
    @Default('LineString') String type,
    @Default([]) List<List<double>> coordinates,
  }) = _GeoJsonLineString;

  factory GeoJsonLineString.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonLineStringFromJson(json);
}

/// Leg = tramo desde el origen del tramo hasta el proximo target. Un viaje
/// con N checkpoints + 1 destino tiene N+1 legs. Cada leg tiene su propia
/// lista de steps con maniobras.
@freezed
class NavigationLeg with _$NavigationLeg {
  const NavigationLeg._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NavigationLeg({
    /// "checkpoint" | "destination"
    required String target,
    int? targetIndex,
    @Default('') String targetLabel,
    @Default(0.0) double targetLat,
    @Default(0.0) double targetLon,
    @Default(0.0) double distanceM,
    @Default(0.0) double durationS,
    @Default([]) List<NavigationStep> steps,
  }) = _NavigationLeg;

  bool get esDestinoFinal => target == 'destination';
  bool get esCheckpoint => target == 'checkpoint';

  factory NavigationLeg.fromJson(Map<String, dynamic> json) =>
      _$NavigationLegFromJson(json);
}

/// Step = subtramo entre dos maniobras. Cada step termina con una maniobra
/// (excepto el ultimo, cuyo maneuver.type='arrive').
@freezed
class NavigationStep with _$NavigationStep {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NavigationStep({
    @Default(0.0) double distanceM,
    @Default(0.0) double durationS,
    String? roadName,
    required GeoJsonLineString geometry,
    required NavigationManeuver maneuver,
  }) = _NavigationStep;

  factory NavigationStep.fromJson(Map<String, dynamic> json) =>
      _$NavigationStepFromJson(json);
}

/// Maniobra: el "que hago" en cada step. La instruccion en español viene
/// pre-armada por el backend. La taxonomia type+modifier sigue OSRM.
@freezed
class NavigationManeuver with _$NavigationManeuver {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NavigationManeuver({
    /// [lon, lat]
    @Default([]) List<double> location,
    @Default('') String type,
    String? modifier,
    @Default(0.0) double bearingBefore,
    @Default(0.0) double bearingAfter,
    int? exit,
    @Default('') String instructionEs,
  }) = _NavigationManeuver;

  factory NavigationManeuver.fromJson(Map<String, dynamic> json) =>
      _$NavigationManeuverFromJson(json);
}
