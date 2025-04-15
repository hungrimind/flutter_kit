import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

class AppRouteInformationParser
    extends RouteInformationParser<MyRouteSettings> {
  @override
  Future<MyRouteSettings> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    print("PARSED ROUTE URI: $uri");
    final route = MyRouteSettings.fromUri(uri);
    print("PARSED ROUTE: $route");
    return route;
  }

  @override
  RouteInformation? restoreRouteInformation(MyRouteSettings configuration) {
    print('restoreRouteInformation: ${configuration.path}');
    print('restoreRouteInformation: ${configuration.uri}');
    print('restoreRouteInformation: ${configuration.arguments}');
    if (configuration.path.isNotEmpty) {
      return RouteInformation(
        uri: configuration.uri,
        state: configuration.arguments,
      );
    }

    return null;
  }
}
