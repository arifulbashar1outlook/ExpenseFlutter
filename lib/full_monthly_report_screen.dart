import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/account_provider.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:myapp/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class FullMonthlyReportScreen extends StatelessWidget {
  const FullMonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final bazarProvider = Provider.of<BazarProvider>(context);

    final totalIncome = transactionProvider.totalIncome;
    final totalExpense = transactionProvider.totalExpense + bazarProvider.totalCost;
    final netFlow = totalIncome - totalExpense;

    final List<Expense> allExpenses = [
      ...transactionProvider.transactions.where((t) => t.type == TransactionType.expense),
      ...bazarProvider.items
    ];
    allExpenses.sort((a, b) => b.date.compareTo(a.date));

    final categorizedExpenses = <String, List<Expense>>{};
    for (var expense in allExpenses) {
      final category = expense.category;
      if (categorizedExpenses[category] == null) {
        categorizedExpenses[category] = [];
      }
      categorizedExpenses[category]!.add(expense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Monthly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSelector(),
              const SizedBox(height: 20),
              const Text('END OF MONTH STATUS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildAccountStatusGrid(accountProvider),
              const SizedBox(height: 20),
              const Text('MONTHLY FLOW', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildMonthlyFlow(totalIncome, totalExpense, netFlow),
              const SizedBox(height: 20),
              const Text('CATEGORICAL BREAKDOWN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildCategoricalBreakdown(categorizedExpenses),
            ],
          ),
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

  Widget _buildAccountStatusGrid(AccountProvider accountProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: accountProvider.accounts.length,
      itemBuilder: (context, index) {
        final account = accountProvider.accounts[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Tk ${account.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthlyFlow(double totalIncome, double totalExpense, double netFlow) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFlowItem('TOTAL INCOME', totalIncome, Colors.green),
            _buildFlowItem('TOTAL EXPENSE', totalExpense, Colors.red),
            _buildFlowItem('NET FLOW', netFlow, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: color)),
        const SizedBox(height: 5),
        Text('Tk ${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildCategoricalBreakdown(Map<String, List<Expense>> categorizedExpenses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categorizedExpenses.length,
      itemBuilder: (context, index) {
        final category = categorizedExpenses.keys.elementAt(index);
        final expenses = categorizedExpenses[category]!;
        final categoryTotal = expenses.fold(0.0, (sum, item) => sum + item.amount);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Tk ${categoryTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            children: expenses.map((expense) {
              return ListTile(
                title: Text(expense.title),
                subtitle: Text(DateFormat.yMMMd().format(expense.date)),
                trailing: Text('Tk ${expense.amount.toStringAsFixed(2)}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
