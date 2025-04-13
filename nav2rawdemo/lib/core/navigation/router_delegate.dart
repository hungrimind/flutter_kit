import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
import 'package:nav2demo/pages/screens.dart';

class AppRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier {
  final ValueNotifier<NavigationState> _navigationStateNotifier;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate(this._navigationStateNotifier) {
    _navigationStateNotifier.addListener(notifyListeners);
  }

  @override
  NavigationState get currentConfiguration => _navigationStateNotifier.value;

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

    switch (state.routeName) {
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
        if (state.selectedBookId != null) {
          pages.add(
            MaterialPage(
              key: ValueKey('BookDetailsPage_${state.selectedBookId}'),
              child: BookDetailsScreen(bookId: state.selectedBookId!),
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
    if (state.isUnknown && state.routeName != RouteNames.unknown) {
      pages.add(
        const MaterialPage(
          key: ValueKey('UnknownPage'),
          child: UnknownScreen(),
        ),
      );
    }

    return Navigator(
      key: navigatorKey, // Navigator still needs a key
      pages: List.of(pages), // Use a copy to ensure change detection
      onDidRemovePage: (Page page) {
        if (page is MaterialPage) {
          final pageKey = page.key;
          final currentState = _navigationStateNotifier.value;

          if (pageKey == const ValueKey('BooksPage') &&
              currentState.routeName == RouteNames.books) {
            _navigationStateNotifier.value = currentState.copyWith(
              routeName: RouteNames.home,
            );
          } else if (pageKey is ValueKey &&
              pageKey.value.toString().startsWith('BookDetailsPage_') &&
              currentState.routeName == RouteNames.bookDetails) {
            _navigationStateNotifier.value = currentState.copyWith(
              routeName: RouteNames.books,
              selectedBookId: null,
            );
          } else if (pageKey == const ValueKey('SettingsPage') &&
              currentState.routeName == RouteNames.settings) {
            _navigationStateNotifier.value = currentState.copyWith(
              routeName: RouteNames.home,
            );
          } else if (pageKey == const ValueKey('UnknownPage') &&
              (currentState.routeName == RouteNames.unknown ||
                  currentState.isUnknown)) {
            _navigationStateNotifier.value = currentState.copyWith(
              routeName: RouteNames.home,
              isUnknown: false,
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
    NavigationState? previousState;

    if (currentState.routeName == RouteNames.bookDetails) {
      // Popping BookDetails goes back to Books list
      previousState = currentState.copyWith(
        routeName: RouteNames.books,
        selectedBookId: null,
      );
    } else if (currentState.routeName == RouteNames.books ||
        currentState.routeName == RouteNames.settings) {
      // Popping Books or Settings goes back to Home
      previousState = currentState.copyWith(routeName: RouteNames.home);
    } else if (currentState.routeName == RouteNames.unknown ||
        currentState.isUnknown) {
      // Popping Unknown page goes back to Home
      previousState = currentState.copyWith(
        routeName: RouteNames.home,
        isUnknown: false,
      );
    }
    // If currentRoute is Home, we don't define a previous state within the app.

    if (previousState != null) {
      // Update the state via the notifier. The listener will trigger rebuild.
      _navigationStateNotifier.value = previousState;
      // Return true to indicate we handled the pop.
      return Future.value(true);
    } else {
      // We are on the home page or couldn't determine a previous state.
      // Return false to allow the default system behavior (e.g., exit app on mobile).
      return Future.value(false);
    }
  }

  // setNewRoutePath remains the same
  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
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
