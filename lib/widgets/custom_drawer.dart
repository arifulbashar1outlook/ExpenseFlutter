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
          _buildDrawerHeader(),
          _buildDrawerItem(
            context,
            icon: Icons.manage_accounts,
            text: 'Manage Accounts',
            route: '/manage-accounts',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dark_mode,
            text: 'Dark Mode',
            route: '/dark-mode',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: 'Settings',
            route: '/settings',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.real_estate_agent,
            text: 'Lending Manager',
            route: '/lending-manager',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_today,
            text: 'Monthly Overview',
            route: '/monthly-overview',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_view_day,
            text: 'Yearly Overview',
            route: '/yearly-overview',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Sign Out',
            route: '/sign-out',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      accountName: Text('Ariful Bashar (Arif)'),
      accountEmail: Text('arifulbashar1@gmail.com'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://avatars.githubusercontent.com/u/1342004?v=4',
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        context.go(route);
      },
    );
  }
}
