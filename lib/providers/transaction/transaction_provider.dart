import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/transaction.dart' as model;
import 'package:myapp/providers/account/account.dart';

class TransactionProvider with ChangeNotifier {
  AccountProvider? accountProvider;
  List<model.Transaction> _transactions = [];
  final CollectionReference _transactionCollection = FirebaseFirestore.instance
      .collection('transactions');
  bool _initialized = false;

  TransactionProvider();

  List<model.Transaction> get transactions => _transactions;

  void updateAccountProvider(AccountProvider newAccountProvider) {
    accountProvider = newAccountProvider;
    if (!_initialized) {
      _fetchTransactions();
      _initialized = true;
    }
  }

  Future<void> _fetchTransactions() async {
    try {
      final snapshot = await _transactionCollection
          .orderBy('date', descending: true)
          .get();
      _transactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return model.Transaction.fromJson(data)..id = doc.id;
      }).toList();
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error fetching transactions: $error',
        name: 'transaction_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> addTransaction(model.Transaction transaction) async {
    if (accountProvider == null) return;
    try {
      final docRef = await _transactionCollection.add(transaction.toJson());
      transaction.id = docRef.id;
      _transactions.insert(0, transaction);
      final isIncome = transaction.type == model.TransactionType.income;
      await accountProvider!.updateBalance(
        transaction.accountId,
        transaction.amount,
        isIncome,
      );
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error adding transaction: $error',
        name: 'transaction_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    if (accountProvider == null) return;
    try {
      final index = _transactions.indexWhere(
        (trans) => trans.id == transactionId,
      );
      if (index != -1) {
        final transaction = _transactions[index];
        await _transactionCollection.doc(transactionId).delete();
        _transactions.removeAt(index);
        final isIncome = transaction.type == model.TransactionType.income;
        await accountProvider!.updateBalance(
          transaction.accountId,
          transaction.amount,
          !isIncome,
        );
        notifyListeners();
      }
    } catch (error, stackTrace) {
      developer.log(
        'Error deleting transaction: $error',
        name: 'transaction_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void editTransactionByLoanTransaction(model.Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (trans) => trans.id == updatedTransaction.id,
    );
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  void deleteTransactionByLoanTransaction(model.Transaction transaction) {
    final index = _transactions.indexWhere(
      (trans) => trans.id == transaction.id,
    );
    if (index != -1) {
      _transactions.removeAt(index);
      notifyListeners();
    }
  }

  Map<String, double> getCategoryDistribution() {
    final expenseTransactions = _transactions.where(
      (t) => t.type == model.TransactionType.expense,
    );
    final totalExpense = expenseTransactions.fold<double>(
      0.0,
      (previousValue, item) => previousValue + item.amount,
    );

    if (totalExpense == 0) {
      return {};
    }

    final categoryExpenses = <String, double>{};
    for (var transaction in expenseTransactions) {
      categoryExpenses.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final categoryDistribution = <String, double>{};
    categoryExpenses.forEach((category, amount) {
      categoryDistribution[category] = (amount / totalExpense) * 100;
    });

    return categoryDistribution;
  }

  double getAccountBalance(String accountId) {
    return 0.0;
  }
}
