import 'package:balade/features/admin/layout/admin_access_denied_page.dart';
import 'package:balade/features/admin/layout/management_layout.dart';
import 'package:balade/features/admin/layout/management_navigation.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authenticationProvider);
    if (authedUser == null) {
      // Signed out while in the management area: the router sends to the single login screen on the next navigation
      final location = GoRouterState.of(context).uri.toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(location);
      });
      return const SizedBox.shrink();
    }

    final permission = ref.watch(permissionProvider);
    if (permission == null || !permission.canAccessAdminArea()) {
      return const AdminAccessDeniedPage();
    }

    final path = GoRouterState.of(context).uri.path;
    if (!permission.isAdmin() && isAdminOnlyRoute(path)) {
      return const AdminAccessDeniedPage();
    }

    return ManagementLayout(child: child);
  }
}
