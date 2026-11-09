import 'package:balade/core/api_error_message.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/rambles_management/managed_rambles.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the meeting point of [ramble] in Maps: its coordinates when known, else its address, else its place.
Future<void> openMeetingPoint(BuildContext context, Ramble ramble) async {
  final lat = ramble.meetingLatitude, lng = ramble.meetingLongitude;
  String? filled(String? text) => (text?.trim().isEmpty ?? true) ? null : text!.trim();
  final query = lat != null && lng != null ? '$lat,$lng' : (filled(ramble.meetingPoint) ?? filled(ramble.location) ?? '');
  final uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': query});
  final messenger = ScaffoldMessenger.of(context);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) => false);
  if (!opened) messenger.showSnackBar(const SnackBar(content: Text('Impossible d\'ouvrir la carte')));
}

/// Asks for confirmation, with the reason the API requires, then cancels [ramble].
/// Bookers are told by email; there is no automatic refund (ADR 0002). Returns whether it was cancelled.
Future<bool> cancelRambleWithConfirmation(BuildContext context, WidgetRef ref, Ramble ramble) async {
  final reason = await showDialog<String>(context: context, builder: (context) => const _CancelRambleDialog());
  final token = ref.read(authenticationProvider)?.token;
  if (reason == null || token == null || !context.mounted) return false;

  final messenger = ScaffoldMessenger.of(context);
  try {
    await RamblesService.instance.cancelRamble(ramble.id, reason, authorization: token);
    ref.invalidate(managedRamblesProvider);
    messenger.showSnackBar(SnackBar(content: Text('Balade « ${ramble.title} » annulée')));
    return true;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Erreur lors de l\'annulation : ${parseApiErrorMessage(e)}')));
    return false;
  }
}

class _CancelRambleDialog extends StatefulWidget {
  const _CancelRambleDialog();

  @override
  State<_CancelRambleDialog> createState() => _CancelRambleDialogState();
}

class _CancelRambleDialogState extends State<_CancelRambleDialog> {
  final _reason = TextEditingController();
  bool _missingReason = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Annuler la balade ?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Toutes les personnes qui ont réservé seront prévenues par email. '
            'La plateforme ne fait aucun remboursement automatique : celles qui ont déjà payé seront invitées à contacter le guide.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reason,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Motif d\'annulation *',
              hintText: 'Indiqué aux personnes qui ont réservé',
              border: const OutlineInputBorder(),
              errorText: _missingReason ? 'Indiquez le motif de l\'annulation' : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Garder la balade')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: ManagementColors.cancelled),
          onPressed: () {
            final reason = _reason.text.trim();
            if (reason.isEmpty) return setState(() => _missingReason = true);
            Navigator.of(context).pop(reason);
          },
          child: const Text('Annuler la balade'),
        ),
      ],
    );
  }
}

/// Asks for the title and the date of the copy, duplicates [ramble] as a draft, then opens the copy in the form.
Future<void> duplicateRamble(BuildContext context, WidgetRef ref, Ramble ramble) async {
  final title = TextEditingController(text: '${ramble.title} (copie)');
  DateTime? date = ramble.date;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Dupliquer « ${ramble.title} »'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Titre de la copie', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          DateTimeFormField(
            initialValue: date,
            dateFormat: DateFormat('EEEE d MMMM yyyy à HH:mm', 'fr_FR'),
            decoration: const InputDecoration(labelText: 'Date de la balade', suffixIcon: Icon(Icons.calendar_today)),
            mode: DateTimeFieldPickerMode.dateAndTime,
            onChanged: (value) => date = value,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
        FilledButton.icon(onPressed: () => Navigator.of(context).pop(true), icon: const Icon(Icons.copy), label: const Text('Dupliquer')),
      ],
    ),
  );
  final copyTitle = title.text.trim();
  title.dispose();
  final token = ref.read(authenticationProvider)?.token;
  if (confirmed != true || token == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  try {
    final copy = await RamblesService.instance.duplicateRamble(ramble.id, title: copyTitle.isEmpty ? null : copyTitle, date: date, authorization: token);
    ref.invalidate(managedRamblesProvider);
    messenger.showSnackBar(SnackBar(content: Text('Balade dupliquée : « ${copy.title} » (brouillon)')));
    router.go('/admin/modifier-balade/${copy.id}');
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Erreur lors de la duplication : ${parseApiErrorMessage(e)}')));
  }
}

/// Copies the participants of [reservations] as CSV: one line per participant, with the contact and the status of its reservation.
void exportParticipants(BuildContext context, List<Reservation> reservations) {
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  String field(String value) => value.contains(RegExp('[",\n]')) ? '"${value.replaceAll('"', '""')}"' : value;
  final csv = StringBuffer('Prénom,Nom,Tarif,Email de contact,Téléphone,Statut,Date de réservation,Date de confirmation\n');
  for (final reservation in reservations) {
    for (final participant in reservation.participants) {
      csv.writeln(
        [
          participant.firstName,
          participant.lastName,
          participant.priceLabel,
          reservation.contactEmail,
          reservation.contactPhone ?? '',
          reservation.status,
          dateFormat.format(reservation.createdAt),
          reservation.confirmationDate != null ? dateFormat.format(reservation.confirmationDate!) : '',
        ].map(field).join(','),
      );
    }
  }
  Clipboard.setData(ClipboardData(text: csv.toString()));
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Participants copiés dans le presse-papiers (CSV)')));
}

/// Copies the emails of the bookers of [reservations].
void copyBookerEmails(BuildContext context, List<Reservation> reservations) {
  final emails = reservations.map((r) => r.contactEmail).toSet();
  Clipboard.setData(ClipboardData(text: emails.join(', ')));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${emails.length} email(s) copié(s)')));
}
