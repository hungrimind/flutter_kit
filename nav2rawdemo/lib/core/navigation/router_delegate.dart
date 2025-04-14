import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
import 'package:nav2demo/pages/screens.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute> with ChangeNotifier {
  final ValueNotifier<AppRoute> _navigationStateNotifier;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate(this._navigationStateNotifier) {
    _navigationStateNotifier.addListener(notifyListeners);
  }

  @override
  AppRoute get currentConfiguration => _navigationStateNotifier.value;

  var routerService = locator.get<RouterService>();

  @override
  Widget build(BuildContext context) {
    final state = _navigationStateNotifier.value;
    List<Page<dynamic>> pages = [];

    pages.add(
      MaterialPage(
        key: ValueKey('HomePage'),
        child: HomeScreen(routerService: routerService),
      ),
    );

    switch (state.name) {
      case RouteNames.home:
        break;
      case RouteNames.books:
        pages.add(
          MaterialPage(
            key: ValueKey('BooksPage'),
            child: BooksScreen(routerService: routerService),
          ),
        );
        break;
      case RouteNames.bookDetails:
        pages.add(
          MaterialPage(
            key: ValueKey('BooksPage'),
            child: BooksScreen(routerService: routerService),
          ),
        );
        if (state.params != null) {
          pages.add(
            MaterialPage(
              key: ValueKey('BookDetailsPage_${state.params}'),
              child: BookDetailsScreen(bookId: state.params!['id']!),
            ),
          );
        }
        break;
      case RouteNames.settings:
        pages.add(
          const MaterialPage(
            key: ValueKey('SettingsPage'),
            child: SettingsScreen(),
          ),
        );
        break;
      case RouteNames.unknown:
      default:
        pages.add(
          const MaterialPage(
            key: ValueKey('UnknownPage'),
            child: UnknownScreen(),
          ),
        );
        break;
    }

    return Navigator(
      key: navigatorKey, // Navigator still needs a key
      pages: List.of(pages), // Use a copy to ensure change detection
      onDidRemovePage: (Page page) {
        if (page is MaterialPage) {
          final pageKey = page.key;
          final currentState = _navigationStateNotifier.value;

          if (pageKey == const ValueKey('BooksPage') &&
              currentState.name == RouteNames.books) {
            _navigationStateNotifier.value = currentState.copyWith(
              name: RouteNames.home,
            );
          } else if (pageKey is ValueKey &&
              pageKey.value.toString().startsWith('BookDetailsPage_') &&
              currentState.name == RouteNames.bookDetails) {
            _navigationStateNotifier.value = currentState.copyWith(
              name: RouteNames.books,
              params: null,
            );
          } else if (pageKey == const ValueKey('SettingsPage') &&
              currentState.name == RouteNames.settings) {
            _navigationStateNotifier.value = currentState.copyWith(
              name: RouteNames.home,
            );
          } else if (pageKey == const ValueKey('UnknownPage') &&
              currentState.name == RouteNames.unknown) {
            _navigationStateNotifier.value = currentState.copyWith(
              name: RouteNames.home,
            );
          }
        }
      },
    );
  }

  @override
  Future<bool> popRoute() {
    final currentState = _navigationStateNotifier.value;

    // Determine the previous state based on the current state
    AppRoute? previousState;

    if (currentState.name == RouteNames.bookDetails) {
      // Popping BookDetails goes back to Books list
      previousState = currentState.copyWith(
        name: RouteNames.books,
        params: null,
      );
    } else if (currentState.name == RouteNames.books ||
        currentState.name == RouteNames.settings) {
      // Popping Books or Settings goes back to Home
      previousState = currentState.copyWith(name: RouteNames.home);
    } else if (currentState.name == RouteNames.unknown) {
      // Popping Unknown page goes back to Home
      previousState = currentState.copyWith(name: RouteNames.home);
    }
    // If currentRoute is Home, we don't define a previous state within the app.

    // We are on the home page or couldn't determine a previous state.
    // Return false to allow the default system behavior (e.g., exit app on mobile).
    return Future.value(false);
  }

  // setNewRoutePath remains the same
  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _navigationStateNotifier.value = configuration;
    return SynchronousFuture(null);
  }

  // dispose remains the same
  @override
  void dispose() {
    _navigationStateNotifier.removeListener(notifyListeners);
    super.dispose();
  }
}
