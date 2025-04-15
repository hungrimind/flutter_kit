import 'package:flutter/material.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
import 'package:nav2demo/pages/screens.dart';

class RouteNames {
  static const String home = 'home';
  static const String books = 'books';
  static const String bookDetails = 'bookDetails';
  static const String settings = 'settings';
  static const String unknown = 'unknown';
}

final List<AppRoute> routeMap = [
  AppRoute(name: RouteNames.home, path: '/'),
  AppRoute(name: RouteNames.books, path: '/books'),
  AppRoute(name: RouteNames.bookDetails, path: '/books/:id'),
  AppRoute(name: RouteNames.settings, path: '/settings'),
  AppRoute(name: RouteNames.unknown, path: '/unknown'),
];

// Function to map route configuration to a widget
Widget getWidgetForRoute(AppRoute page) {
  switch (page.name) {
    case RouteNames.home:
      return HomeScreen();
    case RouteNames.books:
      return BooksScreen();
    case RouteNames.settings:
      return SettingsScreen();
    case RouteNames.bookDetails:
      final bookId = page.params?['id'];
      if (bookId == null) {
        // Handle the case where bookId is missing - perhaps show an error or default screen
        print('Error: Missing bookId for bookDetails route');
        return UnknownScreen(); // Or a specific error screen
      }
      return BookDetailsScreen(
        bookId: bookId, // Now guaranteed to be non-null
      );
    case RouteNames.unknown:
    default:
      return UnknownScreen();
  }
}
