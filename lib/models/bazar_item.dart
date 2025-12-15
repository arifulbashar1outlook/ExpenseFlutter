import 'package:myapp/models/expense.dart';

class BazarItem implements Expense {
  final String id;
  final String name;
  final double cost;
  @override
  final DateTime date;
  final String accountId;
  @override
  final String category;

  BazarItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.date,
    required this.accountId,
    required this.category,
  });

  @override
  double get amount => cost;

  @override
  String get title => name;
}
