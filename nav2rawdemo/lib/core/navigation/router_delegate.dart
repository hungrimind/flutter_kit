import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/route_data.dart' show RouteData;
import 'package:nav2demo/core/navigation/router_service.dart';
import 'package:nav2demo/core/navigation/utils.dart';

class AppRouterDelegate extends RouterDelegate<RouteData>
    with ChangeNotifier {
  AppRouterDelegate({required RouterService routerService}) : _routerService = routerService {
    _routerService.navigationStack.addListener(notifyListeners);
  }

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

  // dispose remains the same
  @override
  void dispose() {
    _routerService.navigationStack.removeListener(notifyListeners);
    super.dispose();
  }
}
