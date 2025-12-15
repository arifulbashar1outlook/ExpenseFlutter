enum LoanType { due, balance }

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
}
