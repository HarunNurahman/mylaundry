import 'package:json_annotation/json_annotation.dart';

import 'pagination.dart';
import 'shop.dart';

part 'shop_result.g.dart';

@JsonSerializable()
class ShopResult {
  final List<Shop> data;
  final Pagination pagination;

  ShopResult({required this.data, required this.pagination});

  factory ShopResult.fromJson(Map<String, dynamic> json) =>
      _$ShopResultFromJson(json);
  Map<String, dynamic> toJson() => _$ShopResultToJson(this);
}
