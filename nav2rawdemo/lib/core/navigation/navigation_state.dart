import 'package:flutter/material.dart';

class RouteState {
  RouteState({required this.path, required this.builder});

  final String path;
  final Widget Function(
    ValueKey<String>? key,
    String? name,
    MyRouteSettings routeData,
  )?
  builder;
}

class MyRouteSettings extends RouteSettings {
  final String path;

  Uri get uri => Uri(path: path);

  const MyRouteSettings({required this.path, super.name, super.arguments});

  factory MyRouteSettings.fromUri(Uri uri) {
    final path = uri.path;
    print("CREATING ROUTE SETTINGS FROM URI: $path");
    return MyRouteSettings(
      path: path,
      name: uri.pathSegments.last,
      arguments: uri.queryParameters,
    );
  }

  MyRouteSettings copyWith({String? path}) {
    return MyRouteSettings(path: path ?? this.path);
  }

  @override
  String toString() {
    return 'MyRouteSettings(path: $path)';
  }
}
