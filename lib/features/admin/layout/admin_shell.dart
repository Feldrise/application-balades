import 'package:balade/features/admin/layout/admin_access_denied_page.dart';
import 'package:balade/features/admin/layout/management_layout.dart';
import 'package:balade/features/admin/layout/management_navigation.dart';
import 'package:balade/features/authentication/admin_login_page.dart';
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
      return const AdminLoginPage();
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
