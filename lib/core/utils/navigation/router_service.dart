import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/navigation/route_data.dart';
import 'package:flutter_kit/core/utils/navigation/navigation_observable.dart';
import 'package:flutter_kit/core/utils/navigation/utils.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService with ObservableRouter {
  RouterService({required this.supportedRoutes}) {
    _navigationStack.value = [_createRouteData(RouteData(path: '/'))];
  }

  final _navigationStack = ValueNotifier<List<RouteMatchData>>([]);
  ValueNotifier<List<RouteMatchData>> get navigationStack => _navigationStack;

  final List<RouteEntry> supportedRoutes;

  void goTo(RouteData routeData) {
    if (_pathNotSupported(routeData.path)) {
      _handlePathNotSupported();
      return;
    }

    final newRoute = _createRouteData(routeData);
    _navigationStack.value = [..._navigationStack.value, newRoute];
    notifyPush(newRoute);
  }

  void replace(RouteData routeData) {
    if (_pathNotSupported(routeData.path)) {
      _handlePathNotSupported();
      return;
    }

    final newRoute = _createRouteData(routeData);
    _navigationStack.value = [
      ..._navigationStack.value.sublist(0, _navigationStack.value.length - 1),
      newRoute,
    ];
    notifyReplace([newRoute]);
  }

  void back() {
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

  void replaceAll(List<RouteData> routeDatas) {
    final newRoutes = <RouteMatchData>[];
    for (final routeData in routeDatas) {
      if (_pathNotSupported(routeData.path)) {
        _handlePathNotSupported();
        return;
      }

      final newRoute = _createRouteData(routeData);
      newRoutes.add(newRoute);
    }
    _navigationStack.value = newRoutes;
    notifyReplace(newRoutes);
  }

  void backUntil(RouteData routeData) {
    if (!_existsInStack(routeData.path)) {
      return;
    }

    final indexToKeep = _navigationStack.value.indexWhere(
      (r) => r.pathWithParams == routeData.path,
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
  void replaceAllWithRoute(RouteMatchData resolvedRoute) {
    if (_pathNotSupported(resolvedRoute.pathWithParams)) {
      _handlePathNotSupported();
      return;
    }

    // When restoring from URL, extra is typically not available.
    // We use the resolvedRoute directly, which might or might not have extra depending on how it was created before serialization.
    // If RouteData came from AppRouteInformationParser, it won't have extra.
    _navigationStack.value = [resolvedRoute];
    notifyReplace([resolvedRoute]);
  }

  void remove(RouteData routeData) {
    if (!_existsInStack(routeData.path)) {
      return;
    }

    final routeToRemove = _navigationStack.value.firstWhere(
      (r) => r.pathWithParams == routeData.path,
    );
    _navigationStack.value =
        _navigationStack.value
            .where((r) => r.pathWithParams != routeData.path)
            .toList();
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

  void _handlePathNotSupported() {
    final notFoundRoute = _createRouteData(RouteData(path: '/404'));
    _navigationStack.value = [..._navigationStack.value, notFoundRoute];
    notifyPush(notFoundRoute);
  }

  RouteMatchData _createRouteData(RouteData routeData) {
    final uri = Uri.parse(routeData.path);
    return RouteMatchData(
      uri: uri,
      routePattern: findMatchingRoutePattern(uri, supportedRoutes),
      extra: routeData.extra,
    );
  }
}
