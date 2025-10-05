// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_action_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BulkRegistrationActionPayload _$BulkRegistrationActionPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkRegistrationActionPayload(
  registrationIds: (json['registration_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  action: json['action'] as String,
  reason: json['reason'] as String?,
  sendEmail: json['send_email'] as bool? ?? false,
);

Map<String, dynamic> _$BulkRegistrationActionPayloadToJson(
  _BulkRegistrationActionPayload instance,
) => <String, dynamic>{
  'registration_ids': instance.registrationIds,
  'action': instance.action,
  'reason': instance.reason,
  'send_email': instance.sendEmail,
};
