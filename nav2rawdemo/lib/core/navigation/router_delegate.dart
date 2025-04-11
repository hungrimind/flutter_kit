import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
import 'package:nav2demo/pages/screens.dart'; // For SynchronousFuture
// Import NavigationState, AppRoute, navigationStateNotifier, and your Page classes

class AppRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier {
  // Remove PopNavigatorRouterDelegateMixin

  final ValueNotifier<NavigationState> _navigationStateNotifier;
  // Keep the navigatorKey for the Navigator widget itself, but we won't use it
  // directly for popping in our logic. It helps Flutter manage the Navigator state.
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

    // --- Page building logic remains the same as before ---
    pages.add(
      MaterialPage(
        key: ValueKey('HomePage'),
        child: HomeScreen(routerService: routerService),
      ),
    );

    switch (state.currentRoute) {
      case AppRoute.home:
        break;
      case AppRoute.books:
        pages.add(
          MaterialPage(
            key: ValueKey('BooksPage'),
            child: BooksScreen(routerService: routerService),
          ),
        );
        break;
      case AppRoute.bookDetails:
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
      case AppRoute.settings:
        pages.add(
          const MaterialPage(
            key: ValueKey('SettingsPage'),
            child: SettingsScreen(),
          ),
        );
        break;
      case AppRoute.unknown:
      default:
        pages.add(
          const MaterialPage(
            key: ValueKey('UnknownPage'),
            child: UnknownScreen(),
          ),
        );
        break;
    }
    if (state.isUnknown && state.currentRoute != AppRoute.unknown) {
      pages.add(
        const MaterialPage(
          key: ValueKey('UnknownPage'),
          child: UnknownScreen(),
        ),
      );
    }
    // --- End of page building logic ---

    return Navigator(
      key: navigatorKey, // Navigator still needs a key
      pages: List.of(pages), // Use a copy to ensure change detection
      onPopPage: _handleNavigatorPopPage, // Keep this callback
    );
  }

  // This method is called by the Navigator widget itself if a route is popped internally.
  // We ensure our state reflects this pop.
  bool _handleNavigatorPopPage(Route<dynamic> route, dynamic result) {
    // Check if the pop originated from the Navigator stack successfully
    if (!route.didPop(result)) {
      return false; // The pop failed, don't update state
    }

    // Determine the state change based on which page's route was popped.
    // This logic mirrors the logic in popRoute, ensuring state consistency
    // even if a pop didn't originate from the back button (less common now).
    final currentState = _navigationStateNotifier.value;
    bool stateChanged = false;

    if (route.settings is MaterialPage) {
      final pageKey = (route.settings as MaterialPage).key;
      if (pageKey == const ValueKey('BooksPage') &&
          currentState.currentRoute == AppRoute.books) {
        _navigationStateNotifier.value = currentState.copyWith(
          currentRoute: AppRoute.home,
        );
        stateChanged = true;
      } else if (pageKey is ValueKey &&
          pageKey.value.toString().startsWith('BookDetailsPage_') &&
          currentState.currentRoute == AppRoute.bookDetails) {
        _navigationStateNotifier.value = currentState.copyWith(
          currentRoute: AppRoute.books,
          clearSelectedBookId: true,
        );
        stateChanged = true;
      } else if (pageKey == const ValueKey('SettingsPage') &&
          currentState.currentRoute == AppRoute.settings) {
        _navigationStateNotifier.value = currentState.copyWith(
          currentRoute: AppRoute.home,
        );
        stateChanged = true;
      } else if (pageKey == const ValueKey('UnknownPage') &&
          (currentState.currentRoute == AppRoute.unknown ||
              currentState.isUnknown)) {
        _navigationStateNotifier.value = currentState.copyWith(
          currentRoute: AppRoute.home,
          isUnknown: false,
        ); // Go home from 404
        stateChanged = true;
      }
      // If popping home page, state doesn't change within the app stack here.
    }

    // Return true because route.didPop was true, even if our specific state logic
    // didn't handle this exact page type (which would be unexpected).
    // More accurately, return stateChanged to reflect if *our* logic handled it.
    return stateChanged;
  }

  // This method is now the primary handler for the back button.
  @override
  Future<bool> popRoute() {
    final currentState = _navigationStateNotifier.value;

    // Determine the previous state based on the current state
    NavigationState? previousState;

    if (currentState.currentRoute == AppRoute.bookDetails) {
      // Popping BookDetails goes back to Books list
      previousState = currentState.copyWith(
        currentRoute: AppRoute.books,
        clearSelectedBookId: true,
      );
    } else if (currentState.currentRoute == AppRoute.books ||
        currentState.currentRoute == AppRoute.settings) {
      // Popping Books or Settings goes back to Home
      previousState = currentState.copyWith(currentRoute: AppRoute.home);
    } else if (currentState.currentRoute == AppRoute.unknown ||
        currentState.isUnknown) {
      // Popping Unknown page goes back to Home
      previousState = currentState.copyWith(
        currentRoute: AppRoute.home,
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
