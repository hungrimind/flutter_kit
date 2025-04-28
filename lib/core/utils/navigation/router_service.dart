import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/navigation/route_data.dart';
import 'package:flutter_kit/core/utils/navigation/navigation_observable.dart';
import 'package:flutter_kit/core/utils/navigation/utils.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService with ObservableRouter {
  RouterService({required this.supportedRoutes}) {
    _navigationStack.value = [_createRouteData('/')];
  }

  final _navigationStack = ValueNotifier<List<RouteData>>([]);
  ValueNotifier<List<RouteData>> get navigationStack => _navigationStack;

  final List<RouteEntry> supportedRoutes;

  RouteData _createRouteData(String path, [Object? extra]) {
    final uri = Uri.parse(path);
    return RouteData(
      uri: uri,
      routePattern: findMatchingRoutePattern(uri, supportedRoutes),
      extra: extra,
    );
  }

  void push(String path, {Object? extra}) {
    if (_pathNotSupported(path)) {
      _handlePathNotSupported(path);
      return;
    }

    final newRoute = _createRouteData(path, extra);
    _navigationStack.value = [..._navigationStack.value, newRoute];
    notifyPush(newRoute);
  }

  void pop() {
    if (_navigationStack.value.length <= 1) {
      return;
    }

    final poppedRoute = _navigationStack.value.last;

    // Schedule this update for the next frame to avoid conflicts with build phase
    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.length - 1,
    );
    notifyPop(poppedRoute);
  }

  void replaceAll(String path, {Object? extra}) {
    if (_pathNotSupported(path)) {
      _handlePathNotSupported(path);
      return;
    }

    final newRoute = _createRouteData(path, extra);
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

    // When restoring from URL, extra is typically not available.
    // We use the resolvedRoute directly, which might or might not have extra depending on how it was created before serialization.
    // If RouteData came from AppRouteInformationParser, it won't have extra.
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
    _navigationStack.value = [..._navigationStack.value, notFoundRoute];
    notifyPush(notFoundRoute);
  }
}
