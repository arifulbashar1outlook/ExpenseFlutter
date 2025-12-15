import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:myapp/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _getItemTitle(dynamic item) {
    if (item is Transaction) {
      return item.title;
    } else if (item is BazarItem) {
      return item.name;
    }
    return 'Unnamed Item';
  }

  void _showEditDeleteDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getItemTitle(item)),
        content: const Text('Would you like to edit or delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (item is Transaction) {
                _showEditTransactionDialog(item);
              } else if (item is BazarItem) {
                _showEditBazarItemDialog(item);
              }
            },
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmationDialog(item);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(Transaction transaction) {
    // Implementation for editing a transaction
  }

  void _showEditBazarItemDialog(BazarItem item) {
    // Implementation for editing a bazar item
  }

  void _showDeleteConfirmationDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (item is Transaction) {
                Provider.of<TransactionProvider>(
                  context,
                  listen: false,
                ).deleteTransaction(item.id);
              } else if (item is BazarItem) {
                Provider.of<BazarProvider>(
                  context,
                  listen: false,
                ).deleteItem(item);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final bazarProvider = Provider.of<BazarProvider>(context);

    final allItems = <dynamic>[
      ...transactionProvider.transactions,
      ...bazarProvider.items,
    ];
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
      appBar: AppBar(title: const Text('Transaction History')),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...items.map((item) {
                if (item is Transaction) {
                  final isIncome = item.type == TransactionType.income;
                  final amountColor = isIncome ? Colors.green : Colors.red;
                  final icon = isIncome
                      ? Icons.arrow_upward
                      : Icons.arrow_downward;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: amountColor.withOpacity(0.1),
                        child: Icon(icon, color: amountColor),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.category ?? 'Other'),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}Tk ${item.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: amountColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _showEditDeleteDialog(item),
                    ),
                  );
                } else if (item is BazarItem) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        child: const Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.category),
                      trailing: Text(
                        '-Tk ${item.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _showEditDeleteDialog(item),
                    ),
                  );
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
