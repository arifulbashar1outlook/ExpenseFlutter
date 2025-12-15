import 'package:flutter/foundation.dart';
import '../models/account.dart';

class AccountProvider with ChangeNotifier {
  final List<Account> _accounts = [
    Account(id: '1', name: 'EBL', balance: 10000.00),
    Account(id: '2', name: 'bKash', balance: 25000.00),
    Account(id: '3', name: 'Nagad', balance: 1500.00),
    Account(id: '4', name: 'Cash', balance: 5000.00),
  ];

  List<Account> get accounts => [..._accounts];

  Account findById(String id) {
    return _accounts.firstWhere((acc) => acc.id == id);
  }

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void editAccount(String id, String newName) {
    final account = findById(id);
    account.name = newName;
    notifyListeners();
  }

  void deleteAccount(String id) {
    _accounts.removeWhere((acc) => acc.id == id);
    notifyListeners();
  }

  void updateBalance(String accountId, double amount, bool isIncome) {
    final account = findById(accountId);
    if (isIncome) {
      account.balance += amount;
    } else {
      account.balance -= amount;
    }
    notifyListeners();
  }
}
