import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/transaction.dart' as model;
import 'package:myapp/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class IncomeInputForm extends StatefulWidget {
  const IncomeInputForm({super.key});

  @override
  State<IncomeInputForm> createState() => _IncomeInputFormState();
}

class _IncomeInputFormState extends State<IncomeInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedAccountId;

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

  void _submitIncome() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account.')),
        );
        return;
      }
      final amount = double.parse(_amountController.text);
      final title = _titleController.text;

      final newIncome = model.Transaction(
        id: const Uuid().v4(),
        title: title,
        type: model.TransactionType.income,
        amount: amount,
        category: 'Income',
        date: _selectedDate,
        accountId: _selectedAccountId!,
      );

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(newIncome);

      _amountController.clear();
      _titleController.clear();
      setState(() {
        _selectedDate = DateTime.now();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income added successfully!')),
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
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
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
            decoration: const InputDecoration(labelText: 'Paid To'),
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
            onPressed: _submitIncome,
            child: const Text('Add Income'),
          ),
        ],
      ),
    );
  }
}
