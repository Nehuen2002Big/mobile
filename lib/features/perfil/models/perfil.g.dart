// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonaImpl _$$PersonaImplFromJson(Map<String, dynamic> json) =>
    _$PersonaImpl(
      id: json['id'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$$PersonaImplToJson(_$PersonaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'role': instance.role,
    };

_$DriverProfileImpl _$$DriverProfileImplFromJson(Map<String, dynamic> json) =>
    _$DriverProfileImpl(
      licenseNumber: json['license_number'] as String?,
      licenseCategory: json['license_category'] as String?,
      licenseExpiry: json['license_expiry'] as String?,
      active: json['active'] as bool? ?? false,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
    );

Map<String, dynamic> _$$DriverProfileImplToJson(_$DriverProfileImpl instance) =>
    <String, dynamic>{
      'license_number': instance.licenseNumber,
      'license_category': instance.licenseCategory,
      'license_expiry': instance.licenseExpiry,
      'active': instance.active,
      'emergency_contact_phone': instance.emergencyContactPhone,
    };

_$PersonContactImpl _$$PersonContactImplFromJson(Map<String, dynamic> json) =>
    _$PersonContactImpl(
      id: json['id'] as String?,
      label: json['label'] as String?,
      roleTag: json['role_tag'] as String?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      active: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$$PersonContactImplToJson(_$PersonContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'role_tag': instance.roleTag,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'active': instance.active,
    };

_$PerfilImpl _$$PerfilImplFromJson(Map<String, dynamic> json) => _$PerfilImpl(
      person: Persona.fromJson(json['person'] as Map<String, dynamic>),
      driverProfile: json['driver_profile'] == null
          ? null
          : DriverProfile.fromJson(
              json['driver_profile'] as Map<String, dynamic>),
      userLinks: (json['user_links'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((e) => PersonContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PerfilImplToJson(_$PerfilImpl instance) =>
    <String, dynamic>{
      'person': instance.person,
      'driver_profile': instance.driverProfile,
      'user_links': instance.userLinks,
      'contacts': instance.contacts,
    };
