// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ramble.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ramble _$RambleFromJson(Map<String, dynamic> json) => _Ramble(
  (json['id'] as num).toInt(),
  title: json['title'] as String,
  isCancelled: json['is_cancelled'] as bool? ?? false,
  cancellationDate: const DateSerializer().fromJson(
    json['cancellation_date'] as String?,
  ),
  cancellationReason: json['cancellation_reason'] as String?,
  description: json['description'] as String?,
  type: json['type'] as String,
  date: const DateSerializer().fromJson(json['date'] as String?),
  location: json['location'] as String?,
  meetingPoint: json['meeting_point'] as String?,
  maxParticipants: (json['max_participants'] as num?)?.toInt(),
  prices:
      (json['prices'] as List<dynamic>?)
          ?.map((e) => RamblePrice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RamblePrice>[],
  difficulty: json['difficulty'] as String,
  estimatedDuration: const DurationSerializer().fromJson(
    json['estimated_duration'] as String?,
  ),
  equipmentNeeded: json['equipment_needed'] as String?,
  prerequisites: json['prerequisites'] as String?,
  coverImage: json['cover_image'] as String?,
  additionalDocumentsUrl: json['additional_documents_url'] as String?,
  guides:
      (json['guides'] as List<dynamic>?)
          ?.map((e) => Guide.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Guide>[],
  placesLeft: (json['places_left'] as num?)?.toInt(),
);

Map<String, dynamic> _$RambleToJson(_Ramble instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'is_cancelled': instance.isCancelled,
  'cancellation_date': const DateSerializer().toJson(instance.cancellationDate),
  'cancellation_reason': instance.cancellationReason,
  'description': instance.description,
  'type': instance.type,
  'date': const DateSerializer().toJson(instance.date),
  'location': instance.location,
  'meeting_point': instance.meetingPoint,
  'max_participants': instance.maxParticipants,
  'prices': instance.prices,
  'difficulty': instance.difficulty,
  'estimated_duration': const DurationSerializer().toJson(
    instance.estimatedDuration,
  ),
  'equipment_needed': instance.equipmentNeeded,
  'prerequisites': instance.prerequisites,
  'cover_image': instance.coverImage,
  'additional_documents_url': instance.additionalDocumentsUrl,
  'guides': instance.guides,
  'places_left': instance.placesLeft,
};

_RamblePrice _$RamblePriceFromJson(Map<String, dynamic> json) => _RamblePrice(
  label: json['label'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$RamblePriceToJson(_RamblePrice instance) =>
    <String, dynamic>{'label': instance.label, 'amount': instance.amount};
