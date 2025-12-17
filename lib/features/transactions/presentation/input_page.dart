import 'package:flutter/material.dart';
import 'transaction_form.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TransactionForm(),
      ),
    );
  }
}
