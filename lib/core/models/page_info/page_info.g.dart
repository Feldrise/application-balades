// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => _PageInfo(
  hasNextPage: json['hasNextPage'] as bool,
  endCursor: json['endCursor'] as String,
);

Map<String, dynamic> _$PageInfoToJson(_PageInfo instance) => <String, dynamic>{
  'hasNextPage': instance.hasNextPage,
  'endCursor': instance.endCursor,
};
