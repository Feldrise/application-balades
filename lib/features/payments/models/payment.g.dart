// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  stripePaymentIntentId: json['stripe_payment_intent_id'] as String,
  stripeChargeId: json['stripe_charge_id'] as String?,
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  paymentMethod: json['payment_method'] as String,
  registrationId: (json['registration_id'] as num?)?.toInt(),
  groupId: (json['group_id'] as num?)?.toInt(),
  payerEmail: json['payer_email'] as String,
  payerName: json['payer_name'] as String,
  guideId: (json['guide_id'] as num).toInt(),
  paidAt: const DateSerializer().fromJson(json['paid_at'] as String?),
  refundedAt: const DateSerializer().fromJson(json['refunded_at'] as String?),
  refundAmount: (json['refund_amount'] as num?)?.toInt(),
  registration: json['registration'] == null
      ? null
      : Registration.fromJson(json['registration'] as Map<String, dynamic>),
  group: json['group'] == null
      ? null
      : RegistrationGroup.fromJson(json['group'] as Map<String, dynamic>),
  guide: json['guide'] == null
      ? null
      : Guide.fromJson(json['guide'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'stripe_payment_intent_id': instance.stripePaymentIntentId,
  'stripe_charge_id': instance.stripeChargeId,
  'amount': instance.amount,
  'currency': instance.currency,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'payment_method': instance.paymentMethod,
  'registration_id': instance.registrationId,
  'group_id': instance.groupId,
  'payer_email': instance.payerEmail,
  'payer_name': instance.payerName,
  'guide_id': instance.guideId,
  'paid_at': const DateSerializer().toJson(instance.paidAt),
  'refunded_at': const DateSerializer().toJson(instance.refundedAt),
  'refund_amount': instance.refundAmount,
  'registration': instance.registration,
  'group': instance.group,
  'guide': instance.guide,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.succeeded: 'succeeded',
  PaymentStatus.failed: 'failed',
  PaymentStatus.cancelled: 'cancelled',
  PaymentStatus.refunded: 'refunded',
};

_RegistrationGroup _$RegistrationGroupFromJson(Map<String, dynamic> json) =>
    _RegistrationGroup(
      (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      primaryEmail: json['primary_email'] as String,
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
      registrations:
          (json['registrations'] as List<dynamic>?)
              ?.map((e) => Registration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Registration>[],
      participantCount: (json['participant_count'] as num).toInt(),
    );

Map<String, dynamic> _$RegistrationGroupToJson(
  _RegistrationGroup instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'primary_email': instance.primaryEmail,
  'status': instance.status,
  'registration_date': instance.registrationDate.toIso8601String(),
  'confirmation_date': const DateSerializer().toJson(instance.confirmationDate),
  'confirmation_deadline': const DateSerializer().toJson(
    instance.confirmationDeadline,
  ),
  'cancellation_date': const DateSerializer().toJson(instance.cancellationDate),
  'cancellation_reason': instance.cancellationReason,
  'ramble_id': instance.rambleId,
  'registrations': instance.registrations,
  'participant_count': instance.participantCount,
};

_PaymentCreationRequest _$PaymentCreationRequestFromJson(
  Map<String, dynamic> json,
) => _PaymentCreationRequest(
  registrationId: (json['registration_id'] as num?)?.toInt(),
  groupId: (json['group_id'] as num?)?.toInt(),
  priceLabel: json['price_label'] as String?,
  priceSelections: (json['price_selections'] as List<dynamic>?)
      ?.map((e) => PriceSelection.fromJson(e as Map<String, dynamic>))
      .toList(),
  payerEmail: json['payer_email'] as String,
  payerName: json['payer_name'] as String,
  returnUrl: json['return_url'] as String,
);

Map<String, dynamic> _$PaymentCreationRequestToJson(
  _PaymentCreationRequest instance,
) => <String, dynamic>{
  'registration_id': instance.registrationId,
  'group_id': instance.groupId,
  'price_label': instance.priceLabel,
  'price_selections': instance.priceSelections,
  'payer_email': instance.payerEmail,
  'payer_name': instance.payerName,
  'return_url': instance.returnUrl,
};

_PriceSelection _$PriceSelectionFromJson(Map<String, dynamic> json) =>
    _PriceSelection(
      priceLabel: json['price_label'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PriceSelectionToJson(_PriceSelection instance) =>
    <String, dynamic>{
      'price_label': instance.priceLabel,
      'quantity': instance.quantity,
    };

_PaymentCreationResponse _$PaymentCreationResponseFromJson(
  Map<String, dynamic> json,
) => _PaymentCreationResponse(
  payment: Payment.fromJson(json['payment'] as Map<String, dynamic>),
  clientSecret: json['client_secret'] as String,
  publishableKey: json['publishable_key'] as String,
);

Map<String, dynamic> _$PaymentCreationResponseToJson(
  _PaymentCreationResponse instance,
) => <String, dynamic>{
  'payment': instance.payment,
  'client_secret': instance.clientSecret,
  'publishable_key': instance.publishableKey,
};

_RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) =>
    _RefundRequest(
      amount: (json['amount'] as num?)?.toInt(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$RefundRequestToJson(_RefundRequest instance) =>
    <String, dynamic>{'amount': instance.amount, 'reason': instance.reason};
