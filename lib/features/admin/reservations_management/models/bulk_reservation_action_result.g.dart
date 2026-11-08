// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_reservation_action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BulkReservationActionResult _$BulkReservationActionResultFromJson(
  Map<String, dynamic> json,
) => _BulkReservationActionResult(
  successCount: (json['success_count'] as num).toInt(),
  failureCount: (json['failure_count'] as num).toInt(),
  errors:
      (json['errors'] as List<dynamic>?)
          ?.map(
            (e) =>
                BulkReservationActionError.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <BulkReservationActionError>[],
  updated:
      (json['updated'] as List<dynamic>?)
          ?.map((e) => Reservation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Reservation>[],
);

Map<String, dynamic> _$BulkReservationActionResultToJson(
  _BulkReservationActionResult instance,
) => <String, dynamic>{
  'success_count': instance.successCount,
  'failure_count': instance.failureCount,
  'errors': instance.errors,
  'updated': instance.updated,
};

_BulkReservationActionError _$BulkReservationActionErrorFromJson(
  Map<String, dynamic> json,
) => _BulkReservationActionError(
  reservationId: (json['reservation_id'] as num).toInt(),
  error: json['error'] as String,
);

Map<String, dynamic> _$BulkReservationActionErrorToJson(
  _BulkReservationActionError instance,
) => <String, dynamic>{
  'reservation_id': instance.reservationId,
  'error': instance.error,
};
