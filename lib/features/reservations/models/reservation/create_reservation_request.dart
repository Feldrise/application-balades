import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_reservation_request.freezed.dart';
part 'create_reservation_request.g.dart';

@freezed
abstract class CreateReservationRequest with _$CreateReservationRequest {
  const factory CreateReservationRequest({
    @JsonKey(name: 'ramble_id') required int rambleId,
    @JsonKey(name: 'contact_email') required String contactEmail,
    @JsonKey(name: 'contact_phone', includeIfNull: false) String? contactPhone,
    required List<ParticipantRequest> participants,
  }) = _CreateReservationRequest;

  factory CreateReservationRequest.fromJson(Map<String, Object?> json) => _$CreateReservationRequestFromJson(json);
}

@freezed
abstract class ParticipantRequest with _$ParticipantRequest {
  const factory ParticipantRequest({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'price_label') @Default('') String priceLabel,
    @JsonKey(name: 'is_booker') @Default(false) bool isBooker,
  }) = _ParticipantRequest;

  factory ParticipantRequest.fromJson(Map<String, Object?> json) => _$ParticipantRequestFromJson(json);
}
