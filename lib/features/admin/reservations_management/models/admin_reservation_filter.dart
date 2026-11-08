import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_reservation_filter.freezed.dart';

/// What the admin looks for in the reservations: every field set narrows the list.
@freezed
abstract class AdminReservationFilter with _$AdminReservationFilter {
  const AdminReservationFilter._();

  const factory AdminReservationFilter({
    String? search,
    int? rambleId,
    int? userId,
    String? email,
    List<String>? statuses,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? rambleTitle,
  }) = _AdminReservationFilter;

  bool get hasActiveFilters =>
      (search?.isNotEmpty ?? false) ||
      rambleId != null ||
      userId != null ||
      (email?.isNotEmpty ?? false) ||
      (statuses?.isNotEmpty ?? false) ||
      dateFrom != null ||
      dateTo != null ||
      (rambleTitle?.isNotEmpty ?? false);
}
