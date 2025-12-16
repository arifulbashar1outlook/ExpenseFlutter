import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BazarInputForm extends StatefulWidget {
  const BazarInputForm({super.key});

  @override
  State<BazarInputForm> createState() => _BazarInputFormState();
}

class _BazarInputFormState extends State<BazarInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
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

  void _submitBazar() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account.')),
        );
        return;
      }
      final name = _nameController.text;
      final cost = double.parse(_costController.text);

      final newBazarItem = BazarItem(
        id: const Uuid().v4(),
        name: name,
        cost: cost,
        date: _selectedDate,
        accountId: _selectedAccountId!,
        category: 'Bazar',
      );

      Provider.of<BazarProvider>(
        context,
        listen: false,
      ).addItem(newBazarItem, _selectedAccountId!);

      _nameController.clear();
      _costController.clear();
      setState(() {
        _selectedDate = DateTime.now();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bazar item added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<AccountProvider>(context).accounts;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _costController,
            decoration: const InputDecoration(labelText: 'Cost'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a cost';
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitBazar,
            child: const Text('Add Bazar Item'),
          ),
        ],
      ),
    );
  }
}
