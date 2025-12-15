import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/loan.dart';
import '../providers/loan_provider.dart';

class LendingManagerScreen extends StatelessWidget {
  const LendingManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loans = Provider.of<LoanProvider>(context).loans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lending Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.orange),
            onPressed: () {
              // TODO: Implement add loan functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Track loans and repayments', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search name...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(loan.personName[0]),
                      ),
                      title: Text(loan.personName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Last: ${DateFormat.yMd().format(loan.lastActivityDate)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'TK ${loan.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: loan.type == LoanType.due ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            loan.type == LoanType.due ? '(Due)' : '(Balance)',
                            style: TextStyle(
                              color: loan.type == LoanType.due ? Colors.red : Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        context.go('/lending-details/${loan.id}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
