import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';

/// What a list shows when it has nothing to show, so that the screen never looks broken.
class ManagementEmptyState extends StatelessWidget {
  const ManagementEmptyState({super.key, required this.icon, required this.title, this.message, this.action});

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(color: ManagementColors.mint, shape: BoxShape.circle),
            child: Icon(icon, size: 28, color: ManagementColors.green),
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(color: ManagementColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
