import 'package:json_annotation/json_annotation.dart';

part 'loan.g.dart';

enum LoanType { due, balance }

@JsonSerializable()
class Loan {
  final String id;
  final String personName;
  final double amount;
  final DateTime lastActivityDate;
  final LoanType type;

  Loan({
    required this.id,
    required this.personName,
    required this.amount,
    required this.lastActivityDate,
    required this.type,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);
  Map<String, dynamic> toJson() => _$LoanToJson(this);

  Loan copyWith({
    String? id,
    String? personName,
    double? amount,
    DateTime? lastActivityDate,
    LoanType? type,
  }) {
    return Loan(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      type: type ?? this.type,
    );
  }
}
