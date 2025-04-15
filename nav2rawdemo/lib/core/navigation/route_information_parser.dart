import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

class AppRouteInformationParser extends RouteInformationParser<DefaultRoute> {
  @override
  Future<DefaultRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final route = DefaultRoute.fromUri(uri);
    return route;
  }

  @override
  RouteInformation? restoreRouteInformation(DefaultRoute configuration) {
    print('restoreRouteInformation: ${configuration.path}');
    if (configuration.name?.isNotEmpty ?? false) {
      return RouteInformation(
        uri: configuration.uri,
        state: configuration.arguments,
      );
    }

    return null;
  }
}
