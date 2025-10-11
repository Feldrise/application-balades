import 'package:balade/core/serializers.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment(
    int id, {
    @JsonKey(name: 'created_at') @DateSerializer() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateSerializer() required DateTime updatedAt,
    @JsonKey(name: 'stripe_payment_intent_id') required String stripePaymentIntentId,
    @JsonKey(name: 'stripe_charge_id') String? stripeChargeId,
    required int amount, // Amount in cents
    required String currency,
    required PaymentStatus status,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'registration_id') int? registrationId,
    @JsonKey(name: 'group_id') int? groupId,
    @JsonKey(name: 'payer_email') required String payerEmail,
    @JsonKey(name: 'payer_name') required String payerName,
    @JsonKey(name: 'guide_id') required int guideId,
    @JsonKey(name: 'paid_at') @DateSerializer() DateTime? paidAt,
    @JsonKey(name: 'refunded_at') @DateSerializer() DateTime? refundedAt,
    @JsonKey(name: 'refund_amount') int? refundAmount,
    Registration? registration,
    @JsonKey(name: 'group') RegistrationGroup? group,
    Guide? guide,
  }) = _Payment;

  factory Payment.fromJson(Map<String, Object?> json) => _$PaymentFromJson(json);
}

@freezed
abstract class RegistrationGroup with _$RegistrationGroup {
  const factory RegistrationGroup(
    int id, {
    @JsonKey(name: 'created_at') @DateSerializer() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateSerializer() required DateTime updatedAt,
    @JsonKey(name: 'primary_email') required String primaryEmail,
    required String status,
    @JsonKey(name: 'registration_date') @DateSerializer() required DateTime registrationDate,
    @JsonKey(name: 'confirmation_date') @DateSerializer() DateTime? confirmationDate,
    @JsonKey(name: 'confirmation_deadline') @DateSerializer() DateTime? confirmationDeadline,
    @JsonKey(name: 'cancellation_date') @DateSerializer() DateTime? cancellationDate,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'ramble_id') required int rambleId,
    @Default(<Registration>[]) List<Registration> registrations,
    @JsonKey(name: 'participant_count') required int participantCount,
  }) = _RegistrationGroup;

  factory RegistrationGroup.fromJson(Map<String, Object?> json) => _$RegistrationGroupFromJson(json);
}

@freezed
abstract class PaymentCreationRequest with _$PaymentCreationRequest {
  const factory PaymentCreationRequest({
    @JsonKey(name: 'registration_id') int? registrationId,
    @JsonKey(name: 'group_id') int? groupId,
    @JsonKey(name: 'price_label') String? priceLabel, // Deprecated: for backward compatibility
    @JsonKey(name: 'price_selections') List<PriceSelection>? priceSelections, // For group payments with multiple prices
    @JsonKey(name: 'payer_email') required String payerEmail,
    @JsonKey(name: 'payer_name') required String payerName,
    @JsonKey(name: 'return_url') required String returnUrl,
  }) = _PaymentCreationRequest;

  factory PaymentCreationRequest.fromJson(Map<String, Object?> json) => _$PaymentCreationRequestFromJson(json);
}

@freezed
abstract class PriceSelection with _$PriceSelection {
  const factory PriceSelection({@JsonKey(name: 'price_label') required String priceLabel, required int quantity}) = _PriceSelection;

  factory PriceSelection.fromJson(Map<String, Object?> json) => _$PriceSelectionFromJson(json);
}

@freezed
abstract class PaymentCreationResponse with _$PaymentCreationResponse {
  const factory PaymentCreationResponse({
    required Payment payment,
    @JsonKey(name: 'client_secret') required String clientSecret,
    @JsonKey(name: 'publishable_key') required String publishableKey,
  }) = _PaymentCreationResponse;

  factory PaymentCreationResponse.fromJson(Map<String, Object?> json) => _$PaymentCreationResponseFromJson(json);
}

@freezed
abstract class RefundRequest with _$RefundRequest {
  const factory RefundRequest({
    int? amount, // Amount in cents, null for full refund
    String? reason,
  }) = _RefundRequest;

  factory RefundRequest.fromJson(Map<String, Object?> json) => _$RefundRequestFromJson(json);
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('succeeded')
  succeeded,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded,
}

// Extension to get user-friendly labels
extension PaymentStatusExtension on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.pending:
        return 'En attente';
      case PaymentStatus.succeeded:
        return 'Payé';
      case PaymentStatus.failed:
        return 'Échec';
      case PaymentStatus.cancelled:
        return 'Annulé';
      case PaymentStatus.refunded:
        return 'Remboursé';
    }
  }

  bool get isPaid => this == PaymentStatus.succeeded;
  bool get isPending => this == PaymentStatus.pending;
  bool get isFailed => this == PaymentStatus.failed || this == PaymentStatus.cancelled;
}
