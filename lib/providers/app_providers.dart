import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/features/bazar/providers/bazar_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AccountProvider()),
    ChangeNotifierProxyProvider<AccountProvider, TransactionProvider>(
      create: (_) => TransactionProvider(),
      update: (_, accountProvider, previous) =>
          previous!..updateAccountProvider(accountProvider),
    ),
    ChangeNotifierProxyProvider<AccountProvider, BazarProvider>(
      create: (_) => BazarProvider(),
      update: (_, accountProvider, previous) =>
          previous!..updateAccountProvider(accountProvider),
    ),
  ];
}
