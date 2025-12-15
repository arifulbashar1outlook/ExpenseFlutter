enum LoanTransactionType { lent, received }

class LoanTransaction {
  final String id;
  final String loanId;
  final String description;
  final double amount;
  final DateTime date;
  final LoanTransactionType type;

  LoanTransaction({
    required this.id,
    required this.loanId,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}
