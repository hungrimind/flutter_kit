import 'package:flutter/material.dart';
import 'package:flutter_kit/navigation/route_data.dart';
import 'package:flutter_kit/navigation/navigation_observable.dart';
import 'package:flutter_kit/navigation/utils.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService with ObservableRouter {
  RouterService({required this.supportedRoutes}) {
    _navigationStack.value = [_createRouteData('/')];
  }

  final _navigationStack = ValueNotifier<List<RouteData>>([]);
  ValueNotifier<List<RouteData>> get navigationStack => _navigationStack;

  final List<RouteEntry> supportedRoutes;

  RouteData _createRouteData(String path) {
    final uri = Uri.parse(path);
    return RouteData(
      uri: uri,
      routePattern: findMatchingRoutePattern(uri, supportedRoutes),
    );
  }

  void push(String path) {
    if (_pathNotSupported(path)) {
      _handlePathNotSupported(path);
      return;
    }

    final defaultRoute = _createRouteData(path);
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

    final newRoute = _createRouteData(path);
    _navigationStack.value = [newRoute];
    notifyReplace(newRoute);
  }

  void popUntil(String path) {
    if (!_existsInStack(path)) {
      return;
    }

    final indexToKeep = _navigationStack.value.indexWhere(
      (r) => r.pathWithParams == path,
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
    if (_pathNotSupported(resolvedRoute.pathWithParams)) {
      _handlePathNotSupported(resolvedRoute.pathWithParams);
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
      (r) => r.pathWithParams == path,
    );
    _navigationStack.value =
        _navigationStack.value.where((r) => r.pathWithParams != path).toList();
    notifyRemove(routeToRemove);
  }

  bool canPop(RouteData route) {
    return _navigationStack.value.length > 1 &&
        _navigationStack.value.last.pathWithParams == route.pathWithParams;
  }

  bool _existsInStack(String path) {
    final uri = Uri.parse(path);
    return _navigationStack.value.any((r) => r.uri == uri);
  }

  bool _pathNotSupported(String path) {
    final uri = Uri.parse(path);
    return !supportedRoutes.any((route) => matchRoute(route.path, uri));
  }

  void _handlePathNotSupported(String path) {
    final notFoundRoute = _createRouteData('/404');
    _navigationStack.value = [
      ..._navigationStack.value,
      notFoundRoute,
    ];
    notifyPush(notFoundRoute);
  }
}
