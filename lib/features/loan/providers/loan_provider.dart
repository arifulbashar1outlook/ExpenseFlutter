import 'package:flutter/material.dart';
import 'package:myapp/models/loan.dart';

class LoanProvider with ChangeNotifier {
  final List<Loan> _loans = [];

  List<Loan> get loans => _loans;

  void addLoan(Loan loan) {
    _loans.add(loan);
    // Here you could potentially interact with the account provider,
    // for example, to create a transaction associated with the loan.
    notifyListeners();
  }

  void settleLoan(String id) {
    final index = _loans.indexWhere((loan) => loan.id == id);
    if (index != -1) {
      _loans[index] = _loans[index].copyWith(isSettled: true);
      // Here you could also interact with the account provider,
      // for example, to create a transaction to settle the loan.
      notifyListeners();
    }
  }

  void updateLoanBalance(
    String loanId,
    double amount,
    bool isGiveLendSelected,
  ) {
    // This is a placeholder. A real implementation would be more complex
    // and likely involve a separate list of loan transactions.
    final index = _loans.indexWhere((loan) => loan.id == loanId);
    if (index != -1) {
      final currentLoan = _loans[index];
      final newAmount = isGiveLendSelected
          ? currentLoan.amount + amount
          : currentLoan.amount - amount;
      _loans[index] = _loans[index].copyWith(amount: newAmount);
      notifyListeners();
    }
  }

  double getLoanNetBalance(String loanId) {
    // This is a placeholder. A real implementation would calculate the balance
    // from a list of loan transactions.
    final loan = _loans.firstWhere(
      (loan) => loan.id == loanId,
      orElse: () => Loan(
        id: '',
        personName: '',
        amount: 0,
        type: LoanType.lent,
        date: DateTime.now(),
      ),
    );
    return loan.amount;
  }
}
