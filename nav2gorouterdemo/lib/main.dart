import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';

void main() {
  // Configure url strategy for web
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Demo',
      routerConfig: AppRouter().router,
    );
  }
}

class AppRouter {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Page1(),
      ),
      GoRoute(
        path: '/page2',
        name: 'page2',
        builder: (context, state) => const Page2(),
      ),
      GoRoute(
        path: '/page3',
        name: 'page3',
        builder: (context, state) => const Page3(),
      ),
      // Nested routes example
      GoRoute(
        path: '/page2/details',
        name: 'page2Details',
        builder: (context, state) => const Page2Details(),
      ),
      // Path parameters example
      GoRoute(
        path: '/page3/:id',
        name: 'page3WithId',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return Page3WithId(id: id);
        },
      ),
    ],
    // Error handling
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}

// This is a simple implementation using go_router package
// For a more complex implementation with custom RouterDelegate, see the commented code below
