import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A bar fixed at the bottom of a form page, so that its actions (Annuler, Enregistrer) stay reachable
/// whatever the length of the form. The [actions] are right-aligned, within the width of the form.
class ManagementActionBar extends StatelessWidget {
  const ManagementActionBar({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ManagementColors.surface,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ManagementColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[if (i > 0) const SizedBox(width: 12), Flexible(child: actions[i])],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Leaves a form page: back to the page it was opened from, or to the balades list when it was opened directly.
void leaveManagementForm(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/admin');
  }
}

/// The back arrow of the header of a form page.
class ManagementBackButton extends StatelessWidget {
  const ManagementBackButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(tooltip: 'Retour', onPressed: () => leaveManagementForm(context), icon: const Icon(Icons.arrow_back));
}
