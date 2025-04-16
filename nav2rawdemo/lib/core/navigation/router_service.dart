import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/route_data.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_observable.dart';
import 'package:nav2demo/core/navigation/utils.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService with ObservableRouter {
  RouterService() {
    _navigationStack.value = [
      RouteData(path: routes.firstWhere((route) => route.path == '/').path),
    ];
  }

  final _navigationStack = ValueNotifier<List<RouteData>>([]);
  ValueNotifier<List<RouteData>> get navigationStack => _navigationStack;

  void push(String path) {
    if (_pathNotSupported(path)) {
      _handlePathNotSupported(path);
      return;
    }

    final defaultRoute = RouteData.fromUri(Uri.parse(path));

    _navigationStack.value = [..._navigationStack.value, defaultRoute];
    notifyPush(defaultRoute);
  }

  void pop() {
    if (_navigationStack.value.length <= 1) {
      return;
    }

    final poppedRoute = _navigationStack.value.last;
    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.length - 1,
    );
    notifyPop(poppedRoute);
  }

  void replaceAll(String path) {
    if (_pathNotSupported(path)) {
      _handlePathNotSupported(path);
      return;
    }

    final newRoute = RouteData.fromUri(Uri.parse(path));
    _navigationStack.value = [newRoute];
    notifyReplace(newRoute);
  }

  void popUntil(String path) {
    if (!_existsInStack(path)) {
      return;
    }

    final indexToKeep = _navigationStack.value.indexWhere(
      (r) => r.path == path,
    );
    final removedRoutes = _navigationStack.value.sublist(indexToKeep + 1);

    _navigationStack.value = _navigationStack.value.sublist(0, indexToKeep + 1);

    // Notify about each removed route
    for (final route in removedRoutes.reversed) {
      notifyPop(route);
    }
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void replaceAllWithRoute(RouteData resolvedRoute) {
    if (_pathNotSupported(resolvedRoute.path)) {
      _handlePathNotSupported(resolvedRoute.path);
      return;
    }

    // For browser refreshes or direct URL access, we don't need to notify pops
    // since we're creating a fresh navigation stack
    _navigationStack.value = [resolvedRoute];
    notifyReplace(resolvedRoute);
  }

  void remove(String path) {
    if (!_existsInStack(path)) {
      return;
    }

    final routeToRemove = _navigationStack.value.firstWhere(
      (r) => r.path == path,
    );
    _navigationStack.value =
        _navigationStack.value.where((r) => r.path != path).toList();
    notifyRemove(routeToRemove);
  }

  bool canPop(RouteData route) {
    return _navigationStack.value.length > 1 &&
        _navigationStack.value.last.path == route.path;
  }

  bool _existsInStack(String path) {
    return _navigationStack.value.any((r) => r.path == path);
  }

  bool _pathNotSupported(String path) {
    return !routes.any((route) => matchRoute(route.path, path));
  }

  void _handlePathNotSupported(String path) {
    _navigationStack.value = [
      ..._navigationStack.value,
      RouteData(path: '/404'),
    ];
    notifyPush(RouteData(path: '/404'));
  }
}
