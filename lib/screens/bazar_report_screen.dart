import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/bazar/providers/bazar_provider.dart';
import 'package:provider/provider.dart';

class BazarReportScreen extends StatelessWidget {
  const BazarReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bazarProvider = Provider.of<BazarProvider>(context);
    final items = bazarProvider.items;
    final totalCost = bazarProvider.totalCost;

    return Scaffold(
      appBar: AppBar(title: const Text('Bazar Report')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Bazar Cost: ${totalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(DateFormat.yMd().add_jm().format(item.date)),
                  trailing: Text('Tk ${item.cost.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
