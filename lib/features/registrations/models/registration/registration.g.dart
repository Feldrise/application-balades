// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Registration _$RegistrationFromJson(Map<String, dynamic> json) =>
    _Registration(
      (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      registrationDate: DateTime.parse(json['registration_date'] as String),
      confirmationDate: const DateSerializer().fromJson(
        json['confirmation_date'] as String?,
      ),
      confirmationDeadline: const DateSerializer().fromJson(
        json['confirmation_deadline'] as String?,
      ),
      cancellationDate: const DateSerializer().fromJson(
        json['cancellation_date'] as String?,
      ),
      cancellationReason: json['cancellation_reason'] as String?,
      rambleId: (json['ramble_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt(),
      ramble: json['ramble'] == null
          ? null
          : RegistrationRambleSummary.fromJson(
              json['ramble'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RegistrationToJson(
  _Registration instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'status': instance.status,
  'registration_date': instance.registrationDate.toIso8601String(),
  'confirmation_date': const DateSerializer().toJson(instance.confirmationDate),
  'confirmation_deadline': const DateSerializer().toJson(
    instance.confirmationDeadline,
  ),
  'cancellation_date': const DateSerializer().toJson(instance.cancellationDate),
  'cancellation_reason': instance.cancellationReason,
  'ramble_id': instance.rambleId,
  'user_id': instance.userId,
  'group_id': instance.groupId,
  'ramble': instance.ramble,
};

_RegistrationRambleSummary _$RegistrationRambleSummaryFromJson(
  Map<String, dynamic> json,
) => _RegistrationRambleSummary(
  title: json['title'] as String,
  date: const DateSerializer().fromJson(json['date'] as String?),
  location: json['location'] as String?,
);

Map<String, dynamic> _$RegistrationRambleSummaryToJson(
  _RegistrationRambleSummary instance,
) => <String, dynamic>{
  'title': instance.title,
  'date': const DateSerializer().toJson(instance.date),
  'location': instance.location,
};

_RegistrationParticipant _$RegistrationParticipantFromJson(
  Map<String, dynamic> json,
) => _RegistrationParticipant(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$RegistrationParticipantToJson(
  _RegistrationParticipant instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
};

_CreateRegistrationRequest _$CreateRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateRegistrationRequest(
  rambleId: (json['ramble_id'] as num).toInt(),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => RegistrationParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
  primaryEmail: json['primary_email'] as String?,
);

Map<String, dynamic> _$CreateRegistrationRequestToJson(
  _CreateRegistrationRequest instance,
) => <String, dynamic>{
  'ramble_id': instance.rambleId,
  'participants': instance.participants,
  'primary_email': instance.primaryEmail,
};

_ConfirmRegistrationRequest _$ConfirmRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _ConfirmRegistrationRequest(confirmed: json['confirmed'] as bool);

Map<String, dynamic> _$ConfirmRegistrationRequestToJson(
  _ConfirmRegistrationRequest instance,
) => <String, dynamic>{'confirmed': instance.confirmed};

_CancelRegistrationRequest _$CancelRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _CancelRegistrationRequest(reason: json['reason'] as String?);

Map<String, dynamic> _$CancelRegistrationRequestToJson(
  _CancelRegistrationRequest instance,
) => <String, dynamic>{'reason': instance.reason};
