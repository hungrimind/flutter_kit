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

List<Page<dynamic>> createPages() {
  List<Page<dynamic>> pages = [];
  for (var page in locator.get<RouterService>().navigationStack.value) {
    pages.add(
      MaterialPage(
        key: ValueKey('Page_${page.name}'),
        child: switch (page.name) {
          RouteNames.home => HomeScreen(),
          RouteNames.books => BooksScreen(),
          RouteNames.settings => SettingsScreen(),
          RouteNames.bookDetails => BookDetailsScreen(
            bookId: page.params?['id'],
          ),
          RouteNames.unknown => UnknownScreen(),
          Object() => throw UnimplementedError(),
          null => throw UnimplementedError(),
        },
      ),
    );
  }
  return pages;
}
