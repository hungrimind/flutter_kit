import 'package:flutter/foundation.dart'; // For ValueNotifier
import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart'; // Added for debugPrint

// Define a class for route configuration
class AppRoute {
  final String
  name; // Unique identifier for the route (e.g., 'home', 'bookDetails')
  final String path; // URL path pattern (e.g., '/books/:id')
  final Map<String, String>? params; // Parameters for the route

  const AppRoute({required this.name, required this.path, this.params});

  const AppRoute.initial() : name = RouteNames.home, path = '/', params = null;

  const AppRoute.unknown()
    : name = RouteNames.unknown,
      path = '/404',
      params = null;

  AppRoute copyWith({String? name, String? path, Map<String, String>? params}) {
    return AppRoute(
      name: name ?? this.name,
      path: path ?? this.path,
      params: params ?? this.params,
    );
  }
}
