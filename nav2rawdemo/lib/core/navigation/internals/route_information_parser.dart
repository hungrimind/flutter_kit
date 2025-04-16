import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/internals/navigation_state.dart';

class AppRouteInformationParser
    extends RouteInformationParser<RouteData> {
  @override
  Future<RouteData> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final route = RouteData.fromUri(uri);
    return route;
  }

  @override
  RouteInformation? restoreRouteInformation(RouteData configuration) {
    if (configuration.path.isNotEmpty) {
      return RouteInformation(
        uri: configuration.uri,
        state: configuration.arguments,
      );
    }

    return null;
  }
}
