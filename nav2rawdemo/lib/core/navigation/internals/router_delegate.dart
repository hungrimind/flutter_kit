import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/navigation/route_config.dart';
import 'package:nav2demo/core/navigation/internals/navigation_state.dart' show ResolvedRoute, getSegments;
import 'package:nav2demo/core/navigation/internals/router_service.dart';

class AppRouterDelegate extends RouterDelegate<ResolvedRoute>
    with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate({required RouterService routerService}) : _routerService = routerService {
    _routerService.navigationStack.addListener(notifyListeners);
  }

  final RouterService _routerService;

  bool _matchRoute(String pattern, String path) {
    final pathUri = Uri.parse(path);
    final pathSegments = getSegments(pathUri.path);
    final patternSegments = getSegments(pattern);

    if (patternSegments.length != pathSegments.length) return false;

    for (var i = 0; i < patternSegments.length; i++) {
      if (patternSegments[i].startsWith(':')) continue;
      if (patternSegments[i] != pathSegments[i]) return false;
    }

    return true;
  }

  List<Page<dynamic>> createPages() {
    List<Page<dynamic>> pages = [];
    for (ResolvedRoute routeSettings in _routerService.navigationStack.value) {
      final matchedRoute = routes.firstWhere(
        (route) => _matchRoute(route.path, routeSettings.path),
        orElse: () => routes.firstWhere((route) => route.path == '/404'),
      );
      
      final resolvedRouteWithPattern = ResolvedRoute(
        path: routeSettings.path,
        routePattern: matchedRoute.path,
      );
      
      Widget child = matchedRoute.builder!(
        ValueKey(routeSettings.path),
        resolvedRouteWithPattern,
      );
      
      pages.add(
        MaterialPage(
          key: ValueKey('Page_${routeSettings.path}'),
          child: child,
          canPop: _routerService.canPop(routeSettings),
        ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> pages = createPages();

    return Navigator(
      key: navigatorKey,
      pages: List.of(pages),
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
  ResolvedRoute? get currentConfiguration {
    if (_routerService.navigationStack.value.isEmpty) {
      return null;
    }
    return _routerService.navigationStack.value.last;
  }

  // Called by the Router when the platform reports a new route information.
  // This can happen from browser back/forward, typing URL, or platform calls.
  @override
  Future<void> setNewRoutePath(ResolvedRoute configuration) async {
    _routerService.setPathStack(configuration);
  }

  // dispose remains the same
  @override
  void dispose() {
    _routerService.navigationStack.removeListener(notifyListeners);
    super.dispose();
  }
}
