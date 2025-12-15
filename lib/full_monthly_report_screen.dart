import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/account.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/account_provider.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:myapp/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class FullMonthlyReportScreen extends StatefulWidget {
  const FullMonthlyReportScreen({super.key});

  @override
  State<FullMonthlyReportScreen> createState() =>
      _FullMonthlyReportScreenState();
}

class _FullMonthlyReportScreenState extends State<FullMonthlyReportScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + increment,
        1,
      );
    });
  }

  String _getExpenseTitle(Expense expense) {
    if (expense is Transaction) {
      return expense.title;
    } else if (expense is BazarItem) {
      return expense.name;
    }
    return 'Unnamed Expense';
  }

  void _showEditDeleteDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getExpenseTitle(expense)),
        content: const Text('Would you like to edit or delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (expense is Transaction) {
                // _showEditTransactionDialog(expense);
              } else if (expense is BazarItem) {
                // _showEditBazarItemDialog(expense);
              }
            },
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmationDialog(expense);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Expense expense) {
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
              if (expense is Transaction) {
                Provider.of<TransactionProvider>(
                  context,
                  listen: false,
                ).deleteTransaction(expense.id);
              } else if (expense is BazarItem) {
                Provider.of<BazarProvider>(
                  context,
                  listen: false,
                ).deleteItem(expense);
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
    final accountProvider = Provider.of<AccountProvider>(context);

    final monthlyTransactions = transactionProvider.transactions
        .where(
          (t) =>
              t.date.month == _selectedMonth.month &&
              t.date.year == _selectedMonth.year,
        )
        .toList();

    final monthlyBazarItems = bazarProvider.items
        .where(
          (i) =>
              i.date.month == _selectedMonth.month &&
              i.date.year == _selectedMonth.year,
        )
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            const Text(
              'Account Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildAccountStatus(accountProvider.accounts),
            const SizedBox(height: 20),
            const Text(
              'Monthly Flow',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildMonthlyFlowCards(monthlyTransactions, monthlyBazarItems),
            const SizedBox(height: 20),
            const Text(
              'Expense Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildExpenseBreakdown(monthlyTransactions, monthlyBazarItems),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _changeMonth(-1),
        ),
        Text(
          DateFormat.yMMMM().format(_selectedMonth),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildAccountStatus(List<Account> accounts) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return ListTile(
            leading: CircleAvatar(child: Text(account.name[0])),
            title: Text(account.name),
            trailing: Text(
              'Tk ${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
      ),
    );
  }

  Widget _buildMonthlyFlowCards(
    List<Transaction> monthlyTransactions,
    List<BazarItem> monthlyBazarItems,
  ) {
    final totalIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalTransactionExpenses = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalBazarExpenses = monthlyBazarItems.fold(
      0.0,
      (sum, i) => sum + i.amount,
    );

    final totalExpenses = totalTransactionExpenses + totalBazarExpenses;

    final netFlow = totalIncome - totalExpenses;

    return Column(
      children: [
        Card(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Income',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tk ${totalIncome.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tk ${totalExpenses.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Flow',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tk ${netFlow.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: netFlow >= 0 ? Colors.blue.shade800 : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseBreakdown(
    List<Transaction> monthlyTransactions,
    List<BazarItem> monthlyBazarItems,
  ) {
    final expenses = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
    final expenseMap = groupBy(
      expenses,
      (Transaction t) => t.category ?? 'Uncategorized',
    );

    final bazarTotal = monthlyBazarItems.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    final categoryTotals = expenseMap.map((key, value) {
      final total = value.fold(0.0, (sum, t) => sum + t.amount);
      return MapEntry(key, total);
    });

    if (bazarTotal > 0) {
      categoryTotals['Bazar'] = bazarTotal;
    }

    if (categoryTotals.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('No expenses recorded for this month.')),
        ),
      );
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Column(
        children: sortedCategories.map((entry) {
          final categoryName = entry.key;
          final categoryTotal = entry.value;

          List<Widget> children = [];
          if (categoryName == 'Bazar') {
            children = monthlyBazarItems.map((item) {
              return ListTile(
                title: Text(item.name),
                trailing: Text('Tk ${item.amount.toStringAsFixed(2)}'),
                onTap: () => _showEditDeleteDialog(item),
              );
            }).toList();
          } else {
            final categoryTransactions = expenseMap[categoryName] ?? [];
            children = categoryTransactions.map((transaction) {
              return ListTile(
                title: Text(transaction.title),
                trailing: Text('Tk ${transaction.amount.toStringAsFixed(2)}'),
                onTap: () => _showEditDeleteDialog(transaction),
              );
            }).toList();
          }

          return ExpansionTile(
            title: Row(
              children: [
                const Icon(Icons.circle, size: 10),
                const SizedBox(width: 10),
                Text(entry.key),
                const Spacer(),
                Text(
                  'Tk ${entry.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: children,
          );
        }).toList(),
      ),
    );
  }
}
