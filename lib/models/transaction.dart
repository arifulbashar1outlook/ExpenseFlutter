import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/models/expense.dart';

part 'transaction.g.dart';

enum TransactionType { income, expense }

@JsonSerializable()
class Transaction implements Expense {
  final String id;
  @override
  final String title;
  @override
  final double amount;
  @override
  final DateTime date;
  final TransactionType type;
  final String accountId;
  @override
  final String category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.accountId,
    String? category,
  }) : category = category ?? 'Other';

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
