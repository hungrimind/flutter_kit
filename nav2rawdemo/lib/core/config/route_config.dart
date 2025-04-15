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
  AppRoute(name: RouteNames.home, path: '/'),
  AppRoute(name: RouteNames.books, path: '/books'),
  AppRoute(name: RouteNames.page2, path: '/page2'),
  AppRoute(name: RouteNames.bookDetails, path: '/books/:id'),
  AppRoute(name: RouteNames.settings, path: '/settings'),
  AppRoute(name: RouteNames.unknown, path: '/unknown'),
];
