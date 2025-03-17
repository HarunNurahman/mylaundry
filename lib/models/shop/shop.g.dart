// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
  id: (json['id'] as num).toInt(),
  image: json['image'] as String,
  name: json['name'] as String,
  location: json['location'] as String,
  city: json['city'] as String,
  delivery: json['delivery'] == 1,
  pickup: json['pickup'] == 1,
  whatsapp: json['whatsapp'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'location': instance.location,
  'city': instance.city,
  'delivery': instance.delivery,
  'pickup': instance.pickup,
  'whatsapp': instance.whatsapp,
  'description': instance.description,
  'price': instance.price,
  'rating': instance.rating,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
