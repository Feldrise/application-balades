// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BulkActionResult _$BulkActionResultFromJson(Map<String, dynamic> json) =>
    _BulkActionResult(
      successCount: (json['success_count'] as num).toInt(),
      failureCount: (json['failure_count'] as num).toInt(),
      errors: (json['errors'] as List<dynamic>)
          .map((e) => BulkActionError.fromJson(e as Map<String, dynamic>))
          .toList(),
      updated: (json['updated'] as List<dynamic>)
          .map((e) => Registration.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BulkActionResultToJson(_BulkActionResult instance) =>
    <String, dynamic>{
      'success_count': instance.successCount,
      'failure_count': instance.failureCount,
      'errors': instance.errors,
      'updated': instance.updated,
    };

_BulkActionError _$BulkActionErrorFromJson(Map<String, dynamic> json) =>
    _BulkActionError(
      registrationId: (json['registration_id'] as num).toInt(),
      error: json['error'] as String,
    );

Map<String, dynamic> _$BulkActionErrorToJson(_BulkActionError instance) =>
    <String, dynamic>{
      'registration_id': instance.registrationId,
      'error': instance.error,
    };
