import 'package:balade/core/permission.dart';
import 'package:balade/features/admin/ramble_details_page/presence/presence_sync.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The roll call is for the guide of the balade and the admin, from the day of the balade on: not to be filled in advance.
bool canMarkPresence(Permission? permission, Ramble ramble, int? guideId, {DateTime? now}) {
  final date = ramble.date?.toLocal();
  if (permission == null || date == null) return false;
  final today = now ?? DateTime.now();
  if (today.isBefore(DateTime(date.year, date.month, date.day))) return false;
  if (permission.isAdmin()) return true;
  return guideId != null && ramble.guides.any((g) => g.id == guideId);
}

/// The roll call of a balade while its feuille is open: the changes left on the phone are sent as it opens.
final presenceSyncProvider = ChangeNotifierProvider.autoDispose.family<PresenceSync, int>((ref, rambleId) {
  final sync = PresenceSync(rambleId: rambleId, service: ref.read(reservationsServiceProvider), token: ref.read(authenticationProvider)?.token ?? '');
  sync.load().then((_) => sync.send(), onError: (_) => sync.send());
  return sync;
});
