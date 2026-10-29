import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// +/− counters of the reservation being filled in: one per tariff, or a single "Personnes" counter.
class ReservationCounters extends ConsumerWidget {
  const ReservationCounters({super.key, required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(reservationFormProvider(ramble));
    final notifier = ref.read(reservationFormProvider(ramble).notifier);
    final draft = form.draft;

    if (!draft.hasTariffChoice) {
      final label = draft.prices.isEmpty ? '' : draft.prices.first.label;
      final amount = draft.prices.isEmpty ? null : formatEuros(draft.prices.first.amount);
      return _CounterRow(
        title: 'Personnes',
        subtitle: amount,
        count: draft.total,
        onIncrement: draft.canIncrement ? () => notifier.increment(label) : null,
        onDecrement: draft.canDecrement(label) ? () => notifier.decrement(label) : null,
      );
    }

    return Column(
      children: [
        for (final price in draft.prices)
          _CounterRow(
            title: price.label,
            subtitle: formatEuros(price.amount),
            count: draft.countFor(price.label),
            onIncrement: draft.canIncrement ? () => notifier.increment(price.label) : null,
            onDecrement: draft.canDecrement(price.label) ? () => notifier.decrement(price.label) : null,
          ),
      ],
    );
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({required this.title, required this.count, this.subtitle, this.onIncrement, this.onDecrement});

  final String title;
  final String? subtitle;
  final int count;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                if (subtitle != null) Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton.outlined(onPressed: onDecrement, icon: const Icon(Icons.remove), tooltip: 'Retirer une personne ($title)'),
          SizedBox(
            width: 40,
            child: Text('$count', textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          IconButton.outlined(onPressed: onIncrement, icon: const Icon(Icons.add), tooltip: 'Ajouter une personne ($title)'),
        ],
      ),
    );
  }
}
