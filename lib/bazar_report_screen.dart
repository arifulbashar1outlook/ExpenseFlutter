import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/bazar_item.dart';
import 'package:myapp/providers/account_provider.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class BazarReportScreen extends StatefulWidget {
  const BazarReportScreen({super.key});

  @override
  State<BazarReportScreen> createState() => _BazarReportScreenState();
}

class _BazarReportScreenState extends State<BazarReportScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + increment,
        1,
      );
    });
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildTotalSpentCard(),
            const SizedBox(height: 20),
            Expanded(child: _buildDailyBreakdown()),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _changeMonth(-1),
        ),
        Text(
          DateFormat.yMMMM().format(_selectedMonth),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildTotalSpentCard() {
    final bazarProvider = Provider.of<BazarProvider>(context);
    final monthlyItems = bazarProvider.items.where(
      (item) =>
          item.date.month == _selectedMonth.month &&
          item.date.year == _selectedMonth.year,
    );
    final totalSpent = monthlyItems.fold(0.0, (sum, item) => sum + item.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Total Spent This Month',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Tk ${totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBreakdown() {
    final bazarProvider = Provider.of<BazarProvider>(context);
    final monthlyItems = bazarProvider.items
        .where(
          (item) =>
              item.date.month == _selectedMonth.month &&
              item.date.year == _selectedMonth.year,
        )
        .toList();

    if (monthlyItems.isEmpty) {
      return const Center(
        child: Text('No bazar expenses recorded for this month.'),
      );
    }

    monthlyItems.sort((a, b) => a.date.compareTo(b.date));

    final groupedItems = groupBy(
      monthlyItems,
      (BazarItem item) => DateFormat('yyyy-MM-dd').format(item.date),
    );

    return ListView.builder(
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final dateString = groupedItems.keys.elementAt(index);
        final dailyItems = groupedItems[dateString]!;
        dailyItems.sort((a, b) => a.date.compareTo(b.date));

        final dailyTotal = dailyItems.fold(
          0.0,
          (sum, item) => sum + item.amount,
        );
        final formattedDate = DateFormat.yMMMMd().format(
          DateTime.parse(dateString),
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: Tk ${dailyTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: dailyItems.map((item) {
              return ListTile(
                title: Text(item.name),
                subtitle: Text(DateFormat.jm().format(item.date)),
                trailing: Text('Tk ${item.amount.toStringAsFixed(2)}'),
                onTap: () => _showEditDeleteDialog(item),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
