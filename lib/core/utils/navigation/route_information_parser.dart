import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/navigation/route_data.dart';
import 'package:flutter_kit/core/utils/navigation/utils.dart';

class AppRouteInformationParser extends RouteInformationParser<RouteMatchData> {
  AppRouteInformationParser({required this.routes});

  final List<RouteEntry> routes;

  @override
  Future<RouteMatchData> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    return SynchronousFuture(
      RouteMatchData(
        uri: uri,
        routePattern: findMatchingRoutePattern(uri, routes),
      ),
    );
  }

  @override
  RouteInformation? restoreRouteInformation(RouteMatchData configuration) {
    if (configuration.pathWithParams.isNotEmpty) {
      return RouteInformation(uri: configuration.uri);
    }

    return null;
  }
}
