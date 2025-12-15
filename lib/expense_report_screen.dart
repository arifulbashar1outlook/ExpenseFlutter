import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:myapp/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class ExpenseReportScreen extends StatelessWidget {
  const ExpenseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final bazarProvider = Provider.of<BazarProvider>(context);

    // Combine expenses and bazar items
    final List<Expense> allExpenses = [
      ...transactionProvider.transactions.where((t) => t.type == TransactionType.expense),
      ...bazarProvider.items,
    ];

    allExpenses.sort((a, b) => b.date.compareTo(a.date));

    // Group items by date
    final groupedItems = <DateTime, List<Expense>>{};
    for (var item in allExpenses) {
      final date = DateTime(item.date.year, item.date.month, item.date.day);
      if (groupedItems[date] == null) {
        groupedItems[date] = [];
      }
      groupedItems[date]!.add(item);
    }

    final totalExpenses = allExpenses.fold(0.0, (sum, item) => sum + item.amount);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildExpenseReportHeader(),
            const SizedBox(height: 20),
            _buildTotalExpensesCard(totalExpenses),
            const SizedBox(height: 20),
            const Text('Daily Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDailyBreakdown(groupedItems),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), onPressed: () {}),
        Text(DateFormat('MMMM yyyy').format(DateTime.now()), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () {}),
      ],
    );
  }

  Widget _buildExpenseReportHeader() {
    return Row(children: [
      Icon(Icons.pie_chart, color: Colors.deepPurple[300]),
      const SizedBox(width: 10),
      const Text('Expense Report', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildTotalExpensesCard(double totalExpenses) {
    return Card(
      color: Colors.deepPurple.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Text('TOTAL EXPENSES', style: TextStyle(color: Colors.deepPurple[800], fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Tk ${totalExpenses.toStringAsFixed(2)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple[800])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyBreakdown(Map<DateTime, List<Expense>> groupedItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final date = groupedItems.keys.elementAt(index);
        final items = groupedItems[date]!;
        final dailyTotal = items.fold(0.0, (sum, item) => sum + item.amount);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateCard(date),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat.EEEE().format(date), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Tk ${dailyTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple[800])),
                      ],
                    ),
                    Text('${items.length} items', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    ...items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      final title = item.title;
                      final amount = item.amount;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text('${idx + 1}.'),
                            const SizedBox(width: 8),
                            Expanded(child: Text(title)),
                            Text('Tk ${amount.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateCard(DateTime date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(DateFormat.d().format(date), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(DateFormat.E().format(date).toUpperCase(), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
