// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopResult _$ShopResultFromJson(Map<String, dynamic> json) => ShopResult(
  data:
      (json['data'] as List<dynamic>)
          .map((e) => Shop.fromJson(e as Map<String, dynamic>))
          .toList(),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShopResultToJson(ShopResult instance) =>
    <String, dynamic>{'data': instance.data, 'pagination': instance.pagination};
