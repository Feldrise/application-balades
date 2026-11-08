import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/create_reservation_request.dart';

/// A participant line of the reservation being filled in.
class DraftParticipant {
  DraftParticipant({this.firstName = '', this.lastName = '', this.priceLabel = '', this.isBooker = false, int? key}) : key = key ?? _nextKey++;

  static int _nextKey = 0;

  /// Identifies the line across edits, so the form keeps the right fields when lines are removed.
  final int key;
  final String firstName;
  final String lastName;
  final String priceLabel;
  final bool isBooker;

  bool get isBlank => firstName.trim().isEmpty && lastName.trim().isEmpty;

  DraftParticipant copyWith({String? firstName, String? lastName, String? priceLabel, bool? isBooker}) =>
      DraftParticipant(key: key, firstName: firstName ?? this.firstName, lastName: lastName ?? this.lastName, priceLabel: priceLabel ?? this.priceLabel, isBooker: isBooker ?? this.isBooker);
}

/// The reservation being filled in: one line per participant, with the counters per
/// tariff, the estimated amount and the waiting list warning derived from the lines.
///
/// The server stays the authority: [maxParticipants] is the API's per-reservation limit,
/// and the amount is only an estimate for display.
class ReservationDraft {
  ReservationDraft({required this.prices, required this.maxParticipants, this.placesLeft, List<DraftParticipant>? participants})
    : participants = List.unmodifiable(participants ?? [DraftParticipant(priceLabel: prices.isEmpty ? '' : prices.first.label)]);

  factory ReservationDraft.forRamble(Ramble ramble) => ReservationDraft(prices: ramble.prices, placesLeft: ramble.placesLeft, maxParticipants: ramble.maxParticipantsPerReservation);

  final List<RamblePrice> prices;
  final int? placesLeft;
  final int maxParticipants;
  final List<DraftParticipant> participants;

  /// Free or single-price rambles show one "Personnes" counter instead of one per tariff.
  bool get hasTariffChoice => prices.length > 1;

  int get total => participants.length;

  int countFor(String priceLabel) => participants.where((p) => p.priceLabel == priceLabel).length;

  bool get canIncrement => total < maxParticipants;

  bool canDecrement(String priceLabel) => total > 1 && countFor(priceLabel) > 0;

  ReservationDraft increment(String priceLabel) {
    if (!canIncrement) return this;
    return _with([...participants, DraftParticipant(priceLabel: priceLabel)]);
  }

  /// Drops the last blank line of this tariff if there is one, so typed names are kept.
  ReservationDraft decrement(String priceLabel) {
    if (!canDecrement(priceLabel)) return this;

    final lines = [...participants];
    final blank = lines.lastIndexWhere((p) => p.priceLabel == priceLabel && p.isBlank);
    lines.removeAt(blank != -1 ? blank : lines.lastIndexWhere((p) => p.priceLabel == priceLabel));
    return _with(lines);
  }

  ReservationDraft removeParticipant(int index) {
    if (total <= 1 || index < 0 || index >= total) return this;
    return _with([...participants]..removeAt(index));
  }

  /// Updates a line. Making a line the booker unmarks the others.
  ReservationDraft withParticipant(int index, {String? firstName, String? lastName, String? priceLabel, bool? isBooker}) {
    if (index < 0 || index >= total) return this;

    final lines = [...participants];
    lines[index] = lines[index].copyWith(firstName: firstName, lastName: lastName, priceLabel: priceLabel, isBooker: isBooker);
    if (isBooker == true) {
      for (var i = 0; i < lines.length; i++) {
        if (i != index) lines[i] = lines[i].copyWith(isBooker: false);
      }
    }
    return _with(lines);
  }

  /// Fills the first line with the connected user, unless it already has something typed in.
  ReservationDraft prefilledWith({required String firstName, required String lastName}) {
    if (!participants.first.isBlank) return this;
    return withParticipant(0, firstName: firstName, lastName: lastName, isBooker: true);
  }

  /// Estimated amount in cents, from the ramble's tariffs.
  int get estimatedAmountCents {
    var cents = 0;
    for (final participant in participants) {
      for (final price in prices) {
        if (price.label == participant.priceLabel) cents += (price.amount * 100).round();
      }
    }
    return cents;
  }

  /// Everybody goes to the waiting list, never just some participants, when they do not all fit.
  bool get goesToWaitingList => placesLeft != null && total > placesLeft!;

  CreateReservationRequest toRequest({required int rambleId, required String contactEmail, String? contactPhone}) {
    final phone = contactPhone?.trim() ?? '';
    return CreateReservationRequest(
      rambleId: rambleId,
      contactEmail: contactEmail.trim(),
      contactPhone: phone.isEmpty ? null : phone,
      participants: [
        for (final p in participants) ParticipantRequest(firstName: p.firstName.trim(), lastName: p.lastName.trim(), priceLabel: p.priceLabel, isBooker: p.isBooker),
      ],
    );
  }

  ReservationDraft _with(List<DraftParticipant> lines) => ReservationDraft(prices: prices, placesLeft: placesLeft, maxParticipants: maxParticipants, participants: lines);
}
