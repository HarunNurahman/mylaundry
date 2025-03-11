import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop {
  final int id;
  final String image;
  final String name;
  final String location;
  final String city;
  final bool delivery;
  final bool pickup;
  final String whatsapp;
  final String description;
  final double price;
  final double rating;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Shop({
    required this.id,
    required this.image,
    required this.name,
    required this.location,
    required this.city,
    required this.delivery,
    required this.pickup,
    required this.whatsapp,
    required this.description,
    required this.price,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
