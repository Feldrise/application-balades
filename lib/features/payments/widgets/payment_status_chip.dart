import 'package:balade/features/payments/models/payment.dart';
import 'package:flutter/material.dart';

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.status, this.showIcon = true});

  final PaymentStatus status;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, icon) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Text(
            status.label,
            style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStatusStyle() {
    switch (status) {
      case PaymentStatus.pending:
        return (Colors.orange, Icons.schedule);
      case PaymentStatus.succeeded:
        return (Colors.green, Icons.check_circle);
      case PaymentStatus.failed:
        return (Colors.red, Icons.error);
      case PaymentStatus.cancelled:
        return (Colors.grey, Icons.cancel);
      case PaymentStatus.refunded:
        return (Colors.blue, Icons.undo);
    }
  }
}
