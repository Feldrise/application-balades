import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_registration_response.freezed.dart';
part 'admin_registration_response.g.dart';

@freezed
abstract class AdminRegistrationListResponse with _$AdminRegistrationListResponse {
  const factory AdminRegistrationListResponse({
    required List<Registration> registrations,
    required int total,
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _AdminRegistrationListResponse;

  factory AdminRegistrationListResponse.fromJson(Map<String, Object?> json) => _$AdminRegistrationListResponseFromJson(json);
}

@freezed
abstract class AdminRegistrationUpdatePayload with _$AdminRegistrationUpdatePayload {
  const factory AdminRegistrationUpdatePayload({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    String? phone,
    String? status,
    String? notes,
  }) = _AdminRegistrationUpdatePayload;

  factory AdminRegistrationUpdatePayload.fromJson(Map<String, Object?> json) => _$AdminRegistrationUpdatePayloadFromJson(json);
}

@freezed
abstract class AdminRegistrationStatusUpdatePayload with _$AdminRegistrationStatusUpdatePayload {
  const factory AdminRegistrationStatusUpdatePayload({required String status, String? reason, @JsonKey(name: 'send_email') @Default(false) bool sendEmail}) =
      _AdminRegistrationStatusUpdatePayload;

  factory AdminRegistrationStatusUpdatePayload.fromJson(Map<String, Object?> json) => _$AdminRegistrationStatusUpdatePayloadFromJson(json);
}
