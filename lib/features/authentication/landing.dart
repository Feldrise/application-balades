import 'package:balade/core/permission.dart';
import 'package:balade/features/users/models/user/user.dart';

/// Where [user] lands once logged in: an explicit [redirection] always wins (e.g. after « Ajouter des
/// participants » or a confirmation link); otherwise admins and guides go to the management area and
/// the booker to Mes réservations.
String landingAfterLogin(User user, {String? redirection}) {
  // Only an in-app path is followed, never another site.
  if (redirection != null && redirection.startsWith('/') && !redirection.startsWith('//')) return redirection;
  return Permission(user.permissions, user.roles).canAccessAdminArea() ? '/admin' : '/mes-reservations';
}
