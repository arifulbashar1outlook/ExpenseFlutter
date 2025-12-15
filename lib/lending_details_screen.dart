import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/loan_transaction.dart';
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

  void _addTransaction() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      return;
    }

    final newTransaction = LoanTransaction(
      id: const Uuid().v4(),
      loanId: widget.loan.id,
      description: _isGiveLendSelected ? 'Lent Money' : 'Received Money',
      amount: amount,
      date: DateTime.now(),
      type: _isGiveLendSelected ? LoanTransactionType.lent : LoanTransactionType.received,
    );

    Provider.of<LoanTransactionProvider>(context, listen: false).addTransaction(newTransaction);
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final loanTransactions = Provider.of<LoanTransactionProvider>(context).getTransactionsForLoan(widget.loan.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Back to List', style: TextStyle(color: Colors.black, fontSize: 16)),
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
                    Text(widget.loan.personName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Account Directory', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Net Outstanding:', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'Tk ${widget.loan.amount.toStringAsFixed(2)} (${widget.loan.type == LoanType.due ? 'Due' : 'Balance'})',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.loan.type == LoanType.due ? Colors.red : Colors.green,
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
                            onTap: () => setState(() => _isGiveLendSelected = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isGiveLendSelected ? Colors.red.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_upward, color: _isGiveLendSelected ? Colors.red : Colors.grey, size: 18),
                                  const SizedBox(width: 8),
                                  Text('Give / Lend', style: TextStyle(color: _isGiveLendSelected ? Colors.red : Colors.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isGiveLendSelected = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isGiveLendSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_downward, color: !_isGiveLendSelected ? Colors.green : Colors.grey, size: 18),
                                  const SizedBox(width: 8),
                                  Text('Receive Back', style: TextStyle(color: !_isGiveLendSelected ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
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
                        Expanded(child: _buildTextField(hintText: '12/15/2025', icon: Icons.calendar_today)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField(hintText: 'Cash', icon: Icons.account_balance_wallet)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(hintText: 'Tk 0.00', controller: _amountController, keyboardType: TextInputType.number)),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _addTransaction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            const Align(alignment: Alignment.centerLeft, child: Text('HISTORY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: loanTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = loanTransactions[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(transaction.type == LoanTransactionType.lent ? Icons.arrow_forward : Icons.arrow_back, color: transaction.type == LoanTransactionType.lent ? Colors.red : Colors.green),
                      title: Text(transaction.description),
                      subtitle: Text(DateFormat.yMd().format(transaction.date)),
                      trailing: Text(
                        'Tk ${transaction.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, IconData? icon, TextEditingController? controller, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey) : null,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
