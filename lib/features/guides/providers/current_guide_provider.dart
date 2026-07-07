import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CurrentGuideStatus { loading, linked, unlinked, notGuide, error }

class CurrentGuideState {
  const CurrentGuideState({this.guide, this.status = CurrentGuideStatus.loading, this.error});

  final Guide? guide;
  final CurrentGuideStatus status;
  final String? error;

  bool get isFunctionalGuide => status == CurrentGuideStatus.linked && guide != null;

  CurrentGuideState copyWith({Guide? guide, CurrentGuideStatus? status, String? error}) {
    return CurrentGuideState(guide: guide ?? this.guide, status: status ?? this.status, error: error ?? this.error);
  }
}

class CurrentGuideNotifier extends StateNotifier<CurrentGuideState> {
  CurrentGuideNotifier(this._ref) : super(const CurrentGuideState()) {
    _ref.listen(authenticationProvider, (_, __) => load(), fireImmediately: true);
  }

  final Ref _ref;

  Future<void> load() async {
    final permission = _ref.read(permissionProvider);
    if (permission == null || !permission.isGuide()) {
      state = const CurrentGuideState(status: CurrentGuideStatus.notGuide);
      return;
    }

    final token = _ref.read(authenticationProvider)?.token;
    if (token == null) {
      state = const CurrentGuideState(status: CurrentGuideStatus.notGuide);
      return;
    }

    state = const CurrentGuideState(status: CurrentGuideStatus.loading);

    try {
      final guide = await GuidesService.instance.fetchMyGuide(authorization: token);
      if (guide == null) {
        state = const CurrentGuideState(status: CurrentGuideStatus.unlinked);
      } else {
        state = CurrentGuideState(guide: guide, status: CurrentGuideStatus.linked);
      }
    } catch (e) {
      state = CurrentGuideState(status: CurrentGuideStatus.error, error: e.toString());
    }
  }

  void updateGuide(Guide guide) {
    state = CurrentGuideState(guide: guide, status: CurrentGuideStatus.linked);
  }
}

final currentGuideProvider = StateNotifierProvider<CurrentGuideNotifier, CurrentGuideState>((ref) {
  return CurrentGuideNotifier(ref);
});

final isFunctionalGuideProvider = Provider<bool>((ref) {
  return ref.watch(currentGuideProvider).isFunctionalGuide;
});
