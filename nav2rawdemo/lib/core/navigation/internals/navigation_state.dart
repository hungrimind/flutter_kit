import 'package:flutter/material.dart';

class RouteEntry {
  RouteEntry({required this.path, required this.builder});

  final String path;
  final Widget Function(
    ValueKey<String>? key,
    ResolvedRoute resolvedRoute,
  )?
  builder;
}

class ResolvedRoute extends RouteSettings {
  const ResolvedRoute({required this.path, this.routePattern});

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

  factory ResolvedRoute.fromUri(Uri uri, {String? routePattern}) {
    return ResolvedRoute(path: uri.toString(), routePattern: routePattern);
  }

  ResolvedRoute copyWith({String? path}) {
    return ResolvedRoute(path: path ?? this.path, routePattern: routePattern);
  }

  @override
  String toString() {
    return 'ResolvedRoute(path: $path)';
  }
}

/// Splits a path into segments, filtering out empty segments
List<String> getSegments(String path) => path.split('/').where((s) => s.isNotEmpty).toList();
