import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'custom_tab_button.dart';
import 'input_field.dart';

class NewTransactionCard extends StatefulWidget {
  const NewTransactionCard({super.key});

  @override
  State<NewTransactionCard> createState() => _NewTransactionCardState();
}

class _NewTransactionCardState extends State<NewTransactionCard> {
  int _selectedIndex = 0; // 0: Expense, 1: Transfer, 2: Withdraw
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _fromAccountId;
  String? _toAccountId;
  String _selectedCategory = 'Other';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food and Dining',
    'Transportation',
    'Housing',
    'Shopping',
    'Health',
    'Send Home',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final accounts = Provider.of<AccountProvider>(
      context,
      listen: false,
    ).accounts;
    if (accounts.isNotEmpty) {
      _fromAccountId = accounts.first.id;
      _toAccountId = accounts.first.id;
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

  void _addTransaction() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || _fromAccountId == null) return;

    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );

    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_selectedIndex == 0) {
      // Expense
      final newTransaction = Transaction(
        id: const Uuid().v4(),
        title: _descriptionController.text,
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        accountId: _fromAccountId!,
        category: _selectedCategory,
      );
      await transactionProvider.addTransaction(newTransaction);
      await accountProvider.updateBalance(_fromAccountId!, amount, false);
    } else if (_selectedIndex == 1) {
      // Transfer
      if (_toAccountId == null || _fromAccountId == _toAccountId) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('From and To accounts cannot be the same.'),
          ),
        );
        return;
      }
      // Expense from 'from' account
      final expenseTransaction = Transaction(
        id: const Uuid().v4(),
        title: 'Transfer to ${_getAccountName(_toAccountId!)}',
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        accountId: _fromAccountId!,
        category: 'Transfer',
      );
      // Income to 'to' account
      final incomeTransaction = Transaction(
        id: const Uuid().v4(),
        title: 'Transfer from ${_getAccountName(_fromAccountId!)}',
        amount: amount,
        date: _selectedDate,
        type: TransactionType.income,
        accountId: _toAccountId!,
        category: 'Transfer',
      );
      await transactionProvider.addTransaction(expenseTransaction);
      await transactionProvider.addTransaction(incomeTransaction);
      await accountProvider.updateBalance(_fromAccountId!, amount, false);
      await accountProvider.updateBalance(_toAccountId!, amount, true);
    } else {
      // Withdraw
      final newTransaction = Transaction(
        id: const Uuid().v4(),
        title: 'Withdrawal',
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        accountId: _fromAccountId!,
        category: 'Withdrawal',
      );
      await transactionProvider.addTransaction(newTransaction);
      await accountProvider.updateBalance(_fromAccountId!, amount, false);
      // Assuming 'Cash' account exists and has id '1'
      await accountProvider.updateBalance('1', amount, true);
    }

    _descriptionController.clear();
    _amountController.clear();
    if (mounted) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Transaction added successfully!')),
      );
    }
  }

  String _getAccountName(String id) {
    final accounts = Provider.of<AccountProvider>(
      context,
      listen: false,
    ).accounts;
    return accounts.firstWhere((acc) => acc.id == id).name;
  }

  @override
  Widget build(BuildContext context) {
    final allAccounts = Provider.of<AccountProvider>(context).accounts;
    final fromAccounts = allAccounts
        .where((acc) => acc.id != _toAccountId)
        .toList();
    final toAccounts = allAccounts
        .where((acc) => acc.id != _fromAccountId)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New Transaction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomTabButton(
                    text: 'Expense',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                    unselectedColor: const Color.fromRGBO(255, 0, 0, 0.1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTabButton(
                    text: 'Transfer',
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTabButton(
                    text: 'Withdraw',
                    isSelected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    hint: 'Tk 0.00',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: InputField(
                      hint: DateFormat.yMd().format(_selectedDate),
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InputField(
              label: 'Paid from',
              hint: 'EBL',
              isDropdown: true,
              leadingIcon: Icons.account_balance,
              items: _selectedIndex == 1 ? fromAccounts : allAccounts,
              onAccountSelected: (id) {
                setState(() {
                  _fromAccountId = id;
                });
              },
            ),
            if (_selectedIndex == 1)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InputField(
                  label: 'To Account',
                  hint: 'Select Account',
                  isDropdown: true,
                  items: toAccounts,
                  onAccountSelected: (id) {
                    setState(() {
                      _toAccountId = id;
                    });
                  },
                ),
              ),
            const SizedBox(height: 10),
            if (_selectedIndex == 0)
              InputField(
                label: 'Description',
                hint: 'e.g. Starbucks',
                trailingIcon: Icons.apps,
                controller: _descriptionController,
              ),
            if (_selectedIndex.isEven)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InputField(
                  label: 'Category',
                  hint: 'Select Category',
                  isDropdown: true,
                  items: _categories,
                  onCategorySelected: (category) =>
                      setState(() => _selectedCategory = category!),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _selectedIndex == 1
                    ? 'Transfer'
                    : _selectedIndex == 2
                    ? 'Withdraw'
                    : 'Add Expense',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
