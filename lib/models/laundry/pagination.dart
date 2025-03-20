import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  @JsonKey(name: 'total_item')
  final int? totalItem;
  @JsonKey(name: 'total_page')
  final int? totalPage;
  @JsonKey(name: 'current_page')
  final int? currentPage;
  final int? limit;

  Pagination(this.totalItem, this.totalPage, this.currentPage, this.limit);

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
