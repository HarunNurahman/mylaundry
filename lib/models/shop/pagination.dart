import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  @JsonKey(name: 'total_item')
  final int totalItem;
  @JsonKey(name: 'total_page')
  final int totalPage;
  @JsonKey(name: 'current_page')
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalItem,
    required this.totalPage,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
