import 'package:flutter/foundation.dart';
import 'package:myapp/models/loan.dart';

class LoanProvider with ChangeNotifier {
  final List<Loan> _loans = [
    Loan(
      id: '1',
      personName: 'Nur Alam',
      amount: 5000,
      lastActivityDate: DateTime(2025, 2, 10),
      type: LoanType.due,
    ),
    Loan(
      id: '2',
      personName: 'Deep',
      amount: 10000,
      lastActivityDate: DateTime(2025, 2, 10),
      type: LoanType.balance,
    ),
  ];

  List<Loan> get loans => [..._loans];

  void addLoan(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }
}
