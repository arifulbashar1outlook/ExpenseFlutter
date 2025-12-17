import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/transactions_provider.dart';
import '../data/transaction_model.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _titleController.text;
      final enteredAmount = double.parse(_amountController.text);

      Provider.of<TransactionsProvider>(context, listen: false).addTransaction(
        Transaction(
          id: DateTime.now().toString(),
          title: enteredTitle,
          amount: enteredAmount,
          date: _selectedDate,
          type: _selectedType,
          accountId: '1', // Placeholder
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount.';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number.';
              }
              return null;
            },
          ),
          DropdownButton<TransactionType>(
            value: _selectedType,
            onChanged: (newValue) {
              setState(() {
                _selectedType = newValue!;
              });
            },
            items: TransactionType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            }).toList(),
          ),
          ElevatedButton(onPressed: _submitData, child: const Text('Add Transaction')),
        ],
      ),
    );
  }
}
