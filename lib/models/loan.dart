import 'package:json_annotation/json_annotation.dart';

part 'loan.g.dart';

enum LoanType { lent, borrowed }

@JsonSerializable()
class Loan {
  String id;
  final String personName;
  final double amount;
  final LoanType type;
  final DateTime date;
  final bool isSettled;

  Loan({
    required this.id,
    required this.personName,
    required this.amount,
    required this.type,
    required this.date,
    this.isSettled = false,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);

  Map<String, dynamic> toJson() => _$LoanToJson(this);

  Loan copyWith({
    String? id,
    String? personName,
    double? amount,
    LoanType? type,
    DateTime? date,
    bool? isSettled,
  }) {
    return Loan(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      isSettled: isSettled ?? this.isSettled,
    );
  }
}
