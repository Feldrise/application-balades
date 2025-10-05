import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/registrations/widgets/registration_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RambleRegistrationSection extends StatelessWidget {
  const RambleRegistrationSection({super.key, required this.ramble, this.onShare, this.isRegistered = false, this.isLoading = false, this.isCompact = false});

  final Ramble ramble;
  final VoidCallback? onShare;
  final bool isRegistered;
  final bool isLoading;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isCompact) {
      return _buildCompactLayout(context, theme, colorScheme);
    } else {
      return _buildFullLayout(context, theme, colorScheme);
    }
  }

  Widget _buildCompactLayout(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ramble.date != null) ...[_buildStatusRow(context, theme, colorScheme, true), const SizedBox(height: 16)],

            if (ramble.placesLeft != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getPlacesLeftColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _getPlacesLeftColor(context).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(_getPlacesLeftIcon(), size: 16, color: _getPlacesLeftColor(context)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getPlacesLeftText(),
                        style: theme.textTheme.bodySmall?.copyWith(color: _getPlacesLeftColor(context), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(width: double.infinity, child: _buildActionButton(context, theme, colorScheme)),

            if (onShare != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(onPressed: onShare, icon: const Icon(Icons.share, size: 16), label: const Text('Partager')),
              ),
            ],

            if (ramble.prices.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tarif', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  Text(
                    _getPriceText(),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFullLayout(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_available, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text('Inscription', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 20),

            if (ramble.date != null) ...[_buildStatusRow(context, theme, colorScheme, false), const SizedBox(height: 20)],

            if (ramble.prices.isNotEmpty) ...[_buildPricingSection(context, theme, colorScheme), const SizedBox(height: 20)],

            Row(
              children: [
                Expanded(flex: 2, child: _buildActionButton(context, theme, colorScheme)),
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

  Widget _buildStatusRow(BuildContext context, ThemeData theme, ColorScheme colorScheme, bool isCompact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: _getStatusColor(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(context).withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(_getStatusIcon(), color: _getStatusColor(context), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getStatusText(),
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: _getStatusColor(context)),
                ),
              ),
            ],
          ),
          if (!isCompact) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  '${DateFormat('EEEE dd MMMM yyyy', 'fr').format(ramble.date!)} à ${DateFormat('HH:mm').format(ramble.date!)}',
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            if (ramble.maxParticipants != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.group, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Maximum ${ramble.maxParticipants} participants', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
            if (ramble.placesLeft != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(_getPlacesLeftIcon(), size: 16, color: _getPlacesLeftColor(context)),
                  const SizedBox(width: 6),
                  Text(
                    _getPlacesLeftText(),
                    style: theme.textTheme.bodySmall?.copyWith(color: _getPlacesLeftColor(context), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tarifs', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...ramble.prices.map(
            (price) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(price.label, style: theme.textTheme.bodyMedium)),
                  Text(
                    '${price.amount.toStringAsFixed(0)}€',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return FilledButton.icon(
      onPressed: _canRegister() ? () => _showRegistrationForm(context) : null,
      icon: isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(_getButtonIcon()),
      label: Text(_getButtonText()),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: _getButtonColor(context)),
    );
  }

  void _showRegistrationForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RegistrationFormSheet(ramble: ramble),
    );
  }

  bool _canRegister() {
    if (isLoading) return false;
    if (isRegistered) return false;
    if (ramble.isCancelled) return false;
    if (ramble.date != null && ramble.date!.isBefore(DateTime.now())) return false;
    // Allow registration even when full (for waitlist)
    return true;
  }

  IconData _getButtonIcon() {
    if (isRegistered) return Icons.check;
    if (ramble.isCancelled) return Icons.block;
    if (ramble.date != null && ramble.date!.isBefore(DateTime.now())) return Icons.schedule;

    // Check if it's waitlist (no places left)
    if (ramble.placesLeft != null && ramble.placesLeft! <= 0) {
      return Icons.queue;
    }

    return Icons.person_add;
  }

  String _getButtonText() {
    if (isRegistered) return 'Inscrit';
    if (ramble.isCancelled) return 'Annulée';
    if (ramble.date != null && ramble.date!.isBefore(DateTime.now())) return 'Passée';

    // Check places left for more specific messaging
    if (ramble.placesLeft != null) {
      if (ramble.placesLeft! <= 0) {
        return 'Rejoindre la liste d\'attente';
      }
    }

    return 'S\'inscrire';
  }

  Color? _getButtonColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isRegistered) return colorScheme.surfaceContainerHighest;
    if (!_canRegister()) return colorScheme.surfaceContainerHighest;
    return null;
  }

  IconData _getStatusIcon() {
    if (ramble.isCancelled) return Icons.cancel;

    // Check places left for more accurate icon
    if (ramble.placesLeft != null && ramble.placesLeft! <= 0) {
      return Icons.group;
    }
    return Icons.check_circle;
  }

  String _getStatusText() {
    if (ramble.isCancelled) {
      return 'Balade annulée';
    }

    if (ramble.placesLeft != null && ramble.placesLeft! <= 0) {
      return 'Complet - Liste d\'attente disponible';
    }
    return 'Places disponibles';
  }

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (ramble.isCancelled) {
      return colorScheme.error;
    }

    // Check places left for more accurate color
    if (ramble.placesLeft != null && ramble.placesLeft! <= 0) {
      return Colors.orange;
    }
    return Colors.green;
  }

  String _getPriceText() {
    if (ramble.prices.isEmpty) return 'Gratuit';
    if (ramble.prices.length == 1) {
      return '${ramble.prices.first.amount.toStringAsFixed(0)}€';
    }
    final prices = ramble.prices.map((p) => p.amount).toList()..sort();
    return '${prices.first.toStringAsFixed(0)}€';
  }

  IconData _getPlacesLeftIcon() {
    if (ramble.placesLeft == null) return Icons.info;
    if (ramble.placesLeft! > 0) return Icons.event_seat;
    if (ramble.placesLeft! == 0) return Icons.queue;
    return Icons.format_list_numbered; // For waitlist position
  }

  Color _getPlacesLeftColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (ramble.placesLeft == null) return colorScheme.onSurfaceVariant;
    if (ramble.placesLeft! > 0) return Colors.green;
    if (ramble.placesLeft! == 0) return Colors.orange;
    return Colors.blue; // For waitlist position
  }

  String _getPlacesLeftText() {
    if (ramble.placesLeft == null) return '';
    if (ramble.placesLeft! > 0) {
      return ramble.placesLeft! == 1 ? '1 place restante' : '${ramble.placesLeft} places restantes';
    }
    if (ramble.placesLeft! == 0) return 'Liste d\'attente ouverte';
    // Negative value = waitlist position
    final position = -ramble.placesLeft!;
    return position == 1 ? '1ère position en liste d\'attente' : '${position}e position en liste d\'attente';
  }
}
