import 'package:flutter/material.dart' show Icons, IconData;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'guide.freezed.dart';
part 'guide.g.dart';

// Certification levels with labels
const Map<String, String> kCertificationLevelLabels = {
  'debutant': 'Débutant',
  'intermediaire': 'Intermédiaire',
  'avance': 'Avancé',
  'expert': 'Expert',
  'professionnel': 'Professionnel',
};

const Map<String, IconData> kCertificationLevelIcons = {
  'debutant': Icons.school,
  'intermediaire': Icons.star_half,
  'avance': Icons.star,
  'expert': Icons.stars,
  'professionnel': Icons.verified,
};

@freezed
abstract class Guide with _$Guide {
  const factory Guide(
    int id, {
    @JsonKey(name: "first_name") required String firstName,
    @JsonKey(name: "last_name") required String lastName,
    required String email,
    String? phone,
    String? bio,
    String? experience,
    String? specialties,
    String? languages,
    @JsonKey(name: "certification_level") String? certificationLevel,
    String? avatar,
    @JsonKey(name: "is_active") required bool isActive,
    @JsonKey(name: "emergency_contact_name") String? emergencyContactName,
    @JsonKey(name: "emergency_contact_phone") String? emergencyContactPhone,
  }) = _Guide;

  factory Guide.fromJson(Map<String, Object?> json) => _$GuideFromJson(json);
}
