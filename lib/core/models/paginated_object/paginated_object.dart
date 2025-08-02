// TODO: there is a bug in the code generation that makes the json to fail when using a different from json function
// I should make a PR to fix it

import 'package:balade/core/models/page_cursor/page_cursor.dart';
import 'package:balade/core/models/page_info/page_info.dart';

class PaginatedObject<T> {
  final List<PageCursor<T>> edges;
  final PageInfo? pageInfo;

  PaginatedObject({required this.edges, this.pageInfo});

  factory PaginatedObject.fromJson(Map<String, Object?> json, T Function(Object?) fromJsonT) {
    return PaginatedObject(
      edges: (json['edges'] as List).map((e) => PageCursor.fromJson(e as Map<String, Object?>, fromJsonT)).toList(),
      pageInfo: json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo'] as Map<String, Object?>) : null,
    );
  }

  Map<String, Object?> toJson(Object? Function(T) toJsonT) {
    return {'edges': edges.map((e) => e.toJson(toJsonT)).toList(), 'pageInfo': pageInfo?.toJson()};
  }

  @override
  String toString() {
    return 'PaginatedObject{edges: $edges, pageInfo: $pageInfo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginatedObject<T> && other.edges == edges && other.pageInfo == pageInfo;
  }

  @override
  int get hashCode {
    return edges.hashCode ^ pageInfo.hashCode;
  }

  PaginatedObject<T> copyWith({List<PageCursor<T>>? edges, PageInfo? pageInfo}) {
    return PaginatedObject<T>(edges: edges ?? this.edges, pageInfo: pageInfo ?? this.pageInfo);
  }
}
