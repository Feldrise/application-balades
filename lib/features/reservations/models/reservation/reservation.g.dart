// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reservation _$ReservationFromJson(Map<String, dynamic> json) => _Reservation(
  (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  rambleId: (json['ramble_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  contactEmail: json['contact_email'] as String,
  status: json['status'] as String,
  confirmationDeadline: const DateSerializer().fromJson(
    json['confirmation_deadline'] as String?,
  ),
  confirmationDate: const DateSerializer().fromJson(
    json['confirmation_date'] as String?,
  ),
  cancellationDate: const DateSerializer().fromJson(
    json['cancellation_date'] as String?,
  ),
  cancellationReason: json['cancellation_reason'] as String?,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Participant>[],
  estimatedAmount: (json['estimated_amount'] as num?)?.toInt() ?? 0,
  hasMissingPrices: json['has_missing_prices'] as bool? ?? false,
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => ReservationPayment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReservationPayment>[],
  hasSuccessfulPayment: json['has_successful_payment'] as bool? ?? false,
  ramble: json['ramble'] == null
      ? null
      : ReservationRambleSummary.fromJson(
          json['ramble'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ReservationToJson(
  _Reservation instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'ramble_id': instance.rambleId,
  'user_id': instance.userId,
  'contact_email': instance.contactEmail,
  'status': instance.status,
  'confirmation_deadline': const DateSerializer().toJson(
    instance.confirmationDeadline,
  ),
  'confirmation_date': const DateSerializer().toJson(instance.confirmationDate),
  'cancellation_date': const DateSerializer().toJson(instance.cancellationDate),
  'cancellation_reason': instance.cancellationReason,
  'participants': instance.participants,
  'estimated_amount': instance.estimatedAmount,
  'has_missing_prices': instance.hasMissingPrices,
  'payments': instance.payments,
  'has_successful_payment': instance.hasSuccessfulPayment,
  'ramble': instance.ramble,
};

_Participant _$ParticipantFromJson(Map<String, dynamic> json) => _Participant(
  (json['id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  priceLabel: json['price_label'] as String? ?? '',
  priceAmount: (json['price_amount'] as num?)?.toDouble() ?? 0.0,
  priceMissing: json['price_missing'] as bool? ?? false,
  isBooker: json['is_booker'] as bool? ?? false,
);

Map<String, dynamic> _$ParticipantToJson(_Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'price_label': instance.priceLabel,
      'price_amount': instance.priceAmount,
      'price_missing': instance.priceMissing,
      'is_booker': instance.isBooker,
    };

_ReservationPayment _$ReservationPaymentFromJson(Map<String, dynamic> json) =>
    _ReservationPayment(
      (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paidAt: const DateSerializer().fromJson(json['paid_at'] as String?),
      refundedAt: const DateSerializer().fromJson(
        json['refunded_at'] as String?,
      ),
      refundAmount: (json['refund_amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReservationPaymentToJson(_ReservationPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'paid_at': const DateSerializer().toJson(instance.paidAt),
      'refunded_at': const DateSerializer().toJson(instance.refundedAt),
      'refund_amount': instance.refundAmount,
    };

_ReservationRambleSummary _$ReservationRambleSummaryFromJson(
  Map<String, dynamic> json,
) => _ReservationRambleSummary(
  title: json['title'] as String,
  date: const DateSerializer().fromJson(json['date'] as String?),
  location: json['location'] as String?,
);

Map<String, dynamic> _$ReservationRambleSummaryToJson(
  _ReservationRambleSummary instance,
) => <String, dynamic>{
  'title': instance.title,
  'date': const DateSerializer().toJson(instance.date),
  'location': instance.location,
};
