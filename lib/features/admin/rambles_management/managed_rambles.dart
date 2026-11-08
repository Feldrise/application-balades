import 'dart:async';

import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The balades the signed-in account manages: all of them for an admin, their own for a guide (as before the redesign).
final managedRamblesProvider = FutureProvider.autoDispose<List<Ramble>>((ref) async {
  final token = ref.watch(authenticationProvider)?.token;
  final permission = ref.watch(permissionProvider);
  final guideOnly = permission?.isGuide() == true && permission?.isAdmin() != true;
  int? guideId;
  if (guideOnly) {
    final guide = ref.watch(currentGuideProvider.select((s) => (s.status, s.guide?.id)));
    // Wait for the guide profile, so that a guide never sees other guides' balades in between
    if (guide.$1 == CurrentGuideStatus.loading) return Completer<List<Ramble>>().future;
    guideId = guide.$2;
  }
  return RamblesService.instance.fetchRambles(includeUnpublished: true, guideId: guideId, authorization: token);
});

/// The quick filters of the balades list.
enum RambleListFilter {
  upcoming('À venir'),
  published('Publiées'),
  drafts('Brouillons'),
  cancelled('Annulées'),
  past('Passées');

  const RambleListFilter(this.label);

  final String label;
}

/// What the balades list shows: a quick filter, a search, and optionally a guide and a type.
class RambleListQuery {
  const RambleListQuery({this.filter = RambleListFilter.upcoming, this.search = '', this.guideId, this.type});

  final RambleListFilter filter;
  final String search;
  final int? guideId;
  final String? type;

  RambleListQuery copyWith({RambleListFilter? filter, String? search, int? Function()? guideId, String? Function()? type}) =>
      RambleListQuery(filter: filter ?? this.filter, search: search ?? this.search, guideId: guideId == null ? this.guideId : guideId(), type: type == null ? this.type : type());
}

final rambleListQueryProvider = StateProvider.autoDispose<RambleListQuery>((ref) => const RambleListQuery());

/// A group of the balades list, e.g. « Cette semaine ».
class RambleGroup {
  const RambleGroup(this.label, this.rambles);

  final String label;
  final List<Ramble> rambles;
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

bool _isPast(Ramble ramble, DateTime today) => ramble.date != null && _day(ramble.date!).isBefore(today);

bool _matches(Ramble ramble, RambleListQuery query, DateTime today) {
  final past = _isPast(ramble, today);
  final keep = switch (query.filter) {
    RambleListFilter.upcoming => !past && !ramble.isCancelled,
    RambleListFilter.published => !past && !ramble.isCancelled && ramble.isPublished,
    RambleListFilter.drafts => !past && !ramble.isCancelled && ramble.isDraft,
    RambleListFilter.cancelled => !past && ramble.isCancelled,
    RambleListFilter.past => past,
  };
  if (!keep) return false;
  if (query.guideId != null && !ramble.guides.any((g) => g.id == query.guideId)) return false;
  if (query.type != null && ramble.type != query.type) return false;

  final search = query.search.trim().toLowerCase();
  if (search.isEmpty) return true;
  final haystack = [ramble.title, ramble.location, ramble.meetingPoint, for (final g in ramble.guides) '${g.firstName} ${g.lastName}'].whereType<String>().join(' ').toLowerCase();
  return haystack.contains(search);
}

/// The balades matching [query], grouped by period: the next 7 days (« Cette semaine »), the next 31 days
/// (« Ce mois-ci ») and later, soonest first. Past balades form a single group, most recent first.
List<RambleGroup> groupRambles(List<Ramble> rambles, RambleListQuery query, {DateTime? now}) {
  final today = _day(now ?? DateTime.now());
  final kept = rambles.where((r) => _matches(r, query, today)).toList();
  final far = DateTime(9999);
  kept.sort((a, b) => (a.date ?? far).compareTo(b.date ?? far));

  if (query.filter == RambleListFilter.past) {
    return kept.isEmpty ? const [] : [RambleGroup('Passées', kept.reversed.toList())];
  }

  final week = <Ramble>[], month = <Ramble>[], later = <Ramble>[];
  for (final r in kept) {
    final days = r.date == null ? null : _day(r.date!).difference(today).inDays;
    if (days != null && days < 7) {
      week.add(r);
    } else if (days != null && days < 31) {
      month.add(r);
    } else {
      later.add(r);
    }
  }
  return [if (week.isNotEmpty) RambleGroup('Cette semaine', week), if (month.isNotEmpty) RambleGroup('Ce mois-ci', month), if (later.isNotEmpty) RambleGroup('Plus tard', later)];
}

/// Places taken in a balade, from its capacity and its places left.
int placesTaken(Ramble ramble) {
  final max = ramble.maxParticipants, left = ramble.placesLeft;
  if (max == null || left == null) return 0;
  return (max - left).clamp(0, max);
}
