import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:myapp/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final bazarProvider = Provider.of<BazarProvider>(context);

    final allItems = <dynamic>[...transactionProvider.transactions, ...bazarProvider.items];
    allItems.sort((a, b) => b.date.compareTo(a.date));

    final groupedItems = <DateTime, List<dynamic>>{};
    for (var item in allItems) {
      final date = DateTime(item.date.year, item.date.month, item.date.day);
      if (groupedItems[date] == null) {
        groupedItems[date] = [];
      }
      groupedItems[date]!.add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: ListView.builder(
        itemCount: groupedItems.length,
        itemBuilder: (context, index) {
          final date = groupedItems.keys.elementAt(index);
          final items = groupedItems[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  DateFormat.yMMMEd().format(date),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...items.map((item) {
                if (item is Transaction) {
                  return TransactionListItem(transaction: item);
                } else if (item is Expense) {
                  return ExpenseListItem(expense: item);
                }
                return const SizedBox.shrink();
              }),
            ],
          );
        },
      ),
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(icon, color: amountColor),
        ),
        title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(transaction.category ?? 'Other'),
        trailing: Text(
          '${isIncome ? '+' : '-'}Tk ${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.withOpacity(0.1),
          child: const Icon(Icons.arrow_downward, color: Colors.red),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(expense.category),
        trailing: Text(
          '-Tk ${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
