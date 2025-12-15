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
      Provider.of<AccountProvider>(context, listen: false).addAccount(newAccount);
      _accountNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<AccountProvider>(context).accounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Accounts'),
      ),
      body: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Manage Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.account_balance_wallet, color: Colors.orange),
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
                  child: Text('Your Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return ListTile(
                      leading: const Icon(Icons.account_balance, color: Colors.blue),
                      title: Text(account.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                        onPressed: () {
                          // TODO: Implement edit functionality
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
