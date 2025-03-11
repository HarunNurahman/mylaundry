import 'package:json_annotation/json_annotation.dart';
import 'package:mylaundry/models/shop/shop.dart';

part 'promo.g.dart';

@JsonSerializable()
class Promo {
  final int id;
  final String image;
  @JsonKey(name: 'shop_id')
  final int shopId;
  @JsonKey(name: 'old_price')
  final double oldPrice;
  @JsonKey(name: 'new_price')
  final double newPrice;
  final String description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final Shop shop;

  Promo({
    required this.id,
    required this.image,
    required this.shopId,
    required this.oldPrice,
    required this.newPrice,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.shop,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => _$PromoFromJson(json);

  Map<String, dynamic> toJson() => _$PromoToJson(this);
}
