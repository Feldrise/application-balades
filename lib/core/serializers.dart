import 'package:freezed_annotation/freezed_annotation.dart';

class DateSerializer implements JsonConverter<DateTime?, String?> {
  const DateSerializer();

  @override
  DateTime? fromJson(String? timestamp) => DateTime.tryParse(timestamp ?? 'invalide')?.toLocal();

  @override
  String? toJson(DateTime? date) => date?.toUtc().toIso8601String();
}
