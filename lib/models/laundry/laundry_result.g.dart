// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laundry_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaundryResult _$LaundryResultFromJson(Map<String, dynamic> json) =>
    LaundryResult(
      data:
          (json['data'] as List<dynamic>)
              .map((e) => Laundry.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LaundryResultToJson(LaundryResult instance) =>
    <String, dynamic>{'data': instance.data};
