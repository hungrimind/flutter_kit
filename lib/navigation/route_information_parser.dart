import 'package:flutter/material.dart';
import 'package:flutter_kit/navigation/route_data.dart';
import 'package:flutter_kit/navigation/utils.dart';

class AppRouteInformationParser
    extends RouteInformationParser<RouteData> {
  AppRouteInformationParser({required this.routes});
  
  final List<RouteEntry> routes;

  @override
  Future<RouteData> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    return RouteData(
      uri: uri,
      routePattern: findMatchingRoutePattern(uri, routes),
    );
  }

  @override
  RouteInformation? restoreRouteInformation(RouteData configuration) {
    if (configuration.pathWithParams.isNotEmpty) {
      return RouteInformation(
        uri: configuration.uri,
        state: configuration.arguments,
      );
    }

    return null;
  }
}
