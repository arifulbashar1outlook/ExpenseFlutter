import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class BazarScreen extends StatefulWidget {
  const BazarScreen({super.key});

  @override
  State<BazarScreen> createState() => _BazarScreenState();
}

class _BazarScreenState extends State<BazarScreen> {
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    final accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );
    if (accountProvider.accounts.isNotEmpty) {
      _selectedAccountId = accountProvider.accounts.first.id;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addItem() {
    final itemName = _itemNameController.text;
    final itemPrice = double.tryParse(_itemPriceController.text);

    if (itemName.isEmpty ||
        itemPrice == null ||
        itemPrice <= 0 ||
        _selectedAccountId == null) {
      return;
    }

    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newItem = BazarItem(
      id: const Uuid().v4(),
      name: itemName,
      cost: itemPrice,
      date: combinedDateTime,
      category: 'Bazar',
      accountId: _selectedAccountId!,
    );

    Provider.of<BazarProvider>(
      context,
      listen: false,
    ).addItem(newItem, _selectedAccountId!);

    _itemNameController.clear();
    _itemPriceController.clear();
  }

  void _showEditDeleteDialog(BazarItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: const Text('Would you like to edit or delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditItemDialog(item);
            },
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmationDialog(item);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BazarItem item) {
    final editNameController = TextEditingController(text: item.name);
    final editPriceController = TextEditingController(
      text: item.cost.toString(),
    );
    DateTime editSelectedDate = item.date;
    TimeOfDay editSelectedTime = TimeOfDay.fromDateTime(item.date);
    String? editSelectedAccountId = item.accountId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Bazar Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: editPriceController,
                decoration: const InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                initialValue: editSelectedAccountId,
                decoration: const InputDecoration(labelText: 'Account'),
                items: Provider.of<AccountProvider>(context, listen: false)
                    .accounts
                    .map((account) {
                      return DropdownMenuItem(
                        value: account.id,
                        child: Text(account.name),
                      );
                    })
                    .toList(),
                onChanged: (newValue) {
                  editSelectedAccountId = newValue;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: editSelectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          editSelectedDate = picked;
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date'),
                        child: Text(DateFormat.yMd().format(editSelectedDate)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: editSelectedTime,
                        );
                        if (picked != null) {
                          editSelectedTime = picked;
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Time'),
                        child: Text(editSelectedTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedName = editNameController.text;
              final updatedPrice = double.tryParse(editPriceController.text);

              if (updatedName.isNotEmpty &&
                  updatedPrice != null &&
                  updatedPrice > 0 &&
                  editSelectedAccountId != null) {
                final combinedDateTime = DateTime(
                  editSelectedDate.year,
                  editSelectedDate.month,
                  editSelectedDate.day,
                  editSelectedTime.hour,
                  editSelectedTime.minute,
                );
                final updatedItem = BazarItem(
                  id: item.id,
                  name: updatedName,
                  cost: updatedPrice,
                  date: combinedDateTime,
                  category: item.category,
                  accountId: editSelectedAccountId!,
                );
                Provider.of<BazarProvider>(
                  context,
                  listen: false,
                ).editItem(updatedItem);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BazarItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<BazarProvider>(
                context,
                listen: false,
              ).deleteItem(item);
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
    final accountProvider = Provider.of<AccountProvider>(context);
    if (_selectedAccountId == null && accountProvider.accounts.isNotEmpty) {
      _selectedAccountId = accountProvider.accounts.first.id;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAddItemCard(accountProvider),
              const SizedBox(height: 20),
              _buildBazarList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddItemCard(AccountProvider accountProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Bazar Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _itemPriceController,
              decoration: const InputDecoration(labelText: 'Item Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            if (accountProvider.accounts.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: _selectedAccountId,
                decoration: const InputDecoration(labelText: 'Account'),
                items: accountProvider.accounts.map((account) {
                  return DropdownMenuItem(
                    value: account.id,
                    child: Text(account.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAccountId = newValue;
                  });
                },
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(DateFormat.yMd().format(_selectedDate)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBazarList() {
    final bazarProvider = Provider.of<BazarProvider>(context);
    final now = DateTime.now();
    final items = bazarProvider.items
        .where(
          (item) => item.date.month == now.month && item.date.year == now.year,
        )
        .toList();

    if (items.isEmpty) {
      return const Center(child: Text('No bazar items for this month.'));
    }

    final groupedItems = groupBy(
      items,
      (BazarItem item) => DateFormat.yMd().format(item.date),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final date = groupedItems.keys.elementAt(index);
        final dailyItems = groupedItems[date]!;
        final dailyTotal = dailyItems.fold(0.0, (sum, item) => sum + item.cost);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ...dailyItems.map(
                  (item) => ListTile(
                    title: Text(item.name),
                    trailing: Text('Tk ${item.cost.toStringAsFixed(2)}'),
                    subtitle: Text(DateFormat.jm().format(item.date)),
                    onTap: () => _showEditDeleteDialog(item),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Daily Total: Tk ${dailyTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
