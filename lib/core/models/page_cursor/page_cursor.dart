import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_cursor.freezed.dart';
part 'page_cursor.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PageCursor<T> with _$PageCursor<T> {
  const factory PageCursor({required String cursor, required T node}) = _PageCursor;

  factory PageCursor.fromJson(Map<String, Object?> json, T Function(Object?) fromJsonT) => _$PageCursorFromJson(json, fromJsonT);
}
