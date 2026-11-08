import 'package:balade/features/admin/reservations_management/models/bulk_reservation_action_result.dart';
import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bulk actions state
class BulkActionsState {
  const BulkActionsState({this.selectedReservationIds = const {}, this.isLoading = false, this.error, this.lastResult});

  final Set<int> selectedReservationIds;
  final bool isLoading;
  final String? error;
  final BulkReservationActionResult? lastResult;

  BulkActionsState copyWith({Set<int>? selectedReservationIds, bool? isLoading, String? error, BulkReservationActionResult? lastResult}) {
    return BulkActionsState(
      selectedReservationIds: selectedReservationIds ?? this.selectedReservationIds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  bool get hasSelection => selectedReservationIds.isNotEmpty;
  int get selectionCount => selectedReservationIds.length;
}

// Bulk actions notifier
class BulkActionsNotifier extends StateNotifier<BulkActionsState> {
  BulkActionsNotifier(this._reservationsService, this._adminReservations) : super(const BulkActionsState());

  final ReservationsService _reservationsService;
  final AdminReservationsNotifier _adminReservations;

  void toggleSelection(int reservationId) {
    final currentSelection = Set<int>.from(state.selectedReservationIds);

    if (currentSelection.contains(reservationId)) {
      currentSelection.remove(reservationId);
    } else {
      currentSelection.add(reservationId);
    }

    state = state.copyWith(selectedReservationIds: currentSelection);
  }

  void selectAll(List<int> reservationIds) {
    state = state.copyWith(selectedReservationIds: Set.from(reservationIds));
  }

  void clearSelection() {
    state = state.copyWith(selectedReservationIds: const {});
  }

  bool isSelected(int reservationId) {
    return state.selectedReservationIds.contains(reservationId);
  }

  Future<bool> performBulkAction({required String action, required String token, String? reason, bool sendEmail = false}) async {
    if (state.selectedReservationIds.isEmpty) {
      state = state.copyWith(error: 'Aucune réservation sélectionnée');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _reservationsService.performBulkAction(state.selectedReservationIds.toList(), action: action, reason: reason, sendEmail: sendEmail, token: token);

      state = state.copyWith(
        isLoading: false,
        lastResult: result,
        selectedReservationIds: const {}, // Clear selection after successful operation
      );

      // Refresh the reservations list
      _adminReservations.loadReservations(token: token);

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
  return BulkActionsNotifier(ReservationsService.instance, ref.read(adminReservationsProvider.notifier));
});
