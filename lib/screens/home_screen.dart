import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/transactions/presentation/transaction_list.dart';
import '../features/transactions/presentation/input_page.dart';
import '../features/accounts/presentation/accounts_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spend Smart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InputPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const AccountsModal(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.data_usage),
            onPressed: () {
              context.go('/firestore_example');
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: TransactionList()),
        ],
      ),
    );
  }
}
