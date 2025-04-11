import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
// Make sure to import your NavigationState definition

class AppRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location ?? '/');

    // Handle root '/'
    if (uri.pathSegments.isEmpty) {
      return const NavigationState.initial(); // Or NavigationState(currentRoute: AppRoute.home)
    }

    // Handle '/books'
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'books') {
      return const NavigationState(currentRoute: AppRoute.books);
    }

    // Handle '/books/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'books') {
      final bookId = uri.pathSegments[1];
      // Optional: You might want to validate if bookId is a valid format here
      return NavigationState(
        currentRoute: AppRoute.bookDetails,
        selectedBookId: bookId,
      );
    }

    // Handle '/settings'
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'settings') {
      return const NavigationState(currentRoute: AppRoute.settings);
    }

    // Handle unknown routes (404)
    debugPrint('Unknown route: ${routeInformation.location}');
    return const NavigationState.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: '/404'); // Or just '/unknown'
    }
    switch (configuration.currentRoute) {
      case AppRoute.home:
        return const RouteInformation(location: '/');
      case AppRoute.books:
        return const RouteInformation(location: '/books');
      case AppRoute.bookDetails:
        // Ensure selectedBookId is not null, otherwise default to /books or handle error
        if (configuration.selectedBookId != null) {
          return RouteInformation(
            location: '/books/${configuration.selectedBookId}',
          );
        } else {
          // Fallback if bookId is missing for bookDetails state (should ideally not happen)
          return const RouteInformation(location: '/books');
        }
      case AppRoute.settings:
        return const RouteInformation(location: '/settings');
      case AppRoute.unknown: // Already handled by isUnknown check
        return const RouteInformation(location: '/404');
    }
    return null;
  }
}
