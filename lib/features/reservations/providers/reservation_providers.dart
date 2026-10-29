import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_draft.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservationsServiceProvider = Provider<ReservationsService>((ref) => ReservationsService.instance);

/// The reservations of the connected booker.
final userReservationsProvider = FutureProvider.autoDispose<List<Reservation>>((ref) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(reservationsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return service.fetchUserReservations(token: authed.token);
});

/// One reservation of the connected booker, as the target of the link of the confirmation request.
final reservationProvider = FutureProvider.autoDispose.family<Reservation, int>((ref, id) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(reservationsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return service.fetchReservation(id, token: authed.token);
});

/// The ramble of a reservation, with its tariffs, places left and guides.
final reservationRambleProvider = FutureProvider.autoDispose.family<Ramble, int>((ref, rambleId) {
  return RamblesService.instance.fetchRamble(rambleId, authorization: ref.read(authenticationProvider)?.token);
});

/// The reservation being filled in for a ramble, shared by the counters on the ramble page and the form.
final reservationFormProvider = StateNotifierProvider.autoDispose.family<ReservationFormNotifier, ReservationFormState, Ramble>((ref, ramble) {
  return ReservationFormNotifier(ref.read(reservationsServiceProvider), ramble);
});

class ReservationFormState {
  const ReservationFormState({required this.draft, this.isSubmitting = false, this.error, this.created, this.existingReservationId});

  final ReservationDraft draft;
  final bool isSubmitting;
  final String? error;

  /// Set once the API has accepted the reservation.
  final Reservation? created;

  /// Set when the booker already has a reservation for this ramble.
  final int? existingReservationId;

  ReservationFormState copyWith({ReservationDraft? draft, bool? isSubmitting, String? error, Reservation? created, int? existingReservationId}) {
    return ReservationFormState(draft: draft ?? this.draft, isSubmitting: isSubmitting ?? this.isSubmitting, error: error, created: created ?? this.created, existingReservationId: existingReservationId);
  }
}

class ReservationFormNotifier extends StateNotifier<ReservationFormState> {
  ReservationFormNotifier(this._service, this._ramble) : super(ReservationFormState(draft: ReservationDraft.forRamble(_ramble)));

  final ReservationsService _service;
  final Ramble _ramble;

  void increment(String priceLabel) => _update((draft) => draft.increment(priceLabel));

  void decrement(String priceLabel) => _update((draft) => draft.decrement(priceLabel));

  void removeParticipant(int index) => _update((draft) => draft.removeParticipant(index));

  void updateParticipant(int index, {String? firstName, String? lastName, String? priceLabel, bool? isBooker}) {
    _update((draft) => draft.withParticipant(index, firstName: firstName, lastName: lastName, priceLabel: priceLabel, isBooker: isBooker));
  }

  void prefill({required String firstName, required String lastName}) => _update((draft) => draft.prefilledWith(firstName: firstName, lastName: lastName));

  Future<void> submit({required String contactEmail, String? contactPhone}) async {
    state = state.copyWith(isSubmitting: true);

    try {
      final request = state.draft.toRequest(rambleId: _ramble.id, contactEmail: contactEmail, contactPhone: contactPhone);
      final reservation = await _service.createReservation(request);
      state = state.copyWith(isSubmitting: false, created: reservation);
    } on ReservationAlreadyExistsException catch (e) {
      state = state.copyWith(isSubmitting: false, existingReservationId: e.reservationId);
    } on ReservationException catch (e) {
      state = state.copyWith(isSubmitting: false, error: _messageFor(e));
    } catch (_) {
      state = state.copyWith(isSubmitting: false, error: 'Impossible de joindre le serveur. Réessayez dans un instant.');
    }
  }

  void reset() => state = ReservationFormState(draft: ReservationDraft.forRamble(_ramble));

  void _update(ReservationDraft Function(ReservationDraft) change) {
    state = state.copyWith(draft: change(state.draft));
  }

  String _messageFor(ReservationException error) {
    switch (error.reason) {
      case 'too_many_participants':
        return 'Une réservation ne peut pas compter plus de ${_ramble.maxParticipantsPerReservation} participants pour cette balade.';
      case 'invalid_price':
        return 'Chaque participant doit avoir un tarif de cette balade.';
      default:
        return error.message;
    }
  }
}

/// The current time for the reservation rules, replaced in tests.
final reservationClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
