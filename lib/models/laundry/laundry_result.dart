import 'package:json_annotation/json_annotation.dart';

import 'laundry.dart';
import 'pagination.dart';

part 'laundry_result.g.dart';

@JsonSerializable()
class LaundryResult {
  final List<Laundry> data;
  final Pagination? pagination;

  LaundryResult({required this.data, this.pagination});

  factory LaundryResult.fromJson(Map<String, dynamic> json) =>
      _$LaundryResultFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryResultToJson(this);
}
