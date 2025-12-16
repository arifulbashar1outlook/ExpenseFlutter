import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/transaction.dart' as model;
import 'package:myapp/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ExpenseInputForm extends StatefulWidget {
  const ExpenseInputForm({super.key});

  @override
  State<ExpenseInputForm> createState() => _ExpenseInputFormState();
}

class _ExpenseInputFormState extends State<ExpenseInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food and Dining';
  String? _selectedAccountId;

  final List<String> _categories = [
    'Food and Dining',
    'Transportation',
    'Housing',
    'Shopping',
    'Health',
    'Send Home',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final accounts = Provider.of<AccountProvider>(
      context,
      listen: false,
    ).accounts;
    if (accounts.isNotEmpty) {
      _selectedAccountId = accounts.first.id;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account.')),
        );
        return;
      }
      final amount = double.parse(_amountController.text);

      final newExpense = model.Transaction(
        id: const Uuid().v4(),
        title: _selectedCategory,
        type: model.TransactionType.expense,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        accountId: _selectedAccountId!,
      );

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(newExpense);

      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _selectedCategory = 'Food and Dining';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<AccountProvider>(context).accounts;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedAccountId,
            hint: const Text('Select Account'),
            isExpanded: true,
            items: accounts.map((account) {
              return DropdownMenuItem(
                value: account.id,
                child: Text(account.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAccountId = value;
              });
            },
            validator: (value) =>
                value == null ? 'Please select an account' : null,
            decoration: const InputDecoration(labelText: 'Paid From'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select Date'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitExpense,
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}
