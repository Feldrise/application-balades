// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reservation_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminReservationList _$AdminReservationListFromJson(
  Map<String, dynamic> json,
) => _AdminReservationList(
  reservations: (json['reservations'] as List<dynamic>)
      .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$AdminReservationListToJson(
  _AdminReservationList instance,
) => <String, dynamic>{
  'reservations': instance.reservations,
  'total': instance.total,
  'page': instance.page,
  'per_page': instance.perPage,
  'total_pages': instance.totalPages,
};
