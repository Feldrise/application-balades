import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/widgets/reservation_counters.dart';
import 'package:balade/features/reservations/widgets/reservation_form_sheet.dart';
import 'package:balade/features/reservations/widgets/reservation_notices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The "Réserver" block of the ramble page: counters per tariff, places left and what happens at J-3.
class RambleRegistrationSection extends StatelessWidget {
  const RambleRegistrationSection({super.key, required this.ramble, this.onShare, this.isCompact = false});

  final Ramble ramble;
  final VoidCallback? onShare;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_available, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text('Réserver', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            if (ramble.date != null && !isCompact) ...[_buildDate(theme, colorScheme), const SizedBox(height: 12)],
            _buildStatus(context, theme),
            if (_canReserve) ...[
              const SizedBox(height: 16),
              ReservationCounters(ramble: ramble),
              const SizedBox(height: 12),
              const ReservationNotice(icon: Icons.info_outline, message: kConfirmationNotice),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(flex: 2, child: _buildActionButton(context)),
                if (onShare != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShare,
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Partager'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDate(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(Icons.event, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '${DateFormat('EEEE dd MMMM yyyy', 'fr').format(ramble.date!)} à ${DateFormat('HH:mm').format(ramble.date!)}',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildStatus(BuildContext context, ThemeData theme) {
    final color = _statusColor(theme.colorScheme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Icon(_statusIcon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(_statusText, style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: _canReserve ? () => _showReservationForm(context) : null,
      icon: Icon(_buttonIcon),
      label: Text(_buttonText),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
    );
  }

  void _showReservationForm(BuildContext context) {
    showModalBottomSheet<void>(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => ReservationFormSheet(ramble: ramble));
  }

  bool get _isPast => ramble.date != null && ramble.date!.isBefore(DateTime.now());

  bool get _isFull => ramble.placesLeft != null && ramble.placesLeft! <= 0;

  bool get _canReserve => !ramble.isCancelled && ramble.isPublished && !_isPast;

  IconData get _buttonIcon {
    if (ramble.isCancelled) return Icons.block;
    if (!ramble.isPublished) return Icons.visibility_off;
    if (_isPast) return Icons.schedule;
    return _isFull ? Icons.queue : Icons.event_available;
  }

  String get _buttonText {
    if (ramble.isCancelled) return 'Annulée';
    if (!ramble.isPublished) return ramble.isDraft ? 'Brouillon' : 'Publication planifiée';
    if (_isPast) return 'Passée';
    return _isFull ? 'Réserver en liste d\'attente' : 'Réserver';
  }

  IconData get _statusIcon {
    if (ramble.isCancelled) return Icons.cancel;
    if (!ramble.isPublished) return Icons.visibility_off;
    if (_isPast) return Icons.schedule;
    return _isFull ? Icons.queue : Icons.event_seat;
  }

  Color _statusColor(ColorScheme colorScheme) {
    if (ramble.isCancelled) return colorScheme.error;
    if (!ramble.isPublished || _isPast) return Colors.grey;
    return _isFull ? Colors.orange : Colors.green;
  }

  String get _statusText {
    if (ramble.isCancelled) return 'Balade annulée';
    if (!ramble.isPublished) return ramble.isDraft ? 'Balade en brouillon — réservations fermées' : 'Publication planifiée — réservations fermées';
    if (_isPast) return 'Balade passée';
    if (ramble.placesLeft == null) return 'Places illimitées';
    if (_isFull) return 'Complet — réservation en liste d\'attente';
    return ramble.placesLeft == 1 ? '1 place restante' : '${ramble.placesLeft} places restantes';
  }
}
