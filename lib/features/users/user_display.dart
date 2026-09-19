import 'package:balade/features/users/models/user/user.dart';

String userDisplayLabel(User user) {
  final profile = user.profile;
  final firstName = profile?.firstName?.trim() ?? '';
  final lastName = profile?.lastName?.trim() ?? '';
  final fullName = [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

  if (fullName.isNotEmpty) {
    return '$fullName (${user.email})';
  }

  return user.email;
}
