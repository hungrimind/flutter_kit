import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
// Import NavigationState, AppRoute, navigationStateNotifier

// --- Example Screens ---

class HomeScreen extends StatelessWidget {
  final RouterService routerService;
  const HomeScreen({super.key, required this.routerService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Update state to navigate
                routerService.navigateTo(AppRoute.books);
              },
              child: const Text('Go to Books'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Update state to navigate
                routerService.navigateTo(AppRoute.settings);
              },
              child: const Text('Go to Settings'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              // Example of navigating to a non-existent route
              onPressed: () {
                routerService.navigateTo(AppRoute.unknown);
              },
              child: const Text('Go to Unknown Page (Simulate 404)'),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksScreen extends StatelessWidget {
  final RouterService routerService;
  const BooksScreen({super.key, required this.routerService});

  @override
  Widget build(BuildContext context) {
    // Example book IDs
    final bookIds = ['1', 'the-hobbit', '42'];
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: ListView.builder(
        itemCount: bookIds.length,
        itemBuilder: (context, index) {
          final bookId = bookIds[index];
          return ListTile(
            title: Text('Book $bookId'),
            onTap: () {
              // Update state to navigate to details
              routerService.navigateTo(
                AppRoute.bookDetails,
                selectedBookId: bookId,
              );
            },
          );
        },
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final String bookId;
  const BookDetailsScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Details: $bookId')),
      body: Center(child: Text('Showing details for book ID: $bookId')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('App Settings')),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Text('404 - The requested page could not be found.'),
      ),
    );
  }
}
