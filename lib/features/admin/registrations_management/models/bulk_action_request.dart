import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_action_request.freezed.dart';
part 'bulk_action_request.g.dart';

@freezed
abstract class BulkRegistrationActionPayload with _$BulkRegistrationActionPayload {
  const factory BulkRegistrationActionPayload({
    @JsonKey(name: 'registration_ids') required List<int> registrationIds,
    required String action,
    String? reason,
    @JsonKey(name: 'send_email') @Default(false) bool sendEmail,
  }) = _BulkRegistrationActionPayload;

  factory BulkRegistrationActionPayload.fromJson(Map<String, Object?> json) => _$BulkRegistrationActionPayloadFromJson(json);
}
