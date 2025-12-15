import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';

class ManageAccountsScreen extends StatefulWidget {
  const ManageAccountsScreen({super.key});

  @override
  _ManageAccountsScreenState createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();

  void _addAccount() {
    if (_formKey.currentState!.validate()) {
      final newAccount = Account(
        id: const Uuid().v4(),
        name: _accountNameController.text,
      );
      Provider.of<AccountProvider>(
        context,
        listen: false,
      ).addAccount(newAccount);
      _accountNameController.clear();
    }
  }

  void _editAccount(Account account) {
    final editController = TextEditingController(text: account.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Account'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: 'New account name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteAccount(account.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.isNotEmpty) {
                Provider.of<AccountProvider>(
                  context,
                  listen: false,
                ).editAccount(account.id, editController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(String accountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AccountProvider>(
                context,
                listen: false,
              ).deleteAccount(accountId);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<AccountProvider>(context).accounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Accounts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _accountNameController,
                      decoration: const InputDecoration(
                        hintText: 'Account Name (e.g. Bkash)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an account name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addAccount,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Accounts',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.account_balance,
                      color: Colors.blue,
                    ),
                    title: Text(account.name),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () => _editAccount(account),
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
