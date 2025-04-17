import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/navigation/route_data.dart' show RouteData;
import 'package:nav2demo/navigation/router_service.dart';
import 'package:nav2demo/navigation/utils.dart';

class AppRouterDelegate extends RouterDelegate<RouteData> {
  AppRouterDelegate({required RouterService routerService})
    : _routerService = routerService;

  final RouterService _routerService;

  List<Page<dynamic>> createPages() {
    List<Page<dynamic>> pages = [];
    for (RouteData routeSettings in _routerService.navigationStack.value) {
      final matchedRoute = routes.firstWhere(
        (route) => matchRoute(route.path, routeSettings.path),
        orElse: () => routes.firstWhere((route) => route.path == '/404'),
      );

      final resolvedRouteWithPattern = RouteData(
        path: routeSettings.path,
        routePattern: matchedRoute.path,
      );

      Widget child = matchedRoute.builder(
        ValueKey(routeSettings.path),
        resolvedRouteWithPattern,
      );

      pages.add(
        MaterialPage(
          key: ValueKey('Page_${routeSettings.hashCode}'),
          child: child,
          canPop: _routerService.canPop(routeSettings),
        ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: createPages(),
      onDidRemovePage: (page) {
        _routerService.pop();
      },
    );
  }

  @override
  Future<bool> popRoute() {
    return SynchronousFuture(false);
  }

  @override
  RouteData? get currentConfiguration {
    if (_routerService.navigationStack.value.isEmpty) {
      return null;
    }
    return _routerService.navigationStack.value.last;
  }

  // Called by the Router when the platform reports a new route information.
  // This can happen from browser back/forward, typing URL, or platform calls.
  @override
  Future<void> setNewRoutePath(RouteData configuration) async {
    _routerService.replaceAllWithRoute(configuration);
  }

  @override
  void addListener(VoidCallback listener) {
    _routerService.navigationStack.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerService.navigationStack.removeListener(listener);
  }
}
