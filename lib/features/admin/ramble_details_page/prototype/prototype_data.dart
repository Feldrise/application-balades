// PROTOTYPE — throwaway. Three visual directions for the espace de gestion, on the existing
// /admin/balade/:id route (and /admin list), switchable via ?variant=A|B|C.
//
// Shared, read-only data loading and stubbed "présent" state for the variants. No mutation hits the API.

import 'dart:async';

import 'package:balade/core/constants.dart';
import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProtoSheet {
  ProtoSheet(this.ramble, this.reservations);

  final Ramble ramble;
  final List<Reservation> reservations;

  /// Reservations shown on the sheet: confirmed first, then pending, waiting list, cancelled last.
  List<Reservation> get ordered {
    const order = {'confirmed': 0, 'pending': 1, 'waiting_list': 2, 'cancelled': 3};
    final list = reservations.toList()..sort((a, b) => (order[a.status] ?? 9).compareTo(order[b.status] ?? 9));
    return list;
  }

  List<Reservation> get coming => reservations.where((r) => r.status == 'confirmed' || r.status == 'pending').toList();

  int get placesTaken => coming.fold(0, (sum, r) => sum + r.participants.length);

  List<Participant> get comingParticipants => [for (final r in coming) ...r.participants];

  int count(String status) => reservations.where((r) => r.status == status).length;
}

final protoSheetProvider = FutureProvider.family<ProtoSheet, int>((ref, id) async {
  final token = ref.read(authenticationProvider)?.token;
  final ramble = await RamblesService.instance.fetchRamble(id, includeUnpublished: true, authorization: token);
  final reservations = token == null
      ? <Reservation>[]
      : (await ReservationsService.instance.fetchAdminReservations(token: token, filter: AdminReservationFilter(rambleId: id), perPage: 500)).reservations;
  return ProtoSheet(ramble, reservations);
});

final protoRamblesProvider = FutureProvider<List<Ramble>>((ref) async {
  final token = ref.read(authenticationProvider)?.token;
  final list = await RamblesService.instance.fetchRambles(includeUnpublished: true, authorization: token);
  final now = DateTime.now().subtract(const Duration(hours: 12));
  return list.where((r) => r.date == null || r.date!.isAfter(now)).toList()..sort((a, b) => (a.date ?? DateTime(2100)).compareTo(b.date ?? DateTime(2100)));
});

/// Stubbed roll-call: local only, with a fake sync queue to show the poor-network behaviour.
class PresenceController extends ChangeNotifier {
  final Set<int> present = {};
  int pending = 0;
  bool offline = true;
  Timer? _timer;

  bool isPresent(int participantId) => present.contains(participantId);

  void toggle(int participantId) {
    if (!present.remove(participantId)) present.add(participantId);
    pending++;
    _scheduleSync();
    notifyListeners();
  }

  void toggleNetwork() {
    offline = !offline;
    _scheduleSync();
    notifyListeners();
  }

  void _scheduleSync() {
    _timer?.cancel();
    if (offline) return;
    _timer = Timer(const Duration(milliseconds: 1500), () {
      pending = 0;
      notifyListeners();
    });
  }

