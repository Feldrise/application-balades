import 'package:balade/core/permission.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';

bool canManageRamble(Permission? permission, Ramble ramble, int? guideId) {
  if (permission == null) return false;
  if (permission.isAdmin()) return true;
  if (guideId == null) return false;
  return permission.canUpdateOwnRamble() && ramble.guides.any((g) => g.id == guideId);
}

bool canDeleteRamble(Permission? permission, Ramble ramble, int? guideId) {
  if (permission == null) return false;
  if (permission.isAdmin()) return permission.canDeleteRamble() || permission.canUpdateRamble();
  if (guideId == null) return false;
  return permission.canDeleteOwnRamble() && ramble.guides.any((g) => g.id == guideId);
}

bool canCreateBalade(Permission? permission, bool isFunctionalGuide) {
  if (permission == null) return false;
  if (permission.isAdmin()) return permission.canCreateRamble() || permission.canUpdateRamble();
  return permission.canCreateRamble() && isFunctionalGuide;
}
