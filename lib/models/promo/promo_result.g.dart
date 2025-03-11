// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoResult _$PromoResultFromJson(Map<String, dynamic> json) => PromoResult(
  data:
      (json['data'] as List<dynamic>)
          .map((e) => Promo.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$PromoResultToJson(PromoResult instance) =>
    <String, dynamic>{'data': instance.data};
