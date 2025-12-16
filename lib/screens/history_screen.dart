import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/transaction/providers/transaction_provider.dart';
import 'package:myapp/models/transaction.dart' as model;
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final groupedTransactions = groupBy(
      transactions,
      (transaction) => DateFormat.yMMMM().format(transaction.date),
    );

    return DefaultTabController(
      length: groupedTransactions.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          bottom: TabBar(
            isScrollable: true,
            tabs: groupedTransactions.keys
                .map((month) => Tab(text: month))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: groupedTransactions.keys.map((month) {
            final monthlyTransactions = groupedTransactions[month]!;
            return ListView.builder(
              itemCount: monthlyTransactions.length,
              itemBuilder: (context, index) {
                final transaction = monthlyTransactions[index];
                return ListTile(
                  leading: Icon(
                    transaction.type == model.TransactionType.income
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: transaction.type == model.TransactionType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(transaction.category),
                  subtitle: Text(
                    DateFormat.yMd().add_jm().format(transaction.date),
                  ),
                  trailing: Text(
                    '${transaction.type == model.TransactionType.income ? '+' : '-'}Tk ${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == model.TransactionType.income
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
