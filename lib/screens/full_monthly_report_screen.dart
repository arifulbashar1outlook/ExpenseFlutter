import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/models/transaction.dart';
import 'package:provider/provider.dart';

class FullMonthlyReportScreen extends StatefulWidget {
  const FullMonthlyReportScreen({super.key});

  @override
  State<FullMonthlyReportScreen> createState() =>
      _FullMonthlyReportScreenState();
}

class _FullMonthlyReportScreenState extends State<FullMonthlyReportScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final bazarProvider = Provider.of<BazarProvider>(context);

    final monthlyTransactions = transactionProvider.transactions
        .where(
          (t) =>
              t.date.month == _selectedDate.month &&
              t.date.year == _selectedDate.year,
        )
        .toList();
    final monthlyBazarItems = bazarProvider.items
        .where(
          (i) =>
              i.date.month == _selectedDate.month &&
              i.date.year == _selectedDate.year,
        )
        .toList();

    final totalIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalBazarCost = monthlyBazarItems.fold(
      0.0,
      (sum, i) => sum + i.cost,
    );
    final netBalance = totalIncome - totalExpense - totalBazarCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMM().format(_selectedDate),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSummaryCard(
              totalIncome: totalIncome,
              totalExpense: totalExpense,
              totalBazarCost: totalBazarCost,
              netBalance: netBalance,
            ),
            const SizedBox(height: 20),
            _buildAccountBalances(accountProvider, transactionProvider),
            const SizedBox(height: 20),
            _buildTransactionList(monthlyTransactions, 'Income', Colors.green),
            const SizedBox(height: 20),
            _buildTransactionList(monthlyTransactions, 'Expense', Colors.red),
            const SizedBox(height: 20),
            _buildBazarList(monthlyBazarItems),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required double totalIncome,
    required double totalExpense,
    required double totalBazarCost,
    required double netBalance,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('Total Income', totalIncome, Colors.green),
            _buildSummaryRow('Total Expense', totalExpense, Colors.red),
            _buildSummaryRow('Total Bazar Cost', totalBazarCost, Colors.orange),
            const Divider(),
            _buildSummaryRow(
              'Net Balance',
              netBalance,
              Colors.blue,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    double amount,
    Color color, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'Tk ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountBalances(
    AccountProvider accountProvider,
    TransactionProvider transactionProvider,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Balances',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...accountProvider.accounts.map((account) {
              final balance = transactionProvider.getAccountBalance(account.id);
              return _buildSummaryRow(account.name, balance, Colors.black);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(
    List<dynamic> transactions,
    String title,
    Color color,
  ) {
    final filteredTransactions = transactions
        .where((t) => t.type.toString().split('.').last == title.toLowerCase())
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Divider(),
            if (filteredTransactions.isEmpty)
              const Text('No transactions for this month.')
            else
              ...filteredTransactions.map(
                (t) => ListTile(
                  title: Text(t.category),
                  subtitle: Text(DateFormat.yMd().add_jm().format(t.date)),
                  trailing: Text('Tk ${t.amount.toStringAsFixed(2)}'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBazarList(List<dynamic> bazarItems) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bazar Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const Divider(),
            if (bazarItems.isEmpty)
              const Text('No bazar items for this month.')
            else
              ...bazarItems.map(
                (i) => ListTile(
                  title: Text(i.name),
                  subtitle: Text(DateFormat.yMd().add_jm().format(i.date)),
                  trailing: Text('Tk ${i.cost.toStringAsFixed(2)}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
