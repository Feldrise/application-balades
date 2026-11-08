import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The feuille de balade: a balade and all its reservations.
class RambleSheet {
  const RambleSheet(this.ramble, this.reservations);

  final Ramble ramble;
  final List<Reservation> reservations;

  /// The reservations whose participants are expected at the balade: confirmed first, then pending.
  List<Reservation> get expected => [..._withStatus(ReservationStatus.confirmed), ..._withStatus(ReservationStatus.pending)];

  List<Reservation> get waitingList => _withStatus(ReservationStatus.waitingList);

  List<Reservation> get cancelled => _withStatus(ReservationStatus.cancelled);

  List<Participant> get expectedParticipants => [for (final r in expected) ...r.participants];

  /// The places taken: the participants of the pending and confirmed reservations.
  int get placesTaken => expectedParticipants.length;

  int get presentCount => expectedParticipants.where((p) => p.present == true).length;

  int count(ReservationStatus status) => _withStatus(status).length;

  List<Reservation> _withStatus(ReservationStatus status) => reservations.where((r) => r.status == status.apiValue).toList();
}

final rambleSheetProvider = FutureProvider.autoDispose.family<RambleSheet, int>((ref, rambleId) async {
  final token = ref.watch(authenticationProvider)?.token;
  final service = ref.read(reservationsServiceProvider);
  final results = await Future.wait([
    RamblesService.instance.fetchRamble(rambleId, includeUnpublished: true, authorization: token),
    if (token != null)
      service
          .fetchAdminReservations(
            token: token,
            filter: AdminReservationFilter(rambleId: rambleId),
            perPage: 500,
          )
          .then((list) => list.reservations),
  ]);
  return RambleSheet(results[0] as Ramble, results.length > 1 ? results[1] as List<Reservation> : const []);
});