  String get syncLabel {
    if (pending == 0) return offline ? 'Hors ligne · tout est enregistré sur le téléphone' : 'Synchronisé';
    return offline ? 'Hors ligne · $pending pointage${pending > 1 ? 's' : ''} en attente' : 'Synchronisation…';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ——— Formatting helpers (French, without locale data) ———

const _days = ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'];
const _months = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
const _shortMonths = ['janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'];

String two(int v) => v.toString().padLeft(2, '0');

String frTime(DateTime? d) => d == null ? '' : '${two(d.hour)}h${two(d.minute)}';

String frLongDate(DateTime? d) => d == null ? 'Date à définir' : '${_days[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';

String frShortDate(DateTime? d) => d == null ? '—' : '${d.day} ${_shortMonths[d.month - 1]}';

String frDayName(DateTime? d) => d == null ? '' : _days[d.weekday - 1].substring(0, 3);

String coverUrl(Ramble r) => r.coverImage == null || r.coverImage!.isEmpty ? '' : '$kBaseUrl/uploads/ramble/${r.id}/${r.coverImage}';

String guideNames(Ramble r) => r.guides.isEmpty ? 'Sans guide' : r.guides.map((g) => g.firstName).join(', ');

String durationLabel(Duration? d) {
  if (d == null) return '';
  final h = d.inHours;
  final m = d.inMinutes % 60;
  return m == 0 ? '${h}h' : '${h}h${two(m)}';
}

String statusLabel(String status) => switch (status) {
  'confirmed' => 'Confirmée',
  'pending' => 'À confirmer',
  'waiting_list' => 'Liste d\'attente',
  'cancelled' => 'Annulée',
  _ => status,
};

/// Publication state of a ramble, for the list.
(String, Color) publicationState(Ramble r) {
  if (r.isCancelled) return ('Annulée', const Color(0xffb3261e));
  if (r.isDraft) return ('Brouillon', const Color(0xff6b6b6b));
  if (r.isScheduled) return ('Programmée', const Color(0xff8a5a00));
  return ('Publiée', const Color(0xff006d41));
}

enum Period { week, month, later }

Period periodOf(DateTime? d) {
  if (d == null) return Period.later;
  final now = DateTime.now();
  final days = d.difference(DateTime(now.year, now.month, now.day)).inDays;
  if (days < 7) return Period.week;
  if (days < 31) return Period.month;
  return Period.later;
}

String periodLabel(Period p) => switch (p) {
  Period.week => 'Cette semaine',
  Period.month => 'Ce mois-ci',
  Period.later => 'Plus tard',
};

Map<Period, List<Ramble>> groupByPeriod(List<Ramble> rambles) {
  final map = <Period, List<Ramble>>{};
  for (final r in rambles) {
    map.putIfAbsent(periodOf(r.date), () => []).add(r);
  }
  return map;
}

int takenOf(Ramble r) => r.maxParticipants == null || r.placesLeft == null ? 0 : (r.maxParticipants! - r.placesLeft!).clamp(0, r.maxParticipants!);

// ——— Actions (stubbed) ———

void protoSnack(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('Prototype · $what'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
}

void openMaps(BuildContext context, Ramble r) {
  final lat = r.meetingLatitude, lng = r.meetingLongitude;
  final q = lat != null && lng != null ? '$lat,$lng' : Uri.encodeComponent(r.meetingPoint ?? r.location ?? '');
  launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$q'));
}

void emailBooker(Reservation r) => launchUrl(Uri.parse('mailto:${r.contactEmail}'));

/// The booker's phone is not exposed by the admin reservations API yet: the call action stays stubbed.
void callBooker(BuildContext context, Reservation r) => protoSnack(context, 'appel (le téléphone de la personne qui réserve n\'est pas encore exposé par l\'API)');

Future<void> confirmCancelRamble(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Annuler la balade ?'),
      content: const Text(
        'Toutes les personnes qui ont réservé seront prévenues par email. '
        'La plateforme ne fait aucun remboursement automatique : les personnes ayant déjà payé seront invitées à vous contacter.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Garder la balade')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Annuler la balade'),
        ),
      ],
    ),
  );
  if (ok == true && context.mounted) protoSnack(context, 'balade annulée');
}

final protoReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  final token = ref.read(authenticationProvider)?.token;
  if (token == null) return [];
  return (await ReservationsService.instance.fetchAdminReservations(token: token, perPage: 500)).reservations;
});

String reservationPayLabel(Reservation r) {
  if (r.amountPaid > 0 && r.amountDue <= 0) return 'Payé ${formatCentsShort(r.amountPaid)}';
  if (r.hasMissingPrices && r.estimatedAmount == 0) return 'Tarif à préciser';
  return formatCentsShort(r.estimatedAmount);
}

bool isPaid(Reservation r) => r.amountPaid > 0 && r.amountDue <= 0;

String formatCentsShort(int cents) {
  if (cents == 0) return 'Gratuit';
  final rest = cents % 100;
  return rest == 0 ? '${cents ~/ 100} €' : '${cents ~/ 100},${two(rest)} €';
}

String rambleOf(Reservation r) => r.ramble == null ? 'Balade #${r.rambleId}' : r.ramble!.title;

