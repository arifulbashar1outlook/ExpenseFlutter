import 'package:flutter/foundation.dart';
import 'package:myapp/models/loan_transaction.dart';
import 'package:myapp/models/transaction.dart' as main_app;
import 'package:myapp/features/transaction/providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

class LoanTransactionProvider with ChangeNotifier {
  final List<LoanTransaction> _transactions = [
    LoanTransaction(
      id: '1',
      loanId: '1',
      description: 'Lent Money',
      amount: 5000,
      date: DateTime(2025, 8, 12),
      type: LoanTransactionType.lent,
      accountId: '1',
    ),
  ];

  TransactionProvider _transactionProvider;

  LoanTransactionProvider(this._transactionProvider);

  List<LoanTransaction> get transactions => [..._transactions];

  List<LoanTransaction> getTransactionsForLoan(String loanId) {
    return _transactions.where((tx) => tx.loanId == loanId).toList();
  }

  void addTransaction(LoanTransaction transaction) {
    _transactions.add(transaction);

    final mainTransaction = main_app.Transaction(
      id: const Uuid().v4(),
      title: transaction.description,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.type == LoanTransactionType.lent
          ? 'Lending'
          : 'Repayment',
      type: transaction.type == LoanTransactionType.lent
          ? main_app.TransactionType.expense
          : main_app.TransactionType.income,
      accountId: transaction.accountId,
    );
    _transactionProvider.addTransaction(mainTransaction);

    notifyListeners();
  }

  void editTransaction(LoanTransaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (tx) => tx.id == updatedTransaction.id,
    );
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      final mainTransaction = main_app.Transaction(
        id: updatedTransaction.id,
        title: updatedTransaction.description,
        amount: updatedTransaction.amount,
        date: updatedTransaction.date,
        category: updatedTransaction.type == LoanTransactionType.lent
            ? 'Lending'
            : 'Repayment',
        type: updatedTransaction.type == LoanTransactionType.lent
            ? main_app.TransactionType.expense
            : main_app.TransactionType.income,
        accountId: updatedTransaction.accountId,
      );
      _transactionProvider.editTransactionByLoanTransaction(mainTransaction);
      notifyListeners();
    }
  }

  void deleteTransaction(String transactionId) {
    final transaction = _transactions.firstWhere(
      (tx) => tx.id == transactionId,
    );
    final mainTransaction = main_app.Transaction(
      id: transaction.id,
      title: transaction.description,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.type == LoanTransactionType.lent
          ? 'Lending'
          : 'Repayment',
      type: transaction.type == LoanTransactionType.lent
          ? main_app.TransactionType.expense
          : main_app.TransactionType.income,
      accountId: transaction.accountId,
    );
    _transactionProvider.deleteTransactionByLoanTransaction(mainTransaction);
    _transactions.removeWhere((tx) => tx.id == transactionId);
    notifyListeners();
  }

  void update(TransactionProvider transactionProvider) {
    _transactionProvider = transactionProvider;
  }
}
