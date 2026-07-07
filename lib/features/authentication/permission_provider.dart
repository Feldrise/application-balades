import 'package:balade/core/permission.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final permissionProvider = Provider<Permission?>((ref) {
  final user = ref.watch(authenticationProvider)?.user;
  if (user == null) return null;
  return Permission(user.permissions, user.roles);
});
