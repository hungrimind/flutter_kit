import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

class AppRouteInformationParser
    extends RouteInformationParser<MyRouteSettings> {
  @override
  Future<MyRouteSettings> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final route = MyRouteSettings.fromUri(uri);
    return route;
  }

  @override
  RouteInformation? restoreRouteInformation(MyRouteSettings configuration) {
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
