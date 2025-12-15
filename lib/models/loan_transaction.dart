import 'package:json_annotation/json_annotation.dart';

part 'loan_transaction.g.dart';

enum LoanTransactionType { lent, received }

@JsonSerializable()
class LoanTransaction {
  final String id;
  final String loanId;
  final String description;
  final double amount;
  final DateTime date;
  final LoanTransactionType type;
  final String accountId;

  LoanTransaction({
    required this.id,
    required this.loanId,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.accountId,
  });

  factory LoanTransaction.fromJson(Map<String, dynamic> json) => _$LoanTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$LoanTransactionToJson(this);
}
