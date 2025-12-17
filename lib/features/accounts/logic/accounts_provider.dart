import 'package:flutter/material.dart';
import '../data/account_model.dart';

class AccountsProvider with ChangeNotifier {
  List<Account> _accounts = [];

  AccountsProvider() {
    _loadAccounts();
  }

  List<Account> get accounts => _accounts;

  void _loadAccounts() async {
    // TODO: Load accounts from a persistent storage
    _accounts = [];
    notifyListeners();
  }

  void addAccount(Account account) async {
    _accounts.add(account);
    // TODO: Save accounts to a persistent storage
    notifyListeners();
  }
}
