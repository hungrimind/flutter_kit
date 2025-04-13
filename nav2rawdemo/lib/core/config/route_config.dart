import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

class RouteNames {
  static const String home = 'home';
  static const String books = 'books';
  static const String page2 = 'page2';
  static const String bookDetails = 'bookDetails';
  static const String settings = 'settings';
  static const String unknown = 'unknown';
}

final List<AppRoute> routeMap = [
  AppRoute(
    name: RouteNames.home,
    path: '/',
    builder: (_) => const NavigationState(routeName: RouteNames.home),
  ),
  AppRoute(
    name: RouteNames.books,
    path: '/books',
    builder: (_) => const NavigationState(routeName: RouteNames.books),
  ),
  AppRoute(
    name: RouteNames.page2,
    path: '/page2',
    builder: (_) => const NavigationState(routeName: RouteNames.page2),
  ),
  AppRoute(
    name: RouteNames.bookDetails,
    path: '/books/:id',
    builder: (params) {
      final bookId = params['id'];
      if (bookId == null || bookId.isEmpty) {
        debugPrint("Error: Missing or empty book ID for /books/:id");
        return const NavigationState.unknown();
      }
      // Builder sets routeName and selectedBookId
      return NavigationState(
        routeName: RouteNames.bookDetails,
        selectedBookId: bookId,
      );
    },
  ),
  AppRoute(
    name: RouteNames.settings,
    path: '/settings',
    builder: (_) => const NavigationState(routeName: RouteNames.settings),
  ),
  AppRoute(
    name: RouteNames.unknown,
    path: '/unknown',
    builder: (_) => const NavigationState.unknown(),
  ),
];
