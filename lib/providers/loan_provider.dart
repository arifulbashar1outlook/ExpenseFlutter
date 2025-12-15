import 'package:flutter/foundation.dart';
import 'package:myapp/models/loan.dart';

class LoanProvider with ChangeNotifier {
  final List<Loan> _loans = [
    Loan(
      id: '1',
      personName: 'Nur Alam',
      amount: 5000,
      lastActivityDate: DateTime(2025, 2, 10),
      type: LoanType.due,
    ),
    Loan(
      id: '2',
      personName: 'Deep',
      amount: 10000,
      lastActivityDate: DateTime(2025, 2, 10),
      type: LoanType.balance,
    ),
  ];

  List<Loan> get loans => [..._loans];

  void addLoan(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }

  void updateLoanBalance(String loanId, double amount, bool isLent) {
    final loanIndex = _loans.indexWhere((loan) => loan.id == loanId);
    if (loanIndex != -1) {
      final loan = _loans[loanIndex];
      final newAmount = isLent ? loan.amount + amount : loan.amount - amount;
      _loans[loanIndex] = loan.copyWith(
        amount: newAmount,
        lastActivityDate: DateTime.now(),
        type: newAmount >= 0 ? LoanType.balance : LoanType.due,
      );
      notifyListeners();
    }
  }

  double getLoanNetBalance(String loanId) {
    // This is a simplified calculation. A more robust implementation would
    // calculate this from the loan transactions.
    final loan = _loans.firstWhere(
      (loan) => loan.id == loanId,
      orElse: () => throw Exception('Loan not found'),
    );
    return loan.amount;
  }
}
