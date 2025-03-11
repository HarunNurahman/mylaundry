import 'package:json_annotation/json_annotation.dart';

import 'laundry.dart';

part 'laundry_result.g.dart';

@JsonSerializable()
class LaundryResult {
  final List<Laundry> data;

  LaundryResult({required this.data});

  factory LaundryResult.fromJson(Map<String, dynamic> json) =>
      _$LaundryResultFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryResultToJson(this);
}
