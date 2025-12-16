import 'package:flutter/material.dart';
import 'package:myapp/features/loan/providers/loan_provider.dart';
import 'package:myapp/models/loan.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LendingManagerScreen extends StatelessWidget {
  const LendingManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lending Manager')),
      body: Consumer<LoanProvider>(
        builder: (context, provider, child) {
          if (provider.loans.isEmpty) {
            return const Center(
              child: Text(
                'No lending or borrowing yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.loans.length,
            itemBuilder: (context, index) {
              final loan = provider.loans[index];
              return ListTile(
                leading: Icon(
                  loan.type == LoanType.lent
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: loan.type == LoanType.lent ? Colors.red : Colors.green,
                ),
                title: Text(loan.personName),
                subtitle: Text('Amount: ${loan.amount}'),
                trailing: loan.isSettled
                    ? const Text('Settled')
                    : ElevatedButton(
                        onPressed: () {
                          provider.settleLoan(loan.id);
                        },
                        child: const Text('Settle'),
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLoanDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddLoanDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String personName = '';
    double amount = 0;
    LoanType type = LoanType.lent;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Loan'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Person'),
                  onSaved: (value) => personName = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => amount = double.parse(value!),
                ),
                DropdownButtonFormField<LoanType>(
                  initialValue: type,
                  items: LoanType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) => type = value!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final loan = Loan(
                    id: const Uuid().v4(),
                    personName: personName,
                    amount: amount,
                    type: type,
                    date: DateTime.now(),
                  );
                  Provider.of<LoanProvider>(
                    context,
                    listen: false,
                  ).addLoan(loan);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
