import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/internals/navigation_state.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<ResolvedRoute>> _navigationStack =
      ValueNotifier<List<ResolvedRoute>>([]);

  ValueNotifier<List<ResolvedRoute>> get navigationStack => _navigationStack;
  late final List<RouteEntry> routes;

  void init(List<RouteEntry> routes) {
    this.routes = routes;
    _navigationStack.value = [
      ResolvedRoute(path: routes.firstWhere((route) => route.path == '/').path),
    ];
  }

  void push(String path) {
    if (path == _navigationStack.value.last.path) {
      return;
    }

    final defaultRoute = ResolvedRoute(path: path);

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
    _navigationStack.value = [ResolvedRoute(path: path)];
  }

  void popUntil(String path) {
    final index = _navigationStack.value.indexWhere((r) => r.path == path);
    if (index == -1) {
      return;
    }

    _navigationStack.value = _navigationStack.value.sublist(0, index + 1);
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void setPathStack(ResolvedRoute configuration) {
    final newRoute = ResolvedRoute(path: configuration.path);

    _navigationStack.value = [newRoute];
  }

  void removePage(ResolvedRoute route) {
    _navigationStack.value =
        _navigationStack.value.where((r) => r != route).toList();
  }

  bool canPop(ResolvedRoute route) {
    return _navigationStack.value.length > 1 &&
        _navigationStack.value.last.path == route.path;
  }
}
