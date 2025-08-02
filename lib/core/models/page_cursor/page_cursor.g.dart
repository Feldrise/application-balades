// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_cursor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageCursor<T> _$PageCursorFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PageCursor<T>(
  cursor: json['cursor'] as String,
  node: fromJsonT(json['node']),
);

Map<String, dynamic> _$PageCursorToJson<T>(
  _PageCursor<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'cursor': instance.cursor,
  'node': toJsonT(instance.node),
};
