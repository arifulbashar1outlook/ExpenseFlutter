import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'Paisa Manager',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Input'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () => context.go('/history'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Bazar'),
            onTap: () => context.go('/bazar'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Bazar Report'),
            onTap: () => context.go('/bazar-report'),
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            title: const Text('Monthly Report'),
            onTap: () => context.go('/full-monthly-report'),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Lending Manager'),
            onTap: () => context.go('/lending-manager'),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Manage Accounts'),
            onTap: () => context.go('/manage-accounts'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}
