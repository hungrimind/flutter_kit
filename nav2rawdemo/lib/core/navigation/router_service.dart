// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/navigation/navigation_utils.dart';
import 'package:nav2demo/pages/screens.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<MyRouteSettings>> _navigationStack =
      ValueNotifier<List<MyRouteSettings>>([
        MyRouteSettings(
          label: HomeScreen.home,
          path: '/',
          pathParameters: {},
          queryParameters: {},
        ),
      ]);

  ValueNotifier<List<MyRouteSettings>> get navigationStack => _navigationStack;

  var justPopped = false;

  void navigateTo(String routeName, {Map<String, String>? queryParams}) {
    // Handle special case for home route
    if (routeName == 'home' || routeName == '/') {
      if (_navigationStack.value.isEmpty ||
          (_navigationStack.value.length == 1 &&
              _navigationStack.value.first.path == '/')) {
        _navigationStack.value = [
          MyRouteSettings(
            label: HomeScreen.home,
            path: '/',
            pathParameters: {},
            queryParameters: {},
          ),
        ];
        return;
      }
    }

    if (routeName == _navigationStack.value.last.label) {
      return;
    }

    RouteState? routeState = NavigationUtils.getNavigationDataFromName(
      routes,
      routeName,
    );

    if (routeState == null) {
      throw Exception('`$routeName` route not found.');
    }

    String? path;
    // Final path provided.
    if (routeName.startsWith('/') && routeName.contains(':') == false) {
      path = NavigationUtils.canonicalUri(routeName);
    } else if (routeState.path.contains(':')) {
      // Named pattern path provided.
      path = NavigationUtils.patternToPath(routeState.path, queryParams ?? {});
    } else {
      // Named direct path provided.
      path = routeState.path;
    }

    final defaultRoute = MyRouteSettings(
      label: routeState.label ?? '',
      path: path,
      pathParameters: routeState.path.contains(':') ? queryParams ?? {} : {},
      queryParameters: routeState.path.contains(':') ? {} : queryParams ?? {},
    );

    _navigationStack.value = [..._navigationStack.value, defaultRoute];

    print(
      'currentStack: ${_navigationStack.value.map((route) => route.label)}',
    );
  }

  void navigateBack() {
    if (_navigationStack.value.length <= 1) {
      // Don't allow popping the last route
      return;
    }

    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.length - 1,
    );
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void setPathStack(MyRouteSettings configuration) {
    // Find the route state for the given path
    RouteState? routeState = routes.firstWhere(
      (r) => r.path == configuration.path,
      orElse: () => routes.firstWhere((r) => r.label == HomeScreen.home),
    );

    // Create a new route with the correct label
    final newRoute = MyRouteSettings(
      label: routeState.label ?? '',
      path: configuration.path,
      pathParameters: configuration.pathParameters,
      queryParameters: configuration.queryParameters,
    );

    // For the home route, we just want a single item in the stack
    if (configuration.path == '/') {
      if (_navigationStack.value.length == 1 &&
          _navigationStack.value.first.path == '/') {
        return; // Already at home, no need to update
      }
      _navigationStack.value = [newRoute];
      return;
    }

    // Check if we're already at this route
    if (_navigationStack.value.isNotEmpty &&
        _navigationStack.value.last.path == configuration.path) {
      return;
    }

    // For other routes, ensure we have the home route and the target route
    if (_navigationStack.value.length == 2 &&
        _navigationStack.value.last.path == configuration.path) {
      return; // Already at the correct state
    }

    _navigationStack.value = [
      MyRouteSettings(
        label: HomeScreen.home,
        path: '/',
        pathParameters: {},
        queryParameters: {},
      ),
      newRoute,
    ];
  }

  void removePage(MyRouteSettings route) {
    _navigationStack.value =
        _navigationStack.value.where((r) => r != route).toList();
  }

  bool canPop(MyRouteSettings route) {
    return _navigationStack.value.length > 1 &&
        _navigationStack.value.last.path == route.path;
  }
}
