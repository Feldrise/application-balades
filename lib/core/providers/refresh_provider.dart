import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A provider that maintains a refresh counter to trigger data refreshes throughout the app.
/// The counter increases each time a refresh is triggered.
final refreshProvider = StateNotifierProvider<RefreshNotifier, int>((ref) {
  return RefreshNotifier();
});

/// A state notifier that manages the refresh counter.
class RefreshNotifier extends StateNotifier<int> {
  RefreshNotifier() : super(0);

  /// Increment the refresh counter to trigger a refresh across the app.
  void refresh() {
    state++;
  }
}
