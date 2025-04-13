import 'package:flutter/foundation.dart'; // For ValueNotifier
import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart'; // Added for debugPrint

// Define a class for route configuration
class AppRoute {
  final String
  name; // Unique identifier for the route (e.g., 'home', 'bookDetails')
  final String path; // URL path pattern (e.g., '/books/:id')
  // Builder now accepts parameters extracted from the path
  final NavigationState Function(Map<String, String> params) builder;

  const AppRoute({
    required this.name,
    required this.path,
    required this.builder,
  });
}

// Updated list using RouteConfig with names

// --- Typed Route Names ---
// Provides static constants for type-safe access to route names

// Holds the current navigation state
@immutable // Good practice for state objects
class NavigationState {
  final String? routeName; // Unique name identifying the route configuration
  final String? selectedBookId; // For routes like /books/:id
  final bool isUnknown; // Flag for 404 routes

  // Main constructor
  const NavigationState({
    this.routeName,
    this.selectedBookId,
    this.isUnknown = false,
  });

  // Constructor for an unknown route (404)
  const NavigationState.unknown()
    : routeName = null, // No specific route name for unknown
      selectedBookId = null,
      isUnknown = true;

  // Initial state (e.g., home route)
  const NavigationState.initial()
    : routeName = RouteNames.home, // Use constant for initial route
      selectedBookId = null,
      isUnknown = false;

  // Helper for creating copies with modifications
  NavigationState copyWith({
    String? routeName,
    String? selectedBookId,
    bool? isUnknown,
  }) {
    final bool finalIsUnknown = isUnknown ?? this.isUnknown;
    if (finalIsUnknown) {
      return const NavigationState.unknown();
    }

    final String? finalSelectedBookId = (selectedBookId ?? this.selectedBookId);
    return NavigationState(
      routeName: routeName ?? this.routeName,
      selectedBookId: finalSelectedBookId,
      // isUnknown is handled above
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState &&
          runtimeType == other.runtimeType &&
          routeName == other.routeName && // Compare routeName
          selectedBookId == other.selectedBookId &&
          isUnknown == other.isUnknown;

  @override
  int get hashCode =>
      routeName.hashCode ^ selectedBookId.hashCode ^ isUnknown.hashCode;

  @override
  String toString() {
    return 'NavigationState(routeName: $routeName, selectedBookId: $selectedBookId, isUnknown: $isUnknown)';
  }
}
