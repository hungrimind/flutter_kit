import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/pages/screens.dart';

final List<RouteState> routes = [
  RouteState(
    label: HomeScreen.home,
    path: '/',
    builder: (key, name, routeData) {
      return HomeScreen();
    },
  ),
  RouteState(
    label: BooksScreen.books,
    path: '/books',
    builder: (key, name, routeData) {
      return BooksScreen();
    },
  ),
  RouteState(
    label: BookDetailsScreen.bookDetails,
    path: '/books/:id',
    builder: (key, name, routeData) {
      final bookId = routeData.pathParameters['id']!;
      return BookDetailsScreen(bookId: bookId);
    },
  ),
  RouteState(
    label: SettingsScreen.settings,
    path: '/settings',
    builder: (key, name, routeData) {
      return SettingsScreen();
    },
  ),
  RouteState(
    label: UnknownScreen.unknown,
    path: '/unknown',
    builder: (key, name, routeData) {
      return UnknownScreen();
    },
  ),
];
