import 'package:flutter/material.dart';
import 'package:nav2demo/navigation/utils.dart';

class RouteEntry {
  RouteEntry({required this.path, required this.builder});

  final String path;
  final Widget Function(ValueKey<String>? key, RouteData routeData)
  builder;
}

class RouteData extends RouteSettings {
  const RouteData({required this.path, this.routePattern});

  final String path;
  final String? routePattern;

  Uri get uri => Uri.parse(path);

  Map<String, String> get queryParameters => uri.queryParameters;

  Map<String, String> get pathParameters {
    if (routePattern == null) return {};

    final params = <String, String>{};
    final pathSegments = getSegments(uri.path);
    final patternSegments = getSegments(routePattern!);

    if (patternSegments.length != pathSegments.length) return params;

    for (var i = 0; i < patternSegments.length; i++) {
      if (patternSegments[i].startsWith(':')) {
        final paramName = patternSegments[i].substring(1);
        params[paramName] = pathSegments[i];
      }
    }

    return params;
  }

  factory RouteData.fromUri(Uri uri, {String? routePattern}) {
    return RouteData(path: uri.toString(), routePattern: routePattern);
  }

  @override
  String toString() {
    return 'RouteData(path: $path)';
  }
}
