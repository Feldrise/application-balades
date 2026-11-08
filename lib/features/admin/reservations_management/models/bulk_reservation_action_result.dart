import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_reservation_action_result.freezed.dart';
part 'bulk_reservation_action_result.g.dart';

/// What a bulk action did: each reservation succeeds or fails separately.
@freezed
abstract class BulkReservationActionResult with _$BulkReservationActionResult {
  const factory BulkReservationActionResult({
    @JsonKey(name: 'success_count') required int successCount,
    @JsonKey(name: 'failure_count') required int failureCount,
    // The API omits the lists when they are empty
    @Default(<BulkReservationActionError>[]) List<BulkReservationActionError> errors,
    // The reservations as saved, without the deleted ones
    @Default(<Reservation>[]) List<Reservation> updated,
  }) = _BulkReservationActionResult;

  factory BulkReservationActionResult.fromJson(Map<String, Object?> json) => _$BulkReservationActionResultFromJson(json);
}

@freezed
abstract class BulkReservationActionError with _$BulkReservationActionError {
  const factory BulkReservationActionError({@JsonKey(name: 'reservation_id') required int reservationId, required String error}) = _BulkReservationActionError;

  factory BulkReservationActionError.fromJson(Map<String, Object?> json) => _$BulkReservationActionErrorFromJson(json);
}
