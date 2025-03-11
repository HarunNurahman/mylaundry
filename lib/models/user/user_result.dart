import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'user_result.g.dart';

@JsonSerializable()
class UserResult {
  final List<User> data;

  UserResult({required this.data});

  factory UserResult.fromJson(Map<String, dynamic> json) =>
      _$UserResultFromJson(json);

  Map<String, dynamic> toJson() => _$UserResultToJson(this);
}
