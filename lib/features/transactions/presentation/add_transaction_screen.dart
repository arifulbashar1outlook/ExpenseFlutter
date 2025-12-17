import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TransactionType { salary, receive }

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> with TickerProviderStateMixin {
  TransactionType _selectedTransaction = TransactionType.salary;
  late TabController _tabController;
  DateTime? _selectedSalaryDate = DateTime.now();
  DateTime? _selectedTransactionDate = DateTime.now();
  DateTime? _selectedReceiveDate = DateTime.now();
  final _descriptionController = TextEditingController();
  final _receiveDescriptionController = TextEditingController();
  final _transferDescriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _amountController = TextEditingController();

  String _targetAccount = 'Salary Account';
  String _depositToAccount = 'Cash';
  String _fromAccount = 'Salary Account';
  String _toAccount = 'Savings Account';

  final List<String> _accounts = ['Salary Account', 'Savings Account', 'Cash'];
  final List<String> _transferAccounts = ['Salary Account', 'Savings Account'];


  @override
  void initState() {
    super.initState();
    _descriptionController.text = 'Salary';
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    _receiveDescriptionController.dispose();
    _transferDescriptionController.dispose();
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected, {DateTime? initialDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Text(
            'Manage your money flow',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salary and Receive Tabs
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedTransaction = TransactionType.salary;
                        _descriptionController.text = 'Salary';
                      });
                    },
                    icon: const Icon(Icons.card_membership),
                    label: const Text('Salary'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: _selectedTransaction == TransactionType.salary
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      backgroundColor: _selectedTransaction == TransactionType.salary
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedTransaction = TransactionType.receive;
                        _descriptionController.text = '';
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Receive'),
                     style: OutlinedButton.styleFrom(
                      foregroundColor: _selectedTransaction == TransactionType.receive
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      backgroundColor: _selectedTransaction == TransactionType.receive
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _selectedTransaction == TransactionType.salary
                ? _buildSalaryAndNewTransaction()
                : _buildReceiveMoney(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Bazar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bazar Rpt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expense Rpt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Full Rpt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildSalaryAndNewTransaction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         // Enter Monthly Salary Section
            const Text(
              'Enter Monthly Salary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, (date) => setState(() => _selectedSalaryDate = date), initialDate: _selectedSalaryDate),
                    child: InputDecorator(
                       decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_selectedSalaryDate != null ? DateFormat('MM/dd/yyyy').format(_selectedSalaryDate!) : 'Select Date'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixText: 'Tk ',
                      hintText: 'e.g. 50000',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Target Account:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _targetAccount,
                  items: _accounts.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _targetAccount = newValue!;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // New Transaction Section
           Row(
              children: const [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 8),
                Text(
                  'New Transaction',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: _tabController.index == 0 ? Colors.red : (_tabController.index == 1 ? Theme.of(context).primaryColor : Colors.orange),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Expense'),
                  Tab(text: 'Transfer'),
                  Tab(text: 'Withdraw'),
                ],
                 onTap: (index) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      prefixText: 'Tk ',
                      hintText: '0.00',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, (date) => setState(() => _selectedTransactionDate = date), initialDate: _selectedTransactionDate),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(_selectedTransactionDate != null
                          ? DateFormat('MM/dd/yyyy').format(_selectedTransactionDate!)
                          : 'Select Date'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExpenseTab(),
                  _buildTransferTab(),
                  _buildWithdrawTab(),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildExpenseTab() {
    return Column(
      children: [
         DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_balance),
            labelText: 'Paid from',
          ),
          value: _fromAccount,
          items: _accounts.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _fromAccount = newValue!;
            });
          },
        ),
        const SizedBox(height: 16),
         TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Description (e.g. Starbucks)',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.auto_awesome),
          ),
        ),
        const SizedBox(height: 16),
         DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          value: 'Food & Dining',
          items: <String>['Food & Dining', 'Groceries', 'Transport']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
        ),
        const SizedBox(height: 24),
         SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
               backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferTab() {
    return Column(
      children: [
         DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_balance),
            labelText: 'From Account',
          ),
          value: _fromAccount,
          items: _transferAccounts.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _fromAccount = newValue!;
              if (_fromAccount == _toAccount) {
                _toAccount = _transferAccounts.firstWhere((account) => account != _fromAccount);
              }
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_balance),
            labelText: 'To Account',
          ),
          value: _toAccount,
          items: _transferAccounts.where((account) => account != _fromAccount).map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _toAccount = newValue!;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _transferDescriptionController,
          decoration: const InputDecoration(
            hintText: 'Transfer Description',
            border: OutlineInputBorder(),
          ),
        ),
         const SizedBox(height: 24),
         SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
               backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Execute Transfer', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8.0),
             border: Border.all(color: Colors.orange.shade200)
          ),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cash Withdrawal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                  labelText: 'From Account',
                ),
                value: _fromAccount,
                items: _transferAccounts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _fromAccount = newValue!;
                  });
                },
              ),
               const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.swap_horiz, color: Colors.grey),
                title: Text('To Cash (Wallet)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Notes (Optional)',
            border: OutlineInputBorder(),
          ),
        ),
         const SizedBox(height: 24),
         SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
               backgroundColor: Colors.orange,
            ),
            child: const Text('Withdraw Cash', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiveMoney() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, (date) => setState(() => _selectedReceiveDate = date), initialDate: _selectedReceiveDate),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                         suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(_selectedReceiveDate != null
                          ? DateFormat('MM/dd/yyyy').format(_selectedReceiveDate!)
                          : 'Select Date'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Amount'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixText: 'Tk ',
                      hintText: '0.00',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Description (Optional)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _receiveDescriptionController,
          decoration: const InputDecoration(
            hintText: 'e.g. Gift, Bonus',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Deposit To'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_balance_wallet),
          ),
          value: _depositToAccount,
          items: _accounts.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _depositToAccount = newValue!;
            });
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Receive Money'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
