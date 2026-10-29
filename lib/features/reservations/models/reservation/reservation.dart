import 'package:balade/core/serializers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

@freezed
abstract class Reservation with _$Reservation {
  const factory Reservation(
    int id, {
    @JsonKey(name: 'created_at') @DateSerializer() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateSerializer() required DateTime updatedAt,
    @JsonKey(name: 'ramble_id') required int rambleId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'contact_email') required String contactEmail,
    required String status,
    @JsonKey(name: 'confirmation_deadline') @DateSerializer() DateTime? confirmationDeadline,
    @JsonKey(name: 'confirmation_date') @DateSerializer() DateTime? confirmationDate,
    @JsonKey(name: 'cancellation_date') @DateSerializer() DateTime? cancellationDate,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @Default(<Participant>[]) List<Participant> participants,
    // Amount in cents, computed by the API from the participants' prices
    @JsonKey(name: 'estimated_amount') @Default(0) int estimatedAmount,
    @Default(<ReservationPayment>[]) List<ReservationPayment> payments,
    ReservationRambleSummary? ramble,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, Object?> json) => _$ReservationFromJson(json);
}

@freezed
abstract class Participant with _$Participant {
  const factory Participant(
    int id, {
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'price_label') @Default('') String priceLabel,
    // Amount in euros
    @JsonKey(name: 'price_amount') @Default(0.0) double priceAmount,
    @JsonKey(name: 'is_booker') @Default(false) bool isBooker,
  }) = _Participant;

  factory Participant.fromJson(Map<String, Object?> json) => _$ParticipantFromJson(json);
}

@freezed
abstract class ReservationPayment with _$ReservationPayment {
  const factory ReservationPayment(
    int id, {
    @JsonKey(name: 'created_at') @DateSerializer() required DateTime createdAt,
    // Amount in cents
    required int amount,
    required String currency,
    required String status,
    @JsonKey(name: 'paid_at') @DateSerializer() DateTime? paidAt,
    @JsonKey(name: 'refunded_at') @DateSerializer() DateTime? refundedAt,
    @JsonKey(name: 'refund_amount') int? refundAmount,
  }) = _ReservationPayment;

  factory ReservationPayment.fromJson(Map<String, Object?> json) => _$ReservationPaymentFromJson(json);
}

@freezed
abstract class ReservationRambleSummary with _$ReservationRambleSummary {
  const factory ReservationRambleSummary({required String title, @DateSerializer() DateTime? date, String? location}) = _ReservationRambleSummary;

  factory ReservationRambleSummary.fromJson(Map<String, Object?> json) => _$ReservationRambleSummaryFromJson(json);
}

enum ReservationStatus {
  pending,
  @JsonValue('waiting_list')
  waitingList,
  confirmed,
  cancelled;

  static ReservationStatus? tryParse(String value) {
    for (final status in values) {
      if (status.apiValue == value) return status;
    }
    return null;
  }

  String get apiValue => this == waitingList ? 'waiting_list' : name;

  String get label {
    switch (this) {
      case ReservationStatus.pending:
        return 'En attente de confirmation';
      case ReservationStatus.waitingList:
        return 'Liste d\'attente';
      case ReservationStatus.confirmed:
        return 'Confirmée';
      case ReservationStatus.cancelled:
        return 'Annulée';
    }
  }
}
