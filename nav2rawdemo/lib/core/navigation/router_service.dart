import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<AppRoute>> _navigationStack =
      ValueNotifier<List<AppRoute>>([AppRoute.initial()]);

  get navigationStack => _navigationStack;

  var justPopped = false;

  void navigateTo(String routeName, {Map<String, String>? params}) {
    if (routeName == _navigationStack.value.last.name) {
      return;
    }

    _navigationStack.value = [
      ..._navigationStack.value,
      routeMap
          .firstWhere(
            (route) => route.name == routeName,
            orElse: () => AppRoute.unknown(),
          )
          .copyWith(params: params),
    ];
    print('currentStack: ${_navigationStack.value.map((route) => route.name)}');
  }

  void navigateBack() {
    List<AppRoute> temps = [];
    print(
      'navigationStack: ${_navigationStack.value.map((route) => route.name)}',
    );
    print("navigationStack length: ${_navigationStack.value.length}");
    if (_navigationStack.value.length > 1) {
      temps = _navigationStack.value.sublist(
        0,
        _navigationStack.value.length - 1,
      );
    }
    print('temps: ${temps.map((route) => route.name)}');
    _navigationStack.value = temps;
    print('currentStack: ${_navigationStack.value.map((route) => route.name)}');
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void setPathStack(AppRoute configuration) {
    List<AppRoute> newStack = [];
    bool routeFound = false;

    // Attempt to find the route and its predecessors in the predefined map
    // This logic might need adjustment based on how you want to handle deep links
    // or non-linear navigation restoration.
    // A simple approach: if it's home, just set home. Otherwise, assume home -> target.
    // A more robust approach would involve parsing the route name/path segments.

    if (configuration.name == RouteNames.home) {
      newStack = [AppRoute.initial()];
      routeFound = true;
    } else {
      // Example: Assume routes are always built on top of home
      // You might need a more complex logic to reconstruct the path
      // if your app supports deeper or more complex navigation structures
      // that should be restored from a URL.
      final targetRoute = routeMap.firstWhere(
        (route) => route.name == configuration.name,
        orElse: () => AppRoute.unknown(),
      );

      if (targetRoute.name != RouteNames.unknown) {
        // Reconstruct stack: Home -> Target
        // Note: Parameters from the *original* configuration are used for the target.
        newStack = [
          AppRoute.initial(),
          targetRoute.copyWith(params: configuration.params),
        ];
        routeFound = true;
      }
    }

    // If the target route wasn't found or couldn't be reconstructed, default to unknown on top of home
    if (!routeFound) {
      newStack = [AppRoute.initial(), AppRoute.unknown()];
    }

    _navigationStack.value = newStack;
    print('Stack set by setPathStack: ${newStack.map((route) => route.name)}');
  }

  bool canPop() {
    return _navigationStack.value.length > 1;
  }
}
