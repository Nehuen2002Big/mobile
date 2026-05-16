// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'road_sheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckpointImpl _$$CheckpointImplFromJson(Map<String, dynamic> json) =>
    _$CheckpointImpl(
      locationId: json['locationId'] as String?,
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      actionType: json['actionType'] as String?,
      cargoDescription: json['cargoDescription'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CheckpointImplToJson(_$CheckpointImpl instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'actionType': instance.actionType,
      'cargoDescription': instance.cargoDescription,
      'notes': instance.notes,
    };

_$TripContactImpl _$$TripContactImplFromJson(Map<String, dynamic> json) =>
    _$TripContactImpl(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String?,
      description: json['description'] as String?,
      contactId: json['contactId'] as String?,
    );

Map<String, dynamic> _$$TripContactImplToJson(_$TripContactImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'role': instance.role,
      'description': instance.description,
      'contactId': instance.contactId,
    };

_$ContactsWrapperImpl _$$ContactsWrapperImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactsWrapperImpl(
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => TripContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      receiverSchedule: json['receiverSchedule'] as String?,
      receptionValidated: json['receptionValidated'] as bool? ?? false,
      needsEvidence: json['needsEvidence'] as bool? ?? false,
    );

Map<String, dynamic> _$$ContactsWrapperImplToJson(
        _$ContactsWrapperImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'receiverSchedule': instance.receiverSchedule,
      'receptionValidated': instance.receptionValidated,
      'needsEvidence': instance.needsEvidence,
    };

_$RouteInfoImpl _$$RouteInfoImplFromJson(Map<String, dynamic> json) =>
    _$RouteInfoImpl(
      mode: json['mode'] as String?,
      routeId: json['routeId'] as String?,
      toleranceKm: (json['toleranceKm'] as num?)?.toDouble(),
      etaStart: json['etaStart'] as String?,
      etaEnd: json['etaEnd'] as String?,
      geometry: (json['geometry'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          const [],
      distanceMeters: (json['distanceMeters'] as num?)?.toInt(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RouteInfoImplToJson(_$RouteInfoImpl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'routeId': instance.routeId,
      'toleranceKm': instance.toleranceKm,
      'etaStart': instance.etaStart,
      'etaEnd': instance.etaEnd,
      'geometry': instance.geometry,
      'distanceMeters': instance.distanceMeters,
      'durationSeconds': instance.durationSeconds,
    };

_$RoadSheetImpl _$$RoadSheetImplFromJson(Map<String, dynamic> json) =>
    _$RoadSheetImpl(
      identification: json['identification'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      referenceCode: json['referenceCode'] as String?,
      notes: json['notes'] as String?,
      tripTypeId: json['tripTypeId'] as String?,
      cargoTypeId: json['cargoTypeId'] as String?,
      cargoValue: _toStringOrNull(json['cargoValue']),
      checkpoints: (json['checkpoints'] as List<dynamic>?)
              ?.map((e) => Checkpoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      contacts: json['contacts'] == null
          ? null
          : ContactsWrapper.fromJson(json['contacts'] as Map<String, dynamic>),
      route: json['route'] == null
          ? null
          : RouteInfo.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RoadSheetImplToJson(_$RoadSheetImpl instance) =>
    <String, dynamic>{
      'identification': instance.identification,
      'origin': instance.origin,
      'destination': instance.destination,
      'referenceCode': instance.referenceCode,
      'notes': instance.notes,
      'tripTypeId': instance.tripTypeId,
      'cargoTypeId': instance.cargoTypeId,
      'cargoValue': instance.cargoValue,
      'checkpoints': instance.checkpoints,
      'contacts': instance.contacts,
      'route': instance.route,
    };
