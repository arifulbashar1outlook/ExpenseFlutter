import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/transactions_provider.dart';
import '../data/transaction_model.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, transactionsProvider, child) {
        return ListView.builder(
          itemCount: transactionsProvider.transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactionsProvider.transactions[index];
            return ListTile(
              title: Text(transaction.title),
              subtitle: Text(transaction.date.toString()),
              trailing: Text(
                '${transaction.type == TransactionType.expense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: transaction.type == TransactionType.expense ? Colors.red : Colors.green,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
