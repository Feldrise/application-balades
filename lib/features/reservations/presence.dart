/// A change of the presence of a participant, made on the guide's phone at [markedAt] and maybe sent later.
class PresenceChange {
  const PresenceChange({required this.participantId, required this.present, required this.markedAt});

  factory PresenceChange.fromJson(Map<String, Object?> json) =>
      PresenceChange(participantId: json['participant_id'] as int, present: json['present'] as bool?, markedAt: DateTime.parse(json['marked_at'] as String));

  final int participantId;

  /// True when present, false when absent, null when unmarked.
  final bool? present;
  final DateTime markedAt;

  Map<String, Object?> toJson() => {'participant_id': participantId, 'present': present, 'marked_at': markedAt.toUtc().toIso8601String()};
}

/// What became of a presence change sent to the API, with the presence it recorded afterwards.
class PresenceOutcome {
  const PresenceOutcome({required this.participantId, required this.outcome, required this.present});

  factory PresenceOutcome.fromJson(Map<String, Object?> json) =>
      PresenceOutcome(participantId: json['participant_id'] as int, outcome: json['outcome'] as String, present: json['present'] as bool?);

  final int participantId;

  /// `applied`, `unchanged`, `outdated` (a later change was already recorded), `reservation_cancelled` or `unknown_participant`.
  final String outcome;
  final bool? present;
}
