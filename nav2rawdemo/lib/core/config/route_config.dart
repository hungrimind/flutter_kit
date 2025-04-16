import 'package:nav2demo/core/navigation/route_data.dart';
import 'package:nav2demo/pages/screens.dart';

/// The routes in your application.
///
/// You MUST have a route for the root path ('/').
/// You MUST have a 404 route.
final List<RouteEntry> routes = [
  RouteEntry(
    path: '/',
    builder: (key, routeData) {
      return HomeScreen();
    },
  ),
  RouteEntry(
    path: '/books',
    builder: (key, routeData) {
      return BooksScreen();
    },
  ),
  RouteEntry(
    path: '/books/:bookId',
    builder: (key, routeData) {
      return BookDetailsScreen(bookId: routeData.pathParameters['bookId'] ?? '');
    },
  ),
  RouteEntry(
    path: '/books/:bookId/owners/:ownerId',
    builder: (key, routeData) {
      return BookDetailsScreen(bookId: routeData.pathParameters['bookId'] ?? '');
    },
  ),
  RouteEntry(
    path: '/settings',
    builder: (key, routeData) {
      return SettingsScreen();
    },
  ),
  RouteEntry(
    path: '/404',
    builder: (key, routeData) {
      return UnknownScreen();
    },
  ),
];