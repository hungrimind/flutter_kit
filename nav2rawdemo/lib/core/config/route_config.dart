import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/pages/screens.dart';

final List<RouteState> routes = [
  RouteState(
    path: '/',
    builder: (key, name, routeData) {
      return HomeScreen();
    },
  ),
  RouteState(
    path: '/books',
    builder: (key, name, routeData) {
      return BooksScreen();
    },
  ),
  RouteState(
    path: '/books/:id',
    builder: (key, name, routeData) {
      final bookId = routeData.uri.pathSegments.last;
      return BookDetailsScreen(bookId: bookId);
    },
  ),
  RouteState(
    path: '/settings',
    builder: (key, name, routeData) {
      return SettingsScreen();
    },
  ),
  RouteState(
    path: '/unknown',
    builder: (key, name, routeData) {
      return UnknownScreen();
    },
  ),
];
