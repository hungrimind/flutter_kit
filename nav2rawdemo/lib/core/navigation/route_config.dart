import 'package:nav2demo/core/navigation/internals/navigation_state.dart';
import 'package:nav2demo/pages/screens.dart';

/// The routes in your application.
///
/// You MUST have a route for the root path ('/').
/// You MUST have a 404 route.
final List<RouteEntry> routes = [
  RouteEntry(
    path: '/',
    builder: (key, route) {
      return HomeScreen();
    },
  ),
  RouteEntry(
    path: '/books',
    builder: (key, route) {
      return BooksScreen();
    },
  ),
  RouteEntry(
    path: '/books/:bookId',
    builder: (key, route) {
      print(route.pathParameters);
      
      // just got this working too
      print(route.queryParameters);
      return BookDetailsScreen(bookId: route.pathParameters['bookId'] ?? '');
    },
  ),
  RouteEntry(
    path: '/books/:bookId/owners/:ownerId',
    builder: (key, route) {
      return BookDetailsScreen(bookId: route.pathParameters['bookId'] ?? '');
    },
  ),
  RouteEntry(
    path: '/settings',
    builder: (key, route) {
      return SettingsScreen();
    },
  ),
  RouteEntry(
    path: '/404',
    builder: (key, route) {
      return UnknownScreen();
    },
  ),
];
