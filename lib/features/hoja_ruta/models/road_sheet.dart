import 'package:freezed_annotation/freezed_annotation.dart';

part 'road_sheet.freezed.dart';
part 'road_sheet.g.dart';

// --- Checkpoint ---

@freezed
class Checkpoint with _$Checkpoint {
  const factory Checkpoint({
    String? locationId,
    @Default('') String name,
    double? lat,
    double? lon,
    String? actionType,
    String? cargoDescription,
    String? notes,
  }) = _Checkpoint;

  factory Checkpoint.fromJson(Map<String, dynamic> json) =>
      _$CheckpointFromJson(json);
}

// --- TripContact ---

@freezed
class TripContact with _$TripContact {
  const factory TripContact({
    @Default('') String name,
    @Default('') String phone,
    String? role,
    String? description,
    String? contactId,
  }) = _TripContact;

  factory TripContact.fromJson(Map<String, dynamic> json) =>
      _$TripContactFromJson(json);
}

// --- ContactsWrapper (contacts.entries en la hoja de ruta) ---

@freezed
class ContactsWrapper with _$ContactsWrapper {
  const factory ContactsWrapper({
    @Default([]) List<TripContact> entries,
    String? receiverSchedule,
    @Default(false) bool receptionValidated,
    @Default(false) bool needsEvidence,
  }) = _ContactsWrapper;

  factory ContactsWrapper.fromJson(Map<String, dynamic> json) =>
      _$ContactsWrapperFromJson(json);
}

// --- RouteInfo ---

@freezed
class RouteInfo with _$RouteInfo {
  const factory RouteInfo({
    String? mode,
    String? routeId,
    double? toleranceKm,
    String? etaStart,
    String? etaEnd,
    @Default([]) List<List<double>> geometry,
    int? distanceMeters,
    int? durationSeconds,
  }) = _RouteInfo;

  factory RouteInfo.fromJson(Map<String, dynamic> json) =>
      _$RouteInfoFromJson(json);
}

// --- RoadSheet (hoja de ruta completa dentro de params.road_sheet) ---

@freezed
class RoadSheet with _$RoadSheet {
  const RoadSheet._();

  const factory RoadSheet({
    String? identification,
    String? origin,
    String? destination,
    String? referenceCode,
    String? notes,
    String? tripTypeId,
    String? cargoTypeId,
    @JsonKey(fromJson: _toStringOrNull) String? cargoValue,
    @Default([]) List<Checkpoint> checkpoints,
    ContactsWrapper? contacts,
    RouteInfo? route,
  }) = _RoadSheet;

  List<TripContact> get contactosList => contacts?.entries ?? [];

  String? get etaStart => route?.etaStart;
  String? get etaEnd => route?.etaEnd;

  bool get vacia =>
      origin == null &&
      destination == null &&
      referenceCode == null &&
      notes == null &&
      checkpoints.isEmpty &&
      contactosList.isEmpty;

  factory RoadSheet.fromJson(Map<String, dynamic> json) =>
      _$RoadSheetFromJson(json);
}

String? _toStringOrNull(dynamic v) => v?.toString();
