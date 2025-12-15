import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/bazar_report_screen.dart';
import 'package:myapp/bazar_screen.dart';
import 'package:myapp/dark_mode_screen.dart';
import 'package:myapp/expense_report_screen.dart';
import 'package:myapp/full_monthly_report_screen.dart';
import 'package:myapp/history_screen.dart';
import 'package:myapp/lending_details_screen.dart';
import 'package:myapp/lending_manager_screen.dart';
import 'package:myapp/manage_accounts_screen.dart';
import 'package:myapp/models/account.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/monthly_overview_screen.dart';
import 'package:myapp/providers/account_provider.dart';
import 'package:myapp/providers/bazar_provider.dart';
import 'package:myapp/providers/loan_provider.dart';
import 'package:myapp/providers/loan_transaction_provider.dart';
import 'package:myapp/providers/transaction_provider.dart';
import 'package:myapp/settings_screen.dart';
import 'package:myapp/widgets/custom_drawer.dart';
import 'package:myapp/yearly_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProxyProvider<AccountProvider, BazarProvider>(
          create: (context) => BazarProvider(
            Provider.of<AccountProvider>(context, listen: false),
          ),
          update: (context, accountProvider, bazarProvider) => bazarProvider!,
        ),
        ChangeNotifierProvider(create: (context) => LoanProvider()),
        ChangeNotifierProxyProvider<
          TransactionProvider,
          LoanTransactionProvider
        >(
          create: (context) => LoanTransactionProvider(
            Provider.of<TransactionProvider>(context, listen: false),
          ),
          update: (context, transactionProvider, loanTransactionProvider) =>
              loanTransactionProvider!..update(transactionProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default to light mode

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loans = Provider.of<LoanProvider>(context, listen: false).loans;
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/lending-details/:loanId',
          builder: (BuildContext context, GoRouterState state) {
            final loanId = state.pathParameters['loanId']!;
            final loan = loans.firstWhere((loan) => loan.id == loanId);
            return LendingDetailsScreen(loan: loan);
          },
        ),
        GoRoute(
          path: '/full-monthly-report',
          builder: (BuildContext context, GoRouterState state) {
            return const FullMonthlyReportScreen();
          },
        ),
        GoRoute(
          path: '/manage-accounts',
          builder: (BuildContext context, GoRouterState state) {
            return const ManageAccountsScreen();
          },
        ),
        GoRoute(
          path: '/dark-mode',
          builder: (BuildContext context, GoRouterState state) {
            return const DarkModeScreen();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: '/lending-manager',
          builder: (BuildContext context, GoRouterState state) {
            return const LendingManagerScreen();
          },
        ),
        GoRoute(
          path: '/monthly-overview',
          builder: (BuildContext context, GoRouterState state) {
            return const MonthlyOverviewScreen();
          },
        ),
        GoRoute(
          path: '/yearly-overview',
          builder: (BuildContext context, GoRouterState state) {
            return const YearlyOverviewScreen();
          },
        ),
        GoRoute(
          path: '/sign-out',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen(); // Replace with actual sign-out logic
          },
        ),
      ],
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'SmartSpend',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  scaffoldBackgroundColor: const Color(0xFFF3F4F6),
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF3F4F6),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  textTheme: GoogleFonts.interTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const InputScreen(),
    const BazarScreen(),
    const BazarReportScreen(),
    const ExpenseReportScreen(),
    const FullMonthlyReportScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.ac_unit), // Placeholder for logo
        ),
        title: const Text('SmartSpend'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Menu',
            ),
          ),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class InputScreen extends StatelessWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your money flow',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            AddSalaryCard(),
            const SizedBox(height: 20),
            NewTransactionCard(),
          ],
        ),
      ),
    );
  }
}

class AddSalaryCard extends StatefulWidget {
  const AddSalaryCard({super.key});

  @override
  _AddSalaryCardState createState() => _AddSalaryCardState();
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

  void _addIncome() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final newTransaction = Transaction(
      id: Uuid().v4(),
      title: isSalary ? 'Salary' : _descriptionController.text,
      amount: amount,
      date: _selectedDate,
      type: TransactionType.income,
      accountId: _selectedAccountId,
    );

    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).addTransaction(newTransaction);
    Provider.of<AccountProvider>(
      context,
      listen: false,
    ).updateBalance(_selectedAccountId, amount, true);

    _descriptionController.clear();
    _amountController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Income added successfully!')));
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

class NewTransactionCard extends StatefulWidget {
  const NewTransactionCard({super.key});

  @override
  _NewTransactionCardState createState() => _NewTransactionCardState();
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

