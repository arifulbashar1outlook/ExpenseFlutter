import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class YearlyOverviewScreen extends StatelessWidget {
  const YearlyOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<AccountProvider>(context).accounts;
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    final double totalIn = transactions.where((t) => t.type == TransactionType.income).fold(0, (sum, t) => sum + t.amount);
    final double totalOut = transactions.where((t) => t.type == TransactionType.expense).fold(0, (sum, t) => sum + t.amount);
    final double netFlow = totalIn - totalOut;
    final double savingsRate = totalIn > 0 ? (netFlow / totalIn) * 100 : 0;

    // Data for the pie chart
    final expenseByCategory = <String, double>{};
    for (var t in transactions.where((t) => t.type == TransactionType.expense)) {
      expenseByCategory.update(t.category, (value) => value + t.amount, ifAbsent: () => t.amount);
    }

    final pieChartSections = expenseByCategory.entries.map((entry) {
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: '', // No title to avoid clutter
        radius: 20,
      );
    }).toList();

    // Data for the bar chart
    final monthlyActivity = <int, Map<String, double>>{};
    for (var t in transactions) {
      final month = t.date.month;
      monthlyActivity.putIfAbsent(month, () => {'income': 0, 'expense': 0});
      if (t.type == TransactionType.income) {
        monthlyActivity[month]!['income'] = monthlyActivity[month]!['income']! + t.amount;
      } else {
        monthlyActivity[month]!['expense'] = monthlyActivity[month]!['expense']! + t.amount;
      }
    }

    final barChartGroups = monthlyActivity.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(toY: entry.value['income']!, color: Colors.green, width: 16),
          BarChartRodData(toY: entry.value['expense']!, color: Colors.red, width: 16),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yearly Overview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('2025', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return AccountCard(name: account.name, balance: account.balance);
              },
            ),
            const SizedBox(height: 20),
            const Text('THIS YEAR FLOW', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
              children: [
                SummaryCard(title: 'Net Flow', amount: netFlow, color: Colors.blue, icon: Icons.show_chart),
                SummaryCard(title: 'Total In', amount: totalIn, color: Colors.green, icon: Icons.arrow_upward),
                SummaryCard(title: 'Total Out', amount: totalOut, color: Colors.red, icon: Icons.arrow_downward),
                SummaryCard(title: 'Savings Rate', amount: savingsRate, color: Colors.orange, icon: Icons.savings, isPercentage: true),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Expense Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieChartSections,
                  centerSpaceRadius: 60,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: expenseByCategory.keys.map((category) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, color: _getCategoryColor(category)),
                    const SizedBox(width: 4),
                    Text(category),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Monthly Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barChartGroups,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                   titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontSize: 10);
                          String text;
                          switch (value.toInt()) {
                            case 1: text = 'Jan'; break;
                            case 2: text = 'Feb'; break;
                            case 3: text = 'Mar'; break;
                            case 4: text = 'Apr'; break;
                            case 5: text = 'May'; break;
                            case 6: text = 'Jun'; break;
                            case 7: text = 'Jul'; break;
                            case 8: text = 'Aug'; break;
                            case 9: text = 'Sep'; break;
                            case 10: text = 'Oct'; break;
                            case 11: text = 'Nov'; break;
                            case 12: text = 'Dec'; break;
                            default: text = ''; break;
                          }
                          return Text(text, style: style);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white),
                      SizedBox(width: 8),
                      Text('AI Financial Advisor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Get personalized insights about your spending habits and savings opportunities powered by Gemini AI.', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Generate Insights'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Lending & Debt':
        return Colors.blue;
      case 'Other':
        return Colors.pink;
      case 'Utilities':
        return Colors.purple;
      case 'Bazar & Groceries':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class AccountCard extends StatelessWidget {
  final String name;
  final double balance;

  const AccountCard({super.key, required this.name, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Tk ${balance.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final bool isPercentage;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isPercentage ? '${amount.toStringAsFixed(2)}%' : 'Tk ${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
