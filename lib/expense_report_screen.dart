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

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
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
                _showEditTransactionDialog(expense);
              } else if (expense is BazarItem) {
                _showEditBazarItemDialog(expense);
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

  void _showEditTransactionDialog(Transaction transaction) {
    // Similar to the edit dialog in history_screen.dart
  }

  void _showEditBazarItemDialog(BazarItem item) {
    // Similar to the edit dialog in bazar_screen.dart
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildTotalSpentCard(),
            const SizedBox(height: 20),
            _buildCategoryBreakdown(),
            const SizedBox(height: 20),
            Expanded(child: _buildDailyBreakdown()),
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

  Widget _buildTotalSpentCard() {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final bazarProvider = Provider.of<BazarProvider>(context, listen: false);

    final List<Expense> allExpenses = [
      ...transactionProvider.transactions.where(
        (t) => t.type == TransactionType.expense,
      ),
      ...bazarProvider.items,
    ];

    final monthlyExpenses = allExpenses.where(
      (expense) =>
          expense.date.month == _selectedMonth.month &&
          expense.date.year == _selectedMonth.year,
    );

    final totalSpent = monthlyExpenses.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Total Spent This Month',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Tk ${totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final bazarProvider = Provider.of<BazarProvider>(context, listen: false);

    final List<Expense> allExpenses = [
      ...transactionProvider.transactions.where(
        (t) => t.type == TransactionType.expense,
      ),
      ...bazarProvider.items,
    ];

    final monthlyExpenses = allExpenses.where(
      (expense) =>
          expense.date.month == _selectedMonth.month &&
          expense.date.year == _selectedMonth.year,
    );

    final expensesByCategory = groupBy(
      monthlyExpenses,
      (Expense expense) => expense.category,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense by Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...expensesByCategory.entries.map((entry) {
              final category = entry.key;
              final expenses = entry.value;
              final categoryTotal = expenses.fold(
                0.0,
                (sum, item) => sum + item.amount,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category ?? 'Uncategorized'),
                    Text('Tk ${categoryTotal.toStringAsFixed(2)}'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBreakdown() {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final bazarProvider = Provider.of<BazarProvider>(context, listen: false);

    final List<Expense> allExpenses = [
      ...transactionProvider.transactions.where(
        (t) => t.type == TransactionType.expense,
      ),
      ...bazarProvider.items,
    ];

    final monthlyItems = allExpenses
        .where(
          (item) =>
              item.date.month == _selectedMonth.month &&
              item.date.year == _selectedMonth.year,
        )
        .toList();

    if (monthlyItems.isEmpty) {
      return const Center(child: Text('No expenses recorded for this month.'));
    }

    monthlyItems.sort((a, b) => b.date.compareTo(a.date));

    final groupedItems = groupBy(
      monthlyItems,
      (Expense item) => DateFormat('yyyy-MM-dd').format(item.date),
    );

    return ListView.builder(
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final dateString = groupedItems.keys.elementAt(index);
        final dailyItems = groupedItems[dateString]!;

        final dailyTotal = dailyItems.fold(
          0.0,
          (sum, item) => sum + item.amount,
        );
        final formattedDate = DateFormat.yMMMMd().format(
          DateTime.parse(dateString),
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Total: Tk ${dailyTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: dailyItems.map((item) {
              return ListTile(
                title: Text(_getExpenseTitle(item)),
                subtitle: Text(DateFormat.yMMMd().add_jm().format(item.date)),
                trailing: Text('Tk ${item.amount.toStringAsFixed(2)}'),
                onTap: () => _showEditDeleteDialog(item),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
