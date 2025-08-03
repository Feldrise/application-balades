import 'package:freezed_annotation/freezed_annotation.dart';

class DateSerializer implements JsonConverter<DateTime?, String?> {
  const DateSerializer();

  @override
  DateTime? fromJson(String? timestamp) => DateTime.tryParse(timestamp ?? 'invalide')?.toLocal();

  @override
  String? toJson(DateTime? date) => date?.toUtc().toIso8601String();
}

class DurationSerializer implements JsonConverter<Duration?, String?> {
  const DurationSerializer();

  @override
  Duration? fromJson(String? duration) {
    if (duration == null || duration.isEmpty) return null;
    final parts = duration.split(':');
    if (parts.length != 3) return null; // Expected format is HH:MM:SS
    return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]), seconds: int.parse(parts[2]));
  }

  @override
  String? toJson(Duration? duration) => duration?.toString().split('.').first; // Exclude microseconds
}
