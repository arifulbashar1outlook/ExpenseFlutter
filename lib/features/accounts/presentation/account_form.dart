import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../logic/accounts_provider.dart';
import '../data/account_model.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final enteredName = _nameController.text;
      final enteredBalance = double.parse(_balanceController.text);

      Provider.of<AccountsProvider>(context, listen: false).addAccount(
        Account(
          id: const Uuid().v4(),
          name: enteredName,
          balance: enteredBalance,
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
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Account Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _balanceController,
            decoration: const InputDecoration(labelText: 'Balance'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a balance.';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number.';
              }
              return null;
            },
          ),
          ElevatedButton(onPressed: _submitData, child: const Text('Add Account')),
        ],
      ),
    );
  }
}
