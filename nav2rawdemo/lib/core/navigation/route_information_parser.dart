import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/config/route_config.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final uriPathSegments = uri.pathSegments;

    for (final config in routeMap) {
      final cleanPath = config.path.trim().replaceAll(RegExp(r'^/+|/+$'), '');
      final patternSegments =
          cleanPath.isEmpty ? <String>[] : cleanPath.split('/');
      final params = <String, String>{};

      if (uriPathSegments.length != patternSegments.length) {
        continue;
      }

      bool match = true;
      for (int i = 0; i < patternSegments.length; i++) {
        final patternSegment = patternSegments[i];
        final pathSegment = uriPathSegments[i];

        if (patternSegment.startsWith(':')) {
          final paramName = patternSegment.substring(1);
          params[paramName] = pathSegment;
        } else if (patternSegment != pathSegment) {
          match = false;
          break;
        }
      }

      if (match) {
        try {
          return config.copyWith(params: params);
        } catch (e, stackTrace) {
          debugPrint(
            "Error executing builder for route '${config.name}': $e\n$stackTrace",
          );
          return const AppRoute.unknown();
        }
      }
    }

    debugPrint('Unknown route: ${routeInformation.uri}');
    return const AppRoute.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    if (configuration.name == RouteNames.unknown) {
      return RouteInformation(uri: Uri(path: '/404'));
    }

    // Find the route config matching the name
    final config = routeMap.firstWhere(
      (rc) => rc.name == configuration.name,
      orElse: () {
        // This should ideally not happen if NavigationState is valid
        debugPrint(
          "Error: No route config found for routeName '${configuration.name}'",
        );
        // Return a RouteConfig representing 404 to construct the URI
        return AppRoute.unknown();
      },
    );

    // Reconstruct the path from the pattern and configuration data
    String path = config.path;
    final patternSegments = config.path.split('/');

    for (final segment in patternSegments) {
      if (segment.startsWith(':')) {
        final paramName = segment.substring(1);
        // Retrieve the parameter value from the configuration's params map
        final String? value = configuration.params?[paramName];

        // --- How to get parameter values from NavigationState? ---
        // This part needs a strategy. For now, we only have selectedBookId.
        // if (paramName == 'id' && config.name == 'bookDetails') {
        //   value = configuration.params?['id'];
        // }
        // Add more cases here if other routes have parameters stored
        // in NavigationState (e.g., settings/:section, profile/:userId)
        // ---------------------------------------------------------

        if (value != null && value.isNotEmpty) {
          path = path.replaceFirst(segment, value);
        } else {
          // Parameter value is missing or invalid in the state.
          // This indicates an inconsistency.
          debugPrint(
            "Warning: Missing or invalid value for parameter '$paramName' in route '${config.name}' when restoring. State: $configuration",
          );
          // Fallback: either return a default/parent route or 404
          // Option 1: Return 404
          return RouteInformation(uri: Uri(path: '/404'));
          // Option 2: Try to return a parent route (e.g., '/books' for '/books/:id')
          // This depends on application logic.
          // Example: if (config.name == 'bookDetails') return RouteInformation(uri: Uri(path: '/books'));
        }
      }
    }

    return RouteInformation(uri: Uri(path: path));
  }
}