String rambleDateOf(Reservation r) => r.ramble?.date == null ? '' : '${frShortDate(r.ramble!.date)} · ${frTime(r.ramble!.date)}';

String bookerOf(Reservation r) {
  for (final p in r.participants) {
    if (p.isBooker) return '${p.firstName} ${p.lastName}';
  }
  return r.participants.isEmpty ? r.contactEmail : '${r.participants.first.firstName} ${r.participants.first.lastName}';
}

const reservationStatuses = ['confirmed', 'pending', 'waiting_list', 'cancelled'];


// ——— Manual status change (stubbed), gated like today: admins, or users allowed to update the status ———

bool canChangeStatus(WidgetRef ref) {
  final permission = ref.watch(permissionProvider);
  return permission?.isAdmin() == true || permission?.canUpdateRegistrationStatus() == true;
}

/// Lets the user pick a new status for a reservation, confirming the consequential ones. Stubbed.
Future<void> changeStatusFlow(BuildContext context, Reservation r) async {
  final picked = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Text('Changer le statut', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text('${bookerOf(r)} · ${r.participants.length} participant${r.participants.length > 1 ? 's' : ''}', style: Theme.of(ctx).textTheme.bodySmall),
          ),
          for (final s in reservationStatuses)
            ListTile(
              leading: Icon(s == r.status ? Icons.radio_button_checked : Icons.radio_button_off, color: statusColor(s)),
              title: Text(statusLabel(s)),
              subtitle: Text(statusHint(s)),
              enabled: s != r.status,
              onTap: () => Navigator.pop(ctx, s),
            ),
        ],
      ),
    ),
  );
  if (picked == null || !context.mounted) return;
  final warning = switch (picked) {
    'cancelled' => isPaid(r)
        ? 'La personne qui réserve a déjà payé : la plateforme ne la remboursera pas automatiquement, elle sera invitée à vous contacter. Elle sera prévenue par email.'
        : 'Les places seront libérées et la personne qui réserve sera prévenue par email.',
    'confirmed' => 'La réservation sera confirmée sans passer par la confirmation de la personne qui réserve${r.amountDue > 0 ? ', et sans paiement en ligne' : ''}.',
    'waiting_list' => 'Les places seront libérées : la réservation passera en tête dès que la place le permet.',
    _ => null,
  };
  if (warning != null) {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Passer en « ${statusLabel(picked)} » ?'),
        content: Text(warning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Retour')),
          FilledButton(
            style: picked == 'cancelled' ? FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error) : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(picked == 'cancelled' ? 'Annuler la réservation' : 'Confirmer'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
  }
  protoSnack(context, 'statut changé en « ${statusLabel(picked)} »');
}

String statusHint(String s) => switch (s) {
  'confirmed' => 'Places réservées, la balade est maintenue pour elle',
  'pending' => 'Attend la confirmation de la personne qui réserve',
  'waiting_list' => 'Passe dès que les places le permettent',
  _ => 'Libère les places',
};

Color statusColor(String s) => switch (s) {
  'confirmed' => const Color(0xff0b6b3a),
  'pending' => const Color(0xff8a5a00),
  'waiting_list' => const Color(0xff34557a),
  _ => const Color(0xff9d2b1d),
};

/// Makes a status badge tappable to change the status, when the user is allowed to.
class StatusTap extends ConsumerWidget {
  const StatusTap({super.key, required this.reservation, required this.child});

  final Reservation reservation;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!canChangeStatus(ref)) return child;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => changeStatusFlow(context, reservation),
      child: Row(mainAxisSize: MainAxisSize.min, children: [child, const Icon(Icons.arrow_drop_down, size: 18)]),
    );
  }
}

/// A "Changer le statut" button for detail sheets, shown only when allowed.
class ChangeStatusButton extends ConsumerWidget {
  const ChangeStatusButton({super.key, required this.reservation, this.color});

  final Reservation reservation;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!canChangeStatus(ref)) return const SizedBox.shrink();
    return TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: color),
      onPressed: () => changeStatusFlow(context, reservation),
      icon: const Icon(Icons.swap_horiz, size: 18),
      label: const Text('Changer le statut'),
    );
  }
}
