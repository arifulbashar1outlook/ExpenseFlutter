
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/firestore_example_screen.dart';
import '../../screens/home_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'firestore_example',
          builder: (BuildContext context, GoRouterState state) {
            return const FirestoreExampleScreen();
          },
        ),
      ],
    ),
  ],
);
