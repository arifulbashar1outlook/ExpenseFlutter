import 'package:flutter/foundation.dart';
import 'package:myapp/models/loan_transaction.dart';

class LoanTransactionProvider with ChangeNotifier {
  final List<LoanTransaction> _transactions = [
    LoanTransaction(
      id: '1',
      loanId: '1',
      description: 'Lent Money',
      amount: 5000,
      date: DateTime(2025, 8, 12),
      type: LoanTransactionType.lent,
    ),
  ];

  List<LoanTransaction> get transactions => [..._transactions];

  List<LoanTransaction> getTransactionsForLoan(String loanId) {
    return _transactions.where((tx) => tx.loanId == loanId).toList();
  }

  void addTransaction(LoanTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
