import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YearlyOverviewScreen extends StatelessWidget {
  const YearlyOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Yearly Overview',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('2025', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            // More widgets will be added here
          ],
        ),
      ),
    );
  }
}
