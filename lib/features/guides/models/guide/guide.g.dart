// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Guide _$GuideFromJson(Map<String, dynamic> json) => _Guide(
  (json['id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  bio: json['bio'] as String?,
  experience: json['experience'] as String?,
  specialties: json['specialties'] as String?,
  languages: json['languages'] as String?,
  certificationLevel: json['certification_level'] as String?,
  avatar: json['avatar'] as String?,
  isActive: json['is_active'] as bool,
  emergencyContactName: json['emergency_contact_name'] as String?,
  emergencyContactPhone: json['emergency_contact_phone'] as String?,
  stripeAccountId: json['stripe_account_id'] as String?,
  stripePublicKey: json['stripe_public_key'] as String?,
  paymentEnabled: json['payment_enabled'] as bool? ?? false,
);

Map<String, dynamic> _$GuideToJson(_Guide instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'bio': instance.bio,
  'experience': instance.experience,
  'specialties': instance.specialties,
  'languages': instance.languages,
  'certification_level': instance.certificationLevel,
  'avatar': instance.avatar,
  'is_active': instance.isActive,
  'emergency_contact_name': instance.emergencyContactName,
  'emergency_contact_phone': instance.emergencyContactPhone,
  'stripe_account_id': instance.stripeAccountId,
  'stripe_public_key': instance.stripePublicKey,
  'payment_enabled': instance.paymentEnabled,
};
