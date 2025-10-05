import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_action_result.freezed.dart';
part 'bulk_action_result.g.dart';

@freezed
abstract class BulkActionResult with _$BulkActionResult {
  const factory BulkActionResult({
    @JsonKey(name: 'success_count') required int successCount,
    @JsonKey(name: 'failure_count') required int failureCount,
    required List<BulkActionError> errors,
    required List<Registration> updated,
  }) = _BulkActionResult;

  factory BulkActionResult.fromJson(Map<String, Object?> json) => _$BulkActionResultFromJson(json);
}

@freezed
abstract class BulkActionError with _$BulkActionError {
  const factory BulkActionError({@JsonKey(name: 'registration_id') required int registrationId, required String error}) = _BulkActionError;

  factory BulkActionError.fromJson(Map<String, Object?> json) => _$BulkActionErrorFromJson(json);
}
