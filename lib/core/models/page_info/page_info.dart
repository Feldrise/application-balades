import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_info.freezed.dart';
part 'page_info.g.dart';

@freezed
abstract class PageInfo with _$PageInfo {
  const factory PageInfo({required bool hasNextPage, required String endCursor}) = _PageInfo;

  factory PageInfo.fromJson(Map<String, Object?> json) => _$PageInfoFromJson(json);
}
