import 'package:balade/features/admin/registrations_management/models/bulk_action_request.dart';
import 'package:balade/features/admin/registrations_management/models/bulk_action_result.dart';
import 'package:balade/features/admin/registrations_management/providers/admin_registrations_provider.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bulk actions state
class BulkActionsState {
  const BulkActionsState({this.selectedRegistrationIds = const {}, this.isLoading = false, this.error, this.lastResult});

  final Set<int> selectedRegistrationIds;
  final bool isLoading;
  final String? error;
  final BulkActionResult? lastResult;

  BulkActionsState copyWith({Set<int>? selectedRegistrationIds, bool? isLoading, String? error, BulkActionResult? lastResult}) {
    return BulkActionsState(
      selectedRegistrationIds: selectedRegistrationIds ?? this.selectedRegistrationIds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  bool get hasSelection => selectedRegistrationIds.isNotEmpty;
  int get selectionCount => selectedRegistrationIds.length;
}

// Bulk actions notifier
class BulkActionsNotifier extends StateNotifier<BulkActionsState> {
  BulkActionsNotifier(this._registrationsService, this._adminRegistrationsRef) : super(const BulkActionsState());

  final RegistrationsService _registrationsService;
  final Ref _adminRegistrationsRef;

  void toggleSelection(int registrationId) {
    final currentSelection = Set<int>.from(state.selectedRegistrationIds);

    if (currentSelection.contains(registrationId)) {
      currentSelection.remove(registrationId);
    } else {
      currentSelection.add(registrationId);
    }

    state = state.copyWith(selectedRegistrationIds: currentSelection);
  }

  void selectAll(List<int> registrationIds) {
    state = state.copyWith(selectedRegistrationIds: Set.from(registrationIds));
  }

  void clearSelection() {
    state = state.copyWith(selectedRegistrationIds: const {});
  }

  bool isSelected(int registrationId) {
    return state.selectedRegistrationIds.contains(registrationId);
  }

  Future<bool> performBulkAction({required String action, required String authorization, String? reason, bool sendEmail = false}) async {
    if (state.selectedRegistrationIds.isEmpty) {
      state = state.copyWith(error: 'Aucune inscription sélectionnée');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final payload = BulkRegistrationActionPayload(registrationIds: state.selectedRegistrationIds.toList(), action: action, reason: reason, sendEmail: sendEmail);

      final result = await _registrationsService.performBulkAction(payload, authorization: authorization);

      state = state.copyWith(
        isLoading: false,
        lastResult: result,
        selectedRegistrationIds: const {}, // Clear selection after successful operation
      );

      // Refresh the registrations list
      _adminRegistrationsRef.read(adminRegistrationsProvider.notifier).loadRegistrations(authorization: authorization);

      return result.failureCount == 0;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearResult() {
    state = state.copyWith(lastResult: null);
  }
}

// Provider for bulk actions
final bulkActionsProvider = StateNotifierProvider<BulkActionsNotifier, BulkActionsState>((ref) {
  return BulkActionsNotifier(RegistrationsService.instance, ref);
});
