import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_reservation_list.freezed.dart';
part 'admin_reservation_list.g.dart';

/// A page of the reservations listed to admins and guides
@freezed
abstract class AdminReservationList with _$AdminReservationList {
  const factory AdminReservationList({
    required List<Reservation> reservations,
    required int total,
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _AdminReservationList;

  factory AdminReservationList.fromJson(Map<String, Object?> json) => _$AdminReservationListFromJson(json);
}
