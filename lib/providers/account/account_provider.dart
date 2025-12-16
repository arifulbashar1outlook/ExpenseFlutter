import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/account.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];
  final CollectionReference _accountsCollection = FirebaseFirestore.instance
      .collection('accounts');

  AccountProvider() {
    _fetchAccounts();
  }

  List<Account> get accounts => [..._accounts];

  Future<void> _fetchAccounts() async {
    try {
      final snapshot = await _accountsCollection.get();
      _accounts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Account.fromJson(data)..id = doc.id;
      }).toList();
      developer.log('Fetched accounts: $_accounts', name: 'account_provider');
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error fetching accounts: $error',
        name: 'account_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Account findById(String id) {
    return _accounts.firstWhere((acc) => acc.id == id);
  }

  Future<void> addAccount(Account account) async {
    try {
      developer.log(
        'Adding account: ${account.name}',
        name: 'account_provider',
      );
      final docRef = await _accountsCollection.add(account.toJson());
      account.id = docRef.id;
      _accounts.add(account);
      developer.log(
        'Accounts after adding: $_accounts',
        name: 'account_provider',
      );
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error adding account: $error',
        name: 'account_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> editAccount(String id, String newName) async {
    try {
      developer.log(
        'Editing account: $id to $newName',
        name: 'account_provider',
      );
      await _accountsCollection.doc(id).update({'name': newName});
      final account = findById(id);
      account.name = newName;
      developer.log(
        'Accounts after editing: $_accounts',
        name: 'account_provider',
      );
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error editing account: $error',
        name: 'account_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      developer.log('Deleting account: $id', name: 'account_provider');
      await _accountsCollection.doc(id).delete();
      _accounts.removeWhere((acc) => acc.id == id);
      developer.log(
        'Accounts after deleting: $_accounts',
        name: 'account_provider',
      );
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error deleting account: $error',
        name: 'account_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> updateBalance(
    String accountId,
    double amount,
    bool isIncome,
  ) async {
    try {
      final account = findById(accountId);
      final newBalance = isIncome
          ? account.balance + amount
          : account.balance - amount;
      await _accountsCollection.doc(accountId).update({'balance': newBalance});
      account.balance = newBalance;
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error updating balance: $error',
        name: 'account_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
