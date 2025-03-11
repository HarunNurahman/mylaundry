// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laundry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Laundry _$LaundryFromJson(Map<String, dynamic> json) => Laundry(
  id: (json['id'] as num).toInt(),
  claimCode: json['claim_code'] as String,
  userId: (json['user_id'] as num).toInt(),
  shopId: (json['shop_id'] as num).toInt(),
  weight: (json['weight'] as num).toDouble(),
  withPickup: json['with_pickup'] as bool,
  withDelivery: json['with_delivery'] as bool,
  pickupAddress: json['pickup_address'] as String,
  deliveryAddress: json['delivery_address'] as String,
  total: (json['total'] as num).toDouble(),
  description: json['description'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  shop: Shop.fromJson(json['shop'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LaundryToJson(Laundry instance) => <String, dynamic>{
  'id': instance.id,
  'claim_code': instance.claimCode,
  'user_id': instance.userId,
  'shop_id': instance.shopId,
  'weight': instance.weight,
  'with_pickup': instance.withPickup,
  'with_delivery': instance.withDelivery,
  'pickup_address': instance.pickupAddress,
  'delivery_address': instance.deliveryAddress,
  'total': instance.total,
  'description': instance.description,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'user': instance.user,
  'shop': instance.shop,
};
