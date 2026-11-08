import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The green header of a management page: the page's only header bar.
///
/// [actions] sit to the right of the title (e.g. « Nouvelle balade »). [bottom] goes under the title,
/// typically a [ManagementHeaderSearchField] or a row of stat chips. On a phone, where there is no sidebar,
/// the header also carries the link to the public site.
class ManagementPageHeader extends StatelessWidget {
  const ManagementPageHeader({super.key, required this.title, this.subtitle, this.leading, this.actions = const [], this.bottom});

  final String title;
  final String? subtitle;

  /// Shown before the title, e.g. a back button.
  final Widget? leading;
  final List<Widget> actions;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gutter = ManagementBreakpoints.gutter(context);
    final isPhone = ManagementBreakpoints.isPhone(context);

    return Material(
      color: ManagementColors.deepGreen,
      child: Padding(
        padding: EdgeInsets.fromLTRB(gutter, MediaQuery.paddingOf(context).top + 14, isPhone ? gutter - 8 : gutter, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: leading!,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
                ...actions,
                if (isPhone)
                  IconButton(
                    tooltip: 'Voir le site public',
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.open_in_new, color: Colors.white70),
                  ),
              ],
            ),
            if (bottom != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(right: isPhone ? 8 : 0),
                child: bottom!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A white button for the main action of a [ManagementPageHeader].
class ManagementHeaderButton extends StatelessWidget {
  const ManagementHeaderButton({super.key, required this.label, required this.icon, required this.onPressed});

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: ManagementColors.deepGreen,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

/// The search field of a [ManagementPageHeader], light on the green background.
class ManagementHeaderSearchField extends StatelessWidget {
  const ManagementHeaderSearchField({super.key, required this.hint, this.controller, this.onChanged});

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: style?.copyWith(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style?.copyWith(color: Colors.white60),
        prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.12),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white54),
        ),
      ),
    );
  }
}
