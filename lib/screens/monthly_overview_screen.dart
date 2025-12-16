import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/transaction/providers/transaction_provider.dart';
import 'package:myapp/models/transaction.dart' as model;

class MonthlyOverviewScreen extends StatefulWidget {
  const MonthlyOverviewScreen({super.key});

  @override
  State<MonthlyOverviewScreen> createState() => _MonthlyOverviewScreenState();
}

class _MonthlyOverviewScreenState extends State<MonthlyOverviewScreen> {
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

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    final monthlyTransactions = transactions
        .where(
          (t) =>
              t.date.month == _selectedMonth.month &&
              t.date.year == _selectedMonth.year,
        )
        .toList();

    final double totalIn = monthlyTransactions
        .where((t) => t.type == model.TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
    final double totalOut = monthlyTransactions
        .where((t) => t.type == model.TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
    final double netFlow = totalIn - totalOut;
    final double savingsRate = totalIn > 0 ? (netFlow / totalIn) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Monthly Overview',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildSummaryCards(totalIn, totalOut, netFlow, savingsRate),
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

  Widget _buildSummaryCards(
    double totalIn,
    double totalOut,
    double netFlow,
    double savingsRate,
  ) {
    return Column(
      children: [
        _buildSummaryCard(
          'Income',
          'Tk ${totalIn.toStringAsFixed(2)}',
          Icons.arrow_downward,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Expense',
          'Tk ${totalOut.toStringAsFixed(2)}',
          Icons.arrow_upward,
          Colors.red,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Net Flow',
          'Tk ${netFlow.toStringAsFixed(2)}',
          Icons.swap_horiz,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Savings Rate',
          '${savingsRate.toStringAsFixed(1)}%',
          Icons.pie_chart,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
