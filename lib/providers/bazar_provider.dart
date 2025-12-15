import 'package:flutter/material.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/providers/account_provider.dart';

class BazarProvider with ChangeNotifier {
  final AccountProvider accountProvider;
  final List<BazarItem> _items = [];

  BazarProvider(this.accountProvider);

  List<BazarItem> get items => _items;

  double get totalCost {
    return _items.fold(0.0, (sum, item) => sum + item.cost);
  }

  void addItem(BazarItem item, String accountId) {
    _items.add(item);
    accountProvider.updateBalance(accountId, item.cost, false);
    notifyListeners();
  }

  void editItem(BazarItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      final oldItem = _items[index];
      final costDifference = updatedItem.cost - oldItem.cost;
      _items[index] = updatedItem;
      accountProvider.updateBalance(oldItem.accountId, costDifference, false);
      notifyListeners();
    }
  }

  void deleteItem(BazarItem item) {
    _items.removeWhere((i) => i.id == item.id);
    accountProvider.updateBalance(item.accountId, item.cost, true);
    notifyListeners();
  }
}
