import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/accounts_provider.dart';
import 'account_form.dart';

class AccountsModal extends StatelessWidget {
  const AccountsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final accountsProvider = Provider.of<AccountsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Accounts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: accountsProvider.accounts.length,
              itemBuilder: (context, index) {
                final account = accountsProvider.accounts[index];
                return ListTile(
                  title: Text(account.name),
                  trailing: Text('\$${account.balance.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const AccountForm(),
              );
            },
            child: const Text('Add Account'),
          ),
        ],
      ),
    );
  }
}
