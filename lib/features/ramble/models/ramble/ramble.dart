import 'package:balade/core/serializers.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ramble.freezed.dart';
part 'ramble.g.dart';

Map<String, IconData> rambleTypeIcons = {
  'champignons': Icons.park,
  'oiseaux': Icons.flutter_dash,
  'plantes': Icons.local_florist,
  'faune': Icons.pets,
  'geologie': Icons.landscape,
  'astronomie': Icons.star,
  'botanique': Icons.eco,
  'decouverte': Icons.explore,
};

Map<String, String> rambleTypeLabels = {
  'champignons': 'Champignons',
  'oiseaux': 'Oiseaux',
  'plantes': 'Plantes',
  'faune': 'Faune',
  'geologie': 'Géologie',
  'astronomie': 'Astronomie',
  'botanique': 'Botanique',
  'decouverte': 'Découverte',
};

Map<String, Color> rambleDifficultyColors = {'facile': Colors.green, 'modere': Colors.orange, 'difficile': Colors.red};

Map<String, String> rambleDifficultyLabels = {'facile': 'Facile', 'modere': 'Modéré', 'difficile': 'Difficile'};

@freezed
abstract class Ramble with _$Ramble {
  const factory Ramble(
    int id, {
    required String title,
    required String status,
    String? description,
    required String type,
    @DateSerializer() DateTime? date,
    String? location,
    @JsonKey(name: 'meeting_point') String? meetingPoint,
    @JsonKey(name: 'max_participants') int? maxParticipants,
    @Default(<RamblePrice>[]) List<RamblePrice> prices,
    required String difficulty,
    @DurationSerializer() @JsonKey(name: 'estimated_duration') Duration? estimatedDuration,
    @JsonKey(name: 'equipment_needed') String? equipmentNeeded,
    String? prerequisites,
    @JsonKey(name: 'cover_image') String? coverImage,
    @JsonKey(name: 'additional_documents_url') String? additionalDocumentsUrl,
    @Default(<Guide>[]) List<Guide> guides,
    @JsonKey(name: 'places_left') int? placesLeft,
  }) = _Ramble;

  factory Ramble.fromJson(Map<String, Object?> json) => _$RambleFromJson(json);
}

@freezed
abstract class RamblePrice with _$RamblePrice {
  const factory RamblePrice({required String label, required double amount}) = _RamblePrice;

  factory RamblePrice.fromJson(Map<String, Object?> json) => _$RamblePriceFromJson(json);
}
