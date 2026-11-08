import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// « Appeler » and « Écrire » for the booker of a reservation. « Appeler » is hidden when the booker gave no phone.
class BookerContactButtons extends StatelessWidget {
  const BookerContactButtons({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final phone = reservation.contactPhone?.trim() ?? '';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (phone.isNotEmpty)
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Appeler',
            onPressed: () => _open(context, Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[\s.]'), '')), 'Impossible de lancer l\'appel'),
            icon: const Icon(Icons.call_outlined, size: 20, color: ManagementColors.green),
          ),
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: 'Écrire',
          onPressed: () => _open(context, Uri(scheme: 'mailto', path: reservation.contactEmail), 'Impossible d\'ouvrir le client mail'),
          icon: const Icon(Icons.mail_outline, size: 20, color: ManagementColors.green),
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context, Uri uri, String failure) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) => false);
    if (!opened) messenger.showSnackBar(SnackBar(content: Text(failure)));
  }
}
