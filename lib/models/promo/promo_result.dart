import 'package:json_annotation/json_annotation.dart';

import 'promo.dart';

part 'promo_result.g.dart';

@JsonSerializable()
class PromoResult {
  final List<Promo> data;

  PromoResult({required this.data});

  factory PromoResult.fromJson(Map<String, dynamic> json) =>
      _$PromoResultFromJson(json);

  Map<String, dynamic> toJson() => _$PromoResultToJson(this);
}
