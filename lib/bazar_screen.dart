import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/account.dart';
import 'package:myapp/providers/account_provider.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:provider/provider.dart';

class BazarScreen extends StatefulWidget {
  const BazarScreen({super.key});

  @override
  _BazarScreenState createState() => _BazarScreenState();
}

class _BazarScreenState extends State<BazarScreen> {
  final _itemNameController = TextEditingController();
  final _costController = TextEditingController();
  String? _selectedAccountId;
  String _selectedCategory = 'Bazar & Groceries';

  final List<String> _categories = ['Bazar & Groceries', 'Utilities', 'Other'];

  @override
  void initState() {
    super.initState();
    final accounts = Provider.of<AccountProvider>(context, listen: false).accounts;
    if (accounts.isNotEmpty) {
      _selectedAccountId = accounts.first.id;
    }
  }

  void _addItem() {
    final itemName = _itemNameController.text;
    final cost = double.tryParse(_costController.text);
    if (itemName.isEmpty || cost == null || cost <= 0 || _selectedAccountId == null) return;

    Provider.of<BazarProvider>(context, listen: false).addItem(
      itemName,
      cost,
      DateTime.now(),
      _selectedAccountId!,
      _selectedCategory,
    );

    _itemNameController.clear();
    _costController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added to Bazar List!')));
  }

  @override
  Widget build(BuildContext context) {
    final bazarProvider = Provider.of<BazarProvider>(context);
    final accounts = Provider.of<AccountProvider>(context).accounts;

    // Group items by date
    final groupedItems = <DateTime, List<dynamic>>{};
    for (var item in bazarProvider.items) {
      final date = DateTime(item.date.year, item.date.month, item.date.day);
      if (groupedItems[date] == null) {
        groupedItems[date] = [];
      }
      groupedItems[date]!.add(item);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildBazarListHeader(bazarProvider.totalCost),
            const SizedBox(height: 20),
            _buildQuickAddItemCard(accounts),
            const SizedBox(height: 20),
            _buildBazarList(groupedItems),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), onPressed: () {}),
        Text(DateFormat('MMMM yyyy').format(DateTime.now()), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () {}),
      ],
    );
  }

  Widget _buildBazarListHeader(double totalCost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Bazar List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Column(children: [
          const Text('TOTAL', style: TextStyle(fontSize: 12, color: Colors.red)),
          Text('Tk ${totalCost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        ]),
      ],
    );
  }

  Widget _buildQuickAddItemCard(List<Account> accounts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Add Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _itemNameController, decoration: const InputDecoration(hintText: 'Item name (e.g. Vegetables)'))),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: TextField(controller: _costController, decoration: const InputDecoration(hintText: 'Cost'), keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
              decoration: const InputDecoration(labelText: 'Category', border: InputBorder.none),
            ),
            Row(
              children: [
                Expanded(child: Text(DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.now()))),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedAccountId,
                    items: accounts.map((account) => DropdownMenuItem(value: account.id, child: Text(account.name))).toList(),
                    onChanged: (value) => setState(() => _selectedAccountId = value),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                ElevatedButton(onPressed: _addItem, child: const Text('Add')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBazarList(Map<DateTime, List<dynamic>> groupedItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final date = groupedItems.keys.elementAt(index);
        final items = groupedItems[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(DateFormat.yMMMEd().format(date).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            ...items.map((item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.shopping_bag_outlined, color: Colors.green),
                title: Text(item.name),
                trailing: Text('Tk ${item.cost.toStringAsFixed(2)}'),
              ),
            )),
          ],
        );
      },
    );
  }
}
