import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/account/account.dart';
import 'package:myapp/providers/transaction/transaction.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'custom_tab_button.dart';
import 'input_field.dart';

class AddSalaryCard extends StatefulWidget {
  const AddSalaryCard({super.key});

  @override
  State<AddSalaryCard> createState() => _AddSalaryCardState();
}

class _AddSalaryCardState extends State<AddSalaryCard> {
  bool isSalary = true;
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedAccountId = '1';
  DateTime _selectedDate = DateTime.now();

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

  void _addIncome() async {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final newTransaction = Transaction(
      id: const Uuid().v4(),
      title: isSalary ? 'Salary' : _descriptionController.text,
      amount: amount,
      date: _selectedDate,
      type: TransactionType.income,
      accountId: _selectedAccountId,
    );

    await transactionProvider.addTransaction(newTransaction);
    await accountProvider.updateBalance(_selectedAccountId, amount, true);

    _descriptionController.clear();
    _amountController.clear();

    if (mounted) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Income added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTabButton(
                    text: 'Salary',
                    icon: Icons.business_center,
                    isSelected: isSalary,
                    onTap: () => setState(() => isSalary = true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTabButton(
                    text: 'Receive',
                    icon: Icons.add_circle,
                    isSelected: !isSalary,
                    onTap: () => setState(() => isSalary = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: InputField(
                      label: 'Date',
                      hint: DateFormat.yMd().format(_selectedDate),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InputField(
                    label: 'Amount',
                    hint: 'Tk 0.00',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!isSalary)
              InputField(
                label: 'Description',
                hint: 'e.g. Gift, Bonus',
                controller: _descriptionController,
              ),
            const SizedBox(height: 10),
            InputField(
              label: 'Deposit To',
              hint: 'Cash',
              isDropdown: true,
              items: Provider.of<AccountProvider>(context).accounts,
              onAccountSelected: (id) => _selectedAccountId = id!,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addIncome,
              icon: const Icon(Icons.downloading),
              label: const Text('Receive Money'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA5D6A7),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
