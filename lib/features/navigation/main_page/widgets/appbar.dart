import 'package:balade/themes/screen_helper.dart';
import 'package:flutter/material.dart';

class BeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BeAppbar({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= ScreenHelper.breakpointPC;

    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      title: Row(
        children: [
          // Logo/Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: theme.colorScheme.onPrimary.withAlpha(25), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.eco, color: theme.colorScheme.onPrimary, size: 24),
          ),
          const SizedBox(width: 12),
          // App title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary)),
                if (!isDesktop && subtitle != null) // Show subtitle only on mobile/tablet
                  Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary.withAlpha(201))),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Desktop navigation actions
        if (isDesktop) ...[
          _buildNavAction(context, Icons.search, 'Rechercher', () {}),
          _buildNavAction(context, Icons.notifications_outlined, 'Notifications', () {}),
          _buildNavAction(context, Icons.account_circle_outlined, 'Mon compte', () {}),
        ] else ...[
          // Mobile actions
          IconButton(icon: const Icon(Icons.search), onPressed: () {}, tooltip: 'Rechercher'),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}, tooltip: 'Notifications'),
        ],
      ],
    );
  }

  Widget _buildNavAction(BuildContext context, IconData icon, String tooltip, VoidCallback onPressed) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.onPrimary.withAlpha(25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
