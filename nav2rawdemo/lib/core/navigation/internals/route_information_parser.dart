import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/internals/navigation_state.dart';

class AppRouteInformationParser
    extends RouteInformationParser<ResolvedRoute> {
  @override
  Future<ResolvedRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final route = ResolvedRoute.fromUri(uri);
    return route;
  }

  @override
  RouteInformation? restoreRouteInformation(ResolvedRoute configuration) {
    if (configuration.path.isNotEmpty) {
      return RouteInformation(
        uri: configuration.uri,
        state: configuration.arguments,
      );
    }

    return null;
  }
}
