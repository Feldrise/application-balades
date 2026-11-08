// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reservation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateReservationRequest _$CreateReservationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateReservationRequest(
  rambleId: (json['ramble_id'] as num).toInt(),
  contactEmail: json['contact_email'] as String,
  contactPhone: json['contact_phone'] as String?,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => ParticipantRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CreateReservationRequestToJson(
  _CreateReservationRequest instance,
) => <String, dynamic>{
  'ramble_id': instance.rambleId,
  'contact_email': instance.contactEmail,
  'contact_phone': ?instance.contactPhone,
  'participants': instance.participants,
};

_ParticipantRequest _$ParticipantRequestFromJson(Map<String, dynamic> json) =>
    _ParticipantRequest(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      priceLabel: json['price_label'] as String? ?? '',
      isBooker: json['is_booker'] as bool? ?? false,
    );

Map<String, dynamic> _$ParticipantRequestToJson(_ParticipantRequest instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'price_label': instance.priceLabel,
      'is_booker': instance.isBooker,
    };
