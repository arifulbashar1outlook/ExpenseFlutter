import 'package:flutter/material.dart';
import 'package:myapp/features/transaction/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseReportScreen extends StatelessWidget {
  const ExpenseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final expenseData = transactionProvider.getCategoryDistribution();

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: expenseData.entries.map((entry) {
                    return PieChartSectionData(
                      color: _getColor(entry.key),
                      value: entry.value,
                      title: '${entry.key}\n${entry.value.toStringAsFixed(2)}%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: expenseData.length,
                itemBuilder: (context, index) {
                  final category = expenseData.keys.elementAt(index);
                  final percentage = expenseData[category]!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColor(category),
                      radius: 10,
                    ),
                    title: Text(category),
                    trailing: Text('${percentage.toStringAsFixed(2)}%'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String category) {
    switch (category) {
      case 'Food and Dining':
        return Colors.red;
      case 'Transportation':
        return Colors.blue;
      case 'Housing':
        return Colors.green;
      case 'Shopping':
        return Colors.orange;
      case 'Health':
        return Colors.purple;
      case 'Send Home':
        return Colors.brown;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
