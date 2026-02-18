import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/navigation/route_data.dart';
import 'package:flutter_kit/core/utils/navigation/utils.dart';
import 'package:go_router/go_router.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  RouterService({required this.supportedRoutes}) {
    goRouter = _createGoRouter();
    _syncNavigationState();
    goRouter.addListener(_syncNavigationState);
  }

  final _navigationStack = ValueNotifier<List<RouteData>>([]);
  /// A lightweight view of navigation state sourced from go_router.
  /// This reflects the current resolved location.
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
    goRouter.push(path.name, extra: path.extra);
  }

  void replace(Path path) {
    if (_pathNotSupported(path.name)) {
      _handlePathNotSupported();
      return;
    }

    goRouter.replace(path.name, extra: path.extra);
  }

  void back() {
    if (!goRouter.canPop()) {
      return;
    }
    goRouter.pop();
  }

  void replaceAll(List<Path> routeDatas) {
    if (routeDatas.isEmpty) {
      return;
    }

    for (final routeData in routeDatas) {
      if (_pathNotSupported(routeData.name)) {
        _handlePathNotSupported();
        return;
      }
    }
    goRouter.go(routeDatas.first.name, extra: routeDatas.first.extra);
    for (final route in routeDatas.skip(1)) {
      goRouter.push(route.name, extra: route.extra);
    }
  }

  void backUntil(Path path) {
    if (_pathNotSupported(path.name)) {
      return;
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
    goRouter.go(
      resolvedRoute.pathWithParams,
      extra: resolvedRoute.extra,
    );
  }

  void remove(Path path) {
    if (_navigationStack.value.isEmpty) {
      return;
    }

    if (_navigationStack.value.last.pathWithParams == path.name) {
      if (goRouter.canPop()) {
        goRouter.pop();
      }
    }
  }

  bool _pathNotSupported(String path) {
    final uri = Uri.parse(path);
    return !supportedRoutes.any((route) => matchRoute(route.path, uri));
  }

  void _handlePathNotSupported() {
    goRouter.push('/404');
  }

  GoRouter _createGoRouter() {
    return GoRouter(
      routes: goRoutes,
      initialLocation: '/',
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

  void _syncNavigationState() {
    final routeConfiguration = goRouter.routerDelegate.currentConfiguration;
    final uri = routeConfiguration.uri;
    _navigationStack.value = [
      RouteData(
        uri: uri,
        routePattern: findMatchingRoutePattern(uri, supportedRoutes),
        extra: routeConfiguration.extra,
      ),
    ];
  }
}
