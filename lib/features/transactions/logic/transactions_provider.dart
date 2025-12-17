import 'package:flutter/material.dart';
import '../data/transaction_model.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  TransactionsProvider() {
    _loadTransactions();
  }

  List<Transaction> get transactions => _transactions;

  void _loadTransactions() async {
    // TODO: Load transactions from a persistent storage
    _transactions = [];
    notifyListeners();
  }

  void addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    // TODO: Save transactions to a persistent storage
    notifyListeners();
  }
}
