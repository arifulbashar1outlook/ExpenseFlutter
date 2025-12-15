// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazar_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BazarItem _$BazarItemFromJson(Map<String, dynamic> json) => BazarItem(
  id: json['id'] as String,
  name: json['name'] as String,
  cost: (json['cost'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  accountId: json['accountId'] as String,
  category: json['category'] as String,
);

Map<String, dynamic> _$BazarItemToJson(BazarItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'cost': instance.cost,
  'date': instance.date.toIso8601String(),
  'accountId': instance.accountId,
  'category': instance.category,
};