  void _addTransaction() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || _fromAccountId == null) return;

    if (_selectedIndex == 0) {
      // Expense
      final newTransaction = Transaction(
        id: Uuid().v4(),
        title: _descriptionController.text,
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        accountId: _fromAccountId!,
        category: _selectedCategory,
      );
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(newTransaction);
      Provider.of<AccountProvider>(
        context,
        listen: false,
      ).updateBalance(_fromAccountId!, amount, false);
    } else if (_selectedIndex == 1) {
      // Transfer
      if (_toAccountId == null || _fromAccountId == _toAccountId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('From and To accounts cannot be the same.'),
          ),
        );
        return;
      }
      // Expense from 'from' account
      final expenseTransaction = Transaction(
        id: Uuid().v4(),
        title: 'Transfer to ${_getAccountName(_toAccountId!)}',
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        accountId: _fromAccountId!,
        category: 'Transfer',
      );
      // Income to 'to' account
      final incomeTransaction = Transaction(
        id: Uuid().v4(),
        title: 'Transfer from ${_getAccountName(_fromAccountId!)}',
        amount: amount,
        date: _selectedDate,
        type: TransactionType.income,
        accountId: _toAccountId!,
        category: 'Transfer',
      );
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(expenseTransaction);
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(incomeTransaction);
      Provider.of<AccountProvider>(
        context,
        listen: false,
      ).updateBalance(_fromAccountId!, amount, false);
      Provider.of<AccountProvider>(
        context,
        listen: false,
      ).updateBalance(_toAccountId!, amount, true);
    } else {
      // Withdraw
      final newTransaction = Transaction(
        id: Uuid().v4(),
        title: 'Withdrawal',
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        accountId: _fromAccountId!,
        category: 'Withdrawal',
      );
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(newTransaction);
      Provider.of<AccountProvider>(
        context,
        listen: false,
      ).updateBalance(_fromAccountId!, amount, false);
      // Assuming 'Cash' account exists and has id '1'
      Provider.of<AccountProvider>(
        context,
        listen: false,
      ).updateBalance('1', amount, true);
    }

    _descriptionController.clear();
    _amountController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction added successfully!')),
    );
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
                    unselectedColor: Colors.red.withOpacity(0.1),
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
                    onTap: () => _selectDate(context),
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
            if (_selectedIndex == 0)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InputField(
                  label: 'Category',
                  hint: 'Select Category',
                  isDropdown: true,
                  stringItems: _categories,
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

class CustomTabButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? unselectedColor;

  const CustomTabButton({
    super.key,
    required this.text,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (unselectedColor != null
                    ? unselectedColor!.withOpacity(0.3)
                    : const Color(0xFFE0E0E0))
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isDropdown;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<Account>? items;
  final List<String>? stringItems;
  final Function(String?)? onAccountSelected;
  final Function(String?)? onCategorySelected;
  final bool enabled;

  const InputField({
    super.key,
    this.label = '',
    required this.hint,
    this.isDropdown = false,
    this.leadingIcon,
    this.trailingIcon,
    this.controller,
    this.keyboardType,
    this.items,
    this.stringItems,
    this.onAccountSelected,
    this.onCategorySelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
        ],
        if (isDropdown)
          if (items != null)
            DropdownButtonFormField<String>(
              initialValue: items!.isNotEmpty ? items!.first.id : null,
              items: items!
                  .map(
                    (account) => DropdownMenuItem(
                      value: account.id,
                      child: Text(account.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null && onAccountSelected != null) {
                  onAccountSelected!(value);
                }
              },
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: leadingIcon != null
                    ? Icon(leadingIcon, color: Colors.grey)
                    : null,
                enabled: enabled,
              ),
            )
          else if (stringItems != null)
            DropdownButtonFormField<String>(
              initialValue: stringItems!.isNotEmpty ? stringItems!.first : null,
              items: stringItems!
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: onCategorySelected,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: leadingIcon != null
                    ? Icon(leadingIcon, color: Colors.grey)
                    : null,
                enabled: enabled,
              ),
            )
          else
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: leadingIcon != null
                    ? Icon(leadingIcon, color: Colors.grey)
                    : null,
                suffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            )
        else
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: leadingIcon != null
                  ? Icon(leadingIcon, color: Colors.grey)
                  : null,
              suffixIcon: trailingIcon != null
                  ? Icon(trailingIcon, color: Colors.grey)
                  : null,
            ),
          ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(6, (index) => _buildNavItem(index)),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final icons = [
      Icons.input,
      Icons.shopping_basket,
      Icons.bar_chart,
      Icons.pie_chart,
      Icons.assessment,
      Icons.history,
    ];
    final labels = [
      'Input',
      'Bazar',
      'Bazar Rpt',
      'Expense Rpt',
      'Report',
      'History',
    ];

    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepPurple.withOpacity(0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icons[index],
              color: isSelected ? Colors.deepPurple : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Text(
              labels[index],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions yet.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionListItem(transaction: transaction);
      },
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.black;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Icon(icon, color: isIncome ? Colors.green : Colors.red),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
        trailing: Text(
          '${isIncome ? '+' : '-'}Tk ${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
