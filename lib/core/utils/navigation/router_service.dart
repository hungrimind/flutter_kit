import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/navigation/route_data.dart';
import 'package:flutter_kit/core/utils/navigation/navigation_observable.dart';
import 'package:flutter_kit/core/utils/navigation/utils.dart';
import 'package:go_router/go_router.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService with ObservableRouter {
  RouterService({required this.supportedRoutes}) {
    _navigationStack.value = [_createRouteData(Path(name: '/'))];
    goRouter = _createGoRouter();
  }

  final _navigationStack = ValueNotifier<List<RouteData>>([]);
  ValueNotifier<List<RouteData>> get navigationStack => _navigationStack;

  final List<RouteEntry> supportedRoutes;
  late final GoRouter goRouter;

  List<RouteBase> get goRoutes => supportedRoutes
      .where((route) => route.path != '/404')
      .map(
        (route) => GoRoute(
          path: route.path,
          builder: (context, state) => route.builder(
            state.pageKey,
            RouteData(
              uri: state.uri,
              routePattern: route.path,
              extra: state.extra,
            ),
          ),
        ),
      )
      .toList();

  void goTo(Path path) {
    if (_pathNotSupported(path.name)) {
      _handlePathNotSupported();
      return;
    }

    final newRoute = _createRouteData(path);
    _navigationStack.value = [..._navigationStack.value, newRoute];
    notifyPush(newRoute);
    goRouter.push(path.name, extra: path.extra);
  }

  void replace(Path path) {
    if (_pathNotSupported(path.name)) {
      _handlePathNotSupported();
      return;
    }

    final newRoute = _createRouteData(path);
    _navigationStack.value = [
      ..._navigationStack.value.sublist(0, _navigationStack.value.length - 1),
      newRoute,
    ];
    notifyReplace([newRoute]);
    goRouter.replace(path.name, extra: path.extra);
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
    if (goRouter.canPop()) {
      goRouter.pop();
    }
  }

  void replaceAll(List<Path> routeDatas) {
    if (routeDatas.isEmpty) {
      return;
    }

    final newRoutes = <RouteData>[];
    for (final routeData in routeDatas) {
      if (_pathNotSupported(routeData.name)) {
        _handlePathNotSupported();
        return;
      }

      final newRoute = _createRouteData(routeData);
      newRoutes.add(newRoute);
    }
    _navigationStack.value = newRoutes;
    notifyReplace(newRoutes);
    goRouter.go(routeDatas.first.name, extra: routeDatas.first.extra);
    for (final route in routeDatas.skip(1)) {
      goRouter.push(route.name, extra: route.extra);
    }
  }

  void backUntil(Path path) {
    if (!_existsInStack(path.name)) {
      return;
    }

    final indexToKeep = _navigationStack.value.indexWhere(
      (r) => r.pathWithParams == path.name,
    );
    final removedRoutes = _navigationStack.value.sublist(indexToKeep + 1);
    _navigationStack.value = _navigationStack.value.sublist(0, indexToKeep + 1);

    // Notify about each removed route
    for (final route in removedRoutes.reversed) {
      notifyPop(route);
    }
    goRouter.go(path.name, extra: path.extra);
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void replaceAllWithRoute(RouteData resolvedRoute) {
    if (_pathNotSupported(resolvedRoute.pathWithParams)) {
      _handlePathNotSupported();
      return;
    }

    // When restoring from URL, extra is typically not available.
    // We use the resolvedRoute directly, which might or might not have extra depending on how it was created before serialization.
    // If RouteData came from AppRouteInformationParser, it won't have extra.
    _navigationStack.value = [resolvedRoute];
    notifyReplace([resolvedRoute]);
    goRouter.go(
      resolvedRoute.pathWithParams,
      extra: resolvedRoute.extra,
    );
  }

  void remove(Path path) {
    if (!_existsInStack(path.name)) {
      return;
    }

    final routeToRemove = _navigationStack.value.firstWhere(
      (r) => r.pathWithParams == path.name,
    );
    final wasTopRoute = routeToRemove == _navigationStack.value.last;
    _navigationStack.value = _navigationStack.value
        .where((r) => r.pathWithParams != path.name)
        .toList();
    notifyRemove(routeToRemove);
    if (wasTopRoute && _navigationStack.value.isNotEmpty) {
      goRouter.go(_navigationStack.value.last.pathWithParams);
    }
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
    final notFoundRoute = _createRouteData(Path(name: '/404'));
    _navigationStack.value = [..._navigationStack.value, notFoundRoute];
    notifyPush(notFoundRoute);
    goRouter.push('/404');
  }

  RouteData _createRouteData(Path path) {
    final uri = Uri.parse(path.name);
    return RouteData(
      uri: uri,
      routePattern: findMatchingRoutePattern(uri, supportedRoutes),
      extra: path.extra,
    );
  }

  GoRouter _createGoRouter() {
    return GoRouter(
      routes: goRoutes,
      initialLocation: _navigationStack.value.first.pathWithParams,
      errorBuilder: (context, state) {
        final notFoundRoute = supportedRoutes.firstWhere(
          (route) => route.path == '/404',
          orElse: () => RouteEntry(
            path: '/404',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Route not found'))),
          ),
        );
        return notFoundRoute.builder(
          state.pageKey,
          RouteData(
            uri: state.uri,
            routePattern: '/404',
            extra: state.extra,
          ),
        );
      },
    );
  }
}
