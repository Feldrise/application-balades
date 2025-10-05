// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminRegistrationListResponse _$AdminRegistrationListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminRegistrationListResponse(
  registrations: (json['registrations'] as List<dynamic>)
      .map((e) => Registration.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$AdminRegistrationListResponseToJson(
  _AdminRegistrationListResponse instance,
) => <String, dynamic>{
  'registrations': instance.registrations,
  'total': instance.total,
  'page': instance.page,
  'per_page': instance.perPage,
  'total_pages': instance.totalPages,
};

_AdminRegistrationUpdatePayload _$AdminRegistrationUpdatePayloadFromJson(
  Map<String, dynamic> json,
) => _AdminRegistrationUpdatePayload(
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  status: json['status'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AdminRegistrationUpdatePayloadToJson(
  _AdminRegistrationUpdatePayload instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'status': instance.status,
  'notes': instance.notes,
};

_AdminRegistrationStatusUpdatePayload
_$AdminRegistrationStatusUpdatePayloadFromJson(Map<String, dynamic> json) =>
    _AdminRegistrationStatusUpdatePayload(
      status: json['status'] as String,
      reason: json['reason'] as String?,
      sendEmail: json['send_email'] as bool? ?? false,
    );

Map<String, dynamic> _$AdminRegistrationStatusUpdatePayloadToJson(
  _AdminRegistrationStatusUpdatePayload instance,
) => <String, dynamic>{
  'status': instance.status,
  'reason': instance.reason,
  'send_email': instance.sendEmail,
};
