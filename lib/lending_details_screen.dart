import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/account.dart';
import 'package:myapp/models/loan_transaction.dart';
import 'package:myapp/providers/account_provider.dart';
import 'package:myapp/providers/loan_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/loan.dart';
import '../providers/loan_transaction_provider.dart';

class LendingDetailsScreen extends StatefulWidget {
  final Loan loan;

  const LendingDetailsScreen({super.key, required this.loan});

  @override
  State<LendingDetailsScreen> createState() => _LendingDetailsScreenState();
}

class _LendingDetailsScreenState extends State<LendingDetailsScreen> {
  bool _isGiveLendSelected = true;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    final accounts = Provider.of<AccountProvider>(
      context,
      listen: false,
    ).accounts;
    if (accounts.isNotEmpty) {
      _selectedAccountId = accounts.first.id;
    }
  }

  void _addTransaction() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || _selectedAccountId == null) {
      return;
    }

    final newTransaction = LoanTransaction(
      id: const Uuid().v4(),
      loanId: widget.loan.id,
      description: _isGiveLendSelected
          ? 'Lent to ${widget.loan.personName}'
          : 'Received from ${widget.loan.personName}',
      amount: amount,
      date: _selectedDate,
      type: _isGiveLendSelected
          ? LoanTransactionType.lent
          : LoanTransactionType.received,
      accountId: _selectedAccountId!,
    );

    Provider.of<LoanTransactionProvider>(
      context,
      listen: false,
    ).addTransaction(newTransaction);
    Provider.of<LoanProvider>(
      context,
      listen: false,
    ).updateLoanBalance(widget.loan.id, amount, _isGiveLendSelected);
    _amountController.clear();
  }

  void _showEditDeleteDialog(LoanTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.description),
        content: const Text(
          'Would you like to edit or delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditTransactionDialog(transaction);
            },
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmationDialog(transaction);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(LoanTransaction transaction) {
    final editAmountController = TextEditingController(
      text: transaction.amount.toString(),
    );
    DateTime editSelectedDate = transaction.date;
    String? editSelectedAccountId = transaction.accountId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Transaction'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editAmountController,
                decoration: const InputDecoration(labelText: 'Amount'),
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
              InkWell(
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
              final updatedAmount = double.tryParse(editAmountController.text);

              if (updatedAmount != null &&
                  updatedAmount > 0 &&
                  editSelectedAccountId != null) {
                final updatedTransaction = LoanTransaction(
                  id: transaction.id,
                  loanId: transaction.loanId,
                  description: transaction.description,
                  amount: updatedAmount,
                  date: editSelectedDate,
                  type: transaction.type,
                  accountId: editSelectedAccountId!,
                );
                Provider.of<LoanTransactionProvider>(
                  context,
                  listen: false,
                ).editTransaction(updatedTransaction);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(LoanTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<LoanTransactionProvider>(
                context,
                listen: false,
              ).deleteTransaction(transaction.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final loanTransactions = Provider.of<LoanTransactionProvider>(
      context,
    ).getTransactionsForLoan(widget.loan.id);
    final accounts = Provider.of<AccountProvider>(context).accounts;
    final netBalance = Provider.of<LoanProvider>(
      context,
    ).getLoanNetBalance(widget.loan.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Back to List',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(child: Text(widget.loan.personName[0])),
                    const SizedBox(height: 8),
                    Text(
                      widget.loan.personName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Account Directory',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Net Balance:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tk ${netBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: netBalance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isGiveLendSelected = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isGiveLendSelected
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    color: _isGiveLendSelected
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Give / Lend',
                                    style: TextStyle(
                                      color: _isGiveLendSelected
                                          ? Colors.red
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isGiveLendSelected = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isGiveLendSelected
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    color: !_isGiveLendSelected
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Receive Back',
                                    style: TextStyle(
                                      color: !_isGiveLendSelected
                                          ? Colors.green
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            child: _buildTextField(
                              hintText: DateFormat.yMd().format(_selectedDate),
                              icon: Icons.calendar_today,
                              enabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedAccountId,
                            items: accounts
                                .map(
                                  (account) => DropdownMenuItem(
                                    value: account.id,
                                    child: Text(account.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedAccountId = value),
                            decoration: _buildInputDecoration(
                              hintText: 'Cash',
                              icon: Icons.account_balance_wallet,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            hintText: 'Tk 0.00',
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _addTransaction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isGiveLendSelected
                                ? Colors.red
                                : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'HISTORY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: loanTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = loanTransactions[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        transaction.type == LoanTransactionType.lent
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction.type == LoanTransactionType.lent
                            ? Colors.red
                            : Colors.green,
                      ),
                      title: Text(transaction.description),
                      subtitle: Text(DateFormat.yMd().format(transaction.date)),
                      trailing: Text(
                        'Tk ${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction.type == LoanTransactionType.lent
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      onTap: () => _showEditDeleteDialog(transaction),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    IconData? icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: _buildInputDecoration(hintText: hintText, icon: icon),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon != null
          ? Icon(icon, size: 18, color: Colors.grey)
          : null,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }
}
