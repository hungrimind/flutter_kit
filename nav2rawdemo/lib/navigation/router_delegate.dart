import 'package:flutter/material.dart';
import 'package:nav2demo/navigation/route_data.dart' show RouteData;
import 'package:nav2demo/navigation/router_service.dart';
import 'package:nav2demo/navigation/utils.dart';

class AppRouterDelegate extends RouterDelegate<RouteData> {
  AppRouterDelegate({required RouterService routerService})
    : _routerService = routerService;

  final RouterService _routerService;

  List<Page<dynamic>> createPages() {
    List<Page<dynamic>> pages = [];
    for (RouteData routeData in _routerService.navigationStack.value) {
      final matchedRoute = _routerService.supportedRoutes.firstWhere(
        (route) => matchRoute(route.path, routeData.uri),
      );

      Widget child = matchedRoute.builder(
        ValueKey(routeData.pathWithParams),
        routeData,
      );

      pages.add(
        MaterialPage(
          key: ValueKey('Page_${routeData.hashCode}'),
          child: child,
          canPop: _routerService.canPop(routeData),
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
  Future<bool> popRoute() async {
    if (_routerService.navigationStack.value.length > 1) {
      _routerService.pop();
      return true;
    }
    return false;
  }

  @override
  RouteData? get currentConfiguration {
    if (_routerService.navigationStack.value.isEmpty) {
      return null;
    }
    return _routerService.navigationStack.value.last;
  }

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
