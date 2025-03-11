import 'package:json_annotation/json_annotation.dart';
import 'package:mylaundry/models/shop/shop.dart';
import 'package:mylaundry/models/user/user.dart';

part 'laundry.g.dart';

@JsonSerializable()
class Laundry {
  final int id;
  @JsonKey(name: 'claim_code')
  final String claimCode;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'shop_id')
  final int shopId;
  final double weight;
  @JsonKey(name: 'with_pickup')
  final bool withPickup;
  @JsonKey(name: 'with_delivery')
  final bool withDelivery;
  @JsonKey(name: 'pickup_address')
  final String pickupAddress;
  @JsonKey(name: 'delivery_address')
  final String deliveryAddress;
  final double total;
  final String description;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User user;
  final Shop shop;

  Laundry({
    required this.id,
    required this.claimCode,
    required this.userId,
    required this.shopId,
    required this.weight,
    required this.withPickup,
    required this.withDelivery,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.total,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.shop,
  });

  factory Laundry.fromJson(Map<String, dynamic> json) =>
      _$LaundryFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryToJson(this);
}


/*
{
            "id": 1,
            "claim_code": "sakjhsaiu",
            "user_id": 1,
            "shop_id": 2,
            "weight": 2.3,
            "with_pickup": 1,
            "with_delivery": 1,
            "pickup_address": "811 South San Fernando, Boulevard Burbank, CA 91502",
            "delivery_address": "811 South San Fernando, Boulevard Burbank, CA 91502",
            "total": 50000,
            "description": "baju koko, sarung, sajadah",
            "status": "Done",
            "created_at": "2023-04-11T08:50:49.000000Z",
            "updated_at": "2023-04-11T08:50:49.000000Z",
            "user": {
                "id": 1,
                "username": "mylaundryadmin",
                "email": "mylaundry@gmail.com",
                "email_verified_at": null,
                "created_at": "2025-03-10T08:31:17.000000Z",
                "updated_at": "2025-03-10T08:31:17.000000Z"
            },
            "shop": {
                "id": 2,
                "image": "blue white lock.jpg",
                "name": "Blue White Lock",
                "location": "Jl. Sumbawa no 40",
                "city": "Bandung",
                "delivery": 0,
                "pickup": 1,
                "whatsapp": "620812345672",
                "description": "Laundry refers to the washing of clothing and other textiles, and, more broadly, their drying and ironing as well. Laundry has been part of history since humans began to wear clothes, so the methods by which different cultures have dealt with this universal human need are of interest to several branches of scholarship.",
                "price": 23000,
                "rating": 4.3,
                "created_at": "2025-03-10T08:31:17.000000Z",
                "updated_at": "2025-03-10T08:31:17.000000Z"
            }
        },
*/