import 'package:balade/core/serializers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration.freezed.dart';
part 'registration.g.dart';

@freezed
abstract class Registration with _$Registration {
  const factory Registration(
    int id, {
    @JsonKey(name: 'created_at') @DateSerializer() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateSerializer() required DateTime updatedAt,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    String? phone,
    required String status,
    @JsonKey(name: 'registration_date') @DateSerializer() required DateTime registrationDate,
    @JsonKey(name: 'confirmation_date') @DateSerializer() DateTime? confirmationDate,
    @JsonKey(name: 'confirmation_deadline') @DateSerializer() DateTime? confirmationDeadline,
    @JsonKey(name: 'cancellation_date') @DateSerializer() DateTime? cancellationDate,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'ramble_id') required int rambleId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'group_id') int? groupId,
    // Optional embedded ramble summary returned by the list API
    RegistrationRambleSummary? ramble,
  }) = _Registration;

  factory Registration.fromJson(Map<String, Object?> json) => _$RegistrationFromJson(json);
}

@freezed
abstract class RegistrationRambleSummary with _$RegistrationRambleSummary {
  const factory RegistrationRambleSummary({required String title, @DateSerializer() DateTime? date, String? location}) = _RegistrationRambleSummary;

  factory RegistrationRambleSummary.fromJson(Map<String, Object?> json) => _$RegistrationRambleSummaryFromJson(json);
}

@freezed
abstract class ConfirmRegistrationRequest with _$ConfirmRegistrationRequest {
  const factory ConfirmRegistrationRequest({required bool confirmed}) = _ConfirmRegistrationRequest;

  factory ConfirmRegistrationRequest.fromJson(Map<String, Object?> json) => _$ConfirmRegistrationRequestFromJson(json);
}

@freezed
abstract class CancelRegistrationRequest with _$CancelRegistrationRequest {
  const factory CancelRegistrationRequest({String? reason}) = _CancelRegistrationRequest;

  factory CancelRegistrationRequest.fromJson(Map<String, Object?> json) => _$CancelRegistrationRequestFromJson(json);
}
