import 'package:flutter/foundation.dart';
import 'package:myapp/models/loan_transaction.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Salary',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.income,
      accountId: '2',
    ),
    Transaction(
      id: '2',
      title: 'Lent to Nur Alam',
      amount: 5000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.expense,
      accountId: '1',
      category: 'Lending & Debt',
    ),
    Transaction(
      id: '3',
      title: 'Lent to Deep',
      amount: 10000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      accountId: '1',
      category: 'Lending & Debt',
    ),
    Transaction(
      id: '4',
      title: 'Maa bKash',
      amount: 2040,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      accountId: '1',
      category: 'Other',
    ),
    Transaction(
      id: '5',
      title: 'Internet Bill',
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      accountId: '1',
      category: 'Utilities',
    ),
    Transaction(
      id: '6',
      title: 'Gas Cylinder',
      amount: 1280,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      accountId: '1',
      category: 'Utilities',
    ),
  ];

  List<Transaction> get transactions => [..._transactions];

  List<Transaction> get expenses {
    return _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .toList();
  }

  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void editTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (tx) => tx.id == updatedTransaction.id,
    );
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  void deleteTransaction(String transactionId) {
    _transactions.removeWhere((tx) => tx.id == transactionId);
    notifyListeners();
  }

  void editTransactionByLoanTransaction(LoanTransaction loanTransaction) {
    final index = _transactions.indexWhere(
      (tx) =>
          tx.title == loanTransaction.description &&
          tx.date == loanTransaction.date,
    );
    if (index != -1) {
      final oldTransaction = _transactions[index];
      final newTransaction = Transaction(
        id: oldTransaction.id,
        title: loanTransaction.description,
        amount: loanTransaction.amount,
        date: loanTransaction.date,
        category: oldTransaction.category,
        type: oldTransaction.type,
        accountId: loanTransaction.accountId,
      );
      _transactions[index] = newTransaction;
      notifyListeners();
    }
  }

  void deleteTransactionByLoanTransaction(LoanTransaction loanTransaction) {
    _transactions.removeWhere(
      (tx) =>
          tx.title == loanTransaction.description &&
          tx.date == loanTransaction.date,
    );
    notifyListeners();
  }
}
