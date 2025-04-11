import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

class AppRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    // Handle root '/'
    if (uri.pathSegments.isEmpty) {
      return const NavigationState.initial();
    }

    // Handle '/books'
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'books') {
      return const NavigationState(currentRoute: AppRoute.books);
    }

    // Handle '/books/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'books') {
      final bookId = uri.pathSegments[1];
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
    debugPrint('Unknown route: ${routeInformation.uri}');
    return const NavigationState.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri(path: '/404'));
    }
    switch (configuration.currentRoute) {
      case AppRoute.home:
        return RouteInformation(uri: Uri(path: '/'));
      case AppRoute.books:
        return RouteInformation(uri: Uri(path: '/books'));
      case AppRoute.bookDetails:
        if (configuration.selectedBookId != null) {
          return RouteInformation(
            uri: Uri(path: '/books/${configuration.selectedBookId}'),
          );
        } else {
          return RouteInformation(uri: Uri(path: '/books'));
        }
      case AppRoute.settings:
        return RouteInformation(uri: Uri(path: '/settings'));
      case AppRoute.unknown:
        return RouteInformation(uri: Uri(path: '/404'));
    }
  }
}
