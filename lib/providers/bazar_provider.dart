import 'package:flutter/material.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:uuid/uuid.dart';

class BazarProvider with ChangeNotifier {
  final List<BazarItem> _items = [];

  List<BazarItem> get items => _items;

  double get totalCost {
    return _items.fold(0.0, (sum, item) => sum + item.cost);
  }

  void addItem(String name, double cost, DateTime date, String accountId, String category) {
    final newItem = BazarItem(
      id: Uuid().v4(),
      name: name,
      cost: cost,
      date: date,
      accountId: accountId,
      category: category,
    );
    _items.add(newItem);
    notifyListeners();
  }
}
