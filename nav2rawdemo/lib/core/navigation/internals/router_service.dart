import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/internals/navigation_state.dart';
import 'package:nav2demo/core/navigation/route_config.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  RouterService() {
    _navigationStack.value = [
      RouteData(path: routes.firstWhere((route) => route.path == '/').path),
    ];
  }

  final ValueNotifier<List<RouteData>> _navigationStack =
      ValueNotifier<List<RouteData>>([]);

  ValueNotifier<List<RouteData>> get navigationStack => _navigationStack;

  void push(String path) {
    if (path == _navigationStack.value.last.path) {
      return;
    }

    final defaultRoute = RouteData.fromUri(Uri.parse(path));

    _navigationStack.value = [..._navigationStack.value, defaultRoute];
  }

  void pop() {
    if (_navigationStack.value.length <= 1) {
      return;
    }

    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.length - 1,
    );
  }

  void replaceAll(String path) {
    _navigationStack.value = [RouteData.fromUri(Uri.parse(path))];
  }

  void popUntil(String path) {
    if (!_existsInStack(path)) {
      return;
    }

    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.indexWhere((r) => r.path == path) + 1,
    );
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void replaceAllWithRoute(RouteData resolvedRoute) {
    _navigationStack.value = [resolvedRoute];
  }

  void remove(String path) {
    if (!_existsInStack(path)) {
      return;
    }

    _navigationStack.value =
        _navigationStack.value.where((r) => r.path != path).toList();
  }

  bool canPop(RouteData route) {
    return _navigationStack.value.length > 1 &&
        _navigationStack.value.last.path == route.path;
  }

  bool _existsInStack(String path) {
    return _navigationStack.value.any((r) => r.path == path);
  }
}
