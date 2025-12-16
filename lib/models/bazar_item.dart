import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/models/expense.dart';

part 'bazar_item.g.dart';

@JsonSerializable()
class BazarItem implements Expense {
  String id;
  final String name;
  final double cost;
  @override
  final DateTime date;
  final String accountId;
  @override
  final String category;

  BazarItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.date,
    required this.accountId,
    required this.category,
  });

  @override
  double get amount => cost;

  @override
  String get title => name;

  factory BazarItem.fromJson(Map<String, dynamic> json) =>
      _$BazarItemFromJson(json);
  Map<String, dynamic> toJson() => _$BazarItemToJson(this);
}
