import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/providers/providers.dart';

class BazarProvider with ChangeNotifier {
  AccountProvider? accountProvider;
  List<BazarItem> _items = [];
  final CollectionReference _bazarCollection = FirebaseFirestore.instance
      .collection('bazar');
  bool _initialized = false;

  BazarProvider();

  List<BazarItem> get items => _items;

  void updateAccountProvider(AccountProvider newAccountProvider) {
    accountProvider = newAccountProvider;
    if (!_initialized) {
      _fetchBazarItems();
      _initialized = true;
    }
  }

  Future<void> _fetchBazarItems() async {
    try {
      final snapshot = await _bazarCollection.get();
      _items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BazarItem.fromJson(data)..id = doc.id;
      }).toList();
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error fetching bazar items: $error',
        name: 'bazar_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  double get totalCost {
    return _items.fold(0.0, (previousValue, item) => previousValue + item.cost);
  }

  Future<void> addItem(BazarItem item, String accountId) async {
    if (accountProvider == null) return;
    try {
      final docRef = await _bazarCollection.add(item.toJson());
      item.id = docRef.id;
      _items.add(item);
      await accountProvider!.updateBalance(accountId, item.cost, false);
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error adding bazar item: $error',
        name: 'bazar_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> editItem(BazarItem updatedItem) async {
    if (accountProvider == null) return;
    try {
      final index = _items.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        final oldItem = _items[index];
        final costDifference = updatedItem.cost - oldItem.cost;
        await _bazarCollection.doc(updatedItem.id).update(updatedItem.toJson());
        _items[index] = updatedItem;
        await accountProvider!.updateBalance(
          oldItem.accountId,
          costDifference,
          false,
        );
        notifyListeners();
      }
    } catch (error, stackTrace) {
      developer.log(
        'Error editing bazar item: $error',
        name: 'bazar_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteItem(BazarItem item) async {
    if (accountProvider == null) return;
    try {
      await _bazarCollection.doc(item.id).delete();
      _items.removeWhere((i) => i.id == item.id);
      await accountProvider!.updateBalance(item.accountId, item.cost, true);
      notifyListeners();
    } catch (error, stackTrace) {
      developer.log(
        'Error deleting bazar item: $error',
        name: 'bazar_provider',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
