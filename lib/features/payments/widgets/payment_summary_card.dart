import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.ramble, required this.selectedPrices, required this.participantCount});

  final Ramble ramble;
  final Map<String, int> selectedPrices; // priceLabel -> count
  final int participantCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final total = _calculateTotal();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Récapitulatif du paiement', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // Ramble details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ramble.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  if (ramble.date != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(_formatDate(ramble.date!), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ],
                  if (ramble.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(ramble.location!, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price breakdown
            Text('Détail des tarifs', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            ...selectedPrices.entries.map((entry) {
              final priceLabel = entry.key;
              final count = entry.value;
              final price = ramble.prices.firstWhere((p) => p.label == priceLabel);
              final subtotal = price.amount * count;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text('$priceLabel × $count', style: theme.textTheme.bodyMedium)),
                    Text('${subtotal.toStringAsFixed(2)} €', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }),

            const Divider(),

            // Total
            Row(
              children: [
                Expanded(
                  child: Text('Total', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Text(
                  '${total.toStringAsFixed(2)} €',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    double total = 0;
    for (final entry in selectedPrices.entries) {
      final priceLabel = entry.key;
      final count = entry.value;
      final price = ramble.prices.firstWhere((p) => p.label == priceLabel);
      total += price.amount * count;
    }
    return total;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
