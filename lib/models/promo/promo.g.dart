// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promo _$PromoFromJson(Map<String, dynamic> json) => Promo(
  id: (json['id'] as num).toInt(),
  image: json['image'] as String,
  shopId: (json['shop_id'] as num).toInt(),
  oldPrice: (json['old_price'] as num).toDouble(),
  newPrice: (json['new_price'] as num).toDouble(),
  description: json['description'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  shop: Shop.fromJson(json['shop'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PromoToJson(Promo instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'shop_id': instance.shopId,
  'old_price': instance.oldPrice,
  'new_price': instance.newPrice,
  'description': instance.description,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'shop': instance.shop,
};
