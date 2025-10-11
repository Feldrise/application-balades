import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';

class PriceSelectionWidget extends StatelessWidget {
  const PriceSelectionWidget({
    super.key,
    required this.prices,
    required this.selectedPrices,
    required this.onPriceChanged,
    required this.participantCount,
    this.isGroupPayment = false,
  });

  final List<RamblePrice> prices;
  final Map<String, int> selectedPrices; // priceLabel -> count
  final Function(Map<String, int>) onPriceChanged;
  final int participantCount;
  final bool isGroupPayment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.euro, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(isGroupPayment ? 'Sélection des tarifs pour le groupe' : 'Sélection du tarif', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            if (isGroupPayment)
              Text(
                'Sélectionnez le tarif pour chaque participant (${_getTotalSelected()}/$participantCount)',
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              )
            else
              Text('Choisissez votre tarif pour cette balade', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),

            ...prices.map((price) => _buildPriceOption(context, price)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceOption(BuildContext context, RamblePrice price) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentCount = selectedPrices[price.label] ?? 0;
    final remainingSlots = isGroupPayment ? participantCount - _getTotalSelected() + currentCount : 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: currentCount > 0 ? colorScheme.primary : colorScheme.outline, width: currentCount > 0 ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(price.label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        '${price.amount.toStringAsFixed(2)} €',
                        style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (isGroupPayment) ...[
                  // Counter for group payments
                  Row(
                    children: [
                      IconButton(onPressed: currentCount > 0 ? () => _updateCount(price.label, currentCount - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(currentCount.toString(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      IconButton(onPressed: currentCount < remainingSlots ? () => _updateCount(price.label, currentCount + 1) : null, icon: const Icon(Icons.add_circle_outline)),
                    ],
                  ),
                ] else ...[
                  // Radio for individual payments
                  Radio<String>(
                    value: price.label,
                    groupValue: selectedPrices.keys.isNotEmpty ? selectedPrices.keys.first : null,
                    onChanged: (value) {
                      if (value != null) {
                        onPriceChanged({value: 1});
                      }
                    },
                  ),
                ],
              ],
            ),
            if (currentCount > 0 && isGroupPayment)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  '${currentCount} participant${currentCount > 1 ? 's' : ''} - ${(price.amount * currentCount).toStringAsFixed(2)} €',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateCount(String priceLabel, int newCount) {
    final newSelectedPrices = Map<String, int>.from(selectedPrices);
    if (newCount <= 0) {
      newSelectedPrices.remove(priceLabel);
    } else {
      newSelectedPrices[priceLabel] = newCount;
    }
    onPriceChanged(newSelectedPrices);
  }

  int _getTotalSelected() {
    return selectedPrices.values.fold(0, (sum, count) => sum + count);
  }
}
