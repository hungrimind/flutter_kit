import 'package:flutter/material.dart';
import '../../pages/page1.dart';
import '../../pages/page2.dart';
import '../../pages/page3.dart';

/// Represents the different routes in the application
enum AppRoute { home, page2, page2Details, page3, page3WithId }

/// Configuration for a specific route
class RouteConfig {
  final AppRoute route;
  final Map<String, String> params;

  const RouteConfig({required this.route, this.params = const {}});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteConfig &&
        other.route == route &&
        Map.from(other.params).toString() == Map.from(params).toString();
  }

  @override
  int get hashCode => Object.hash(route, Map.from(params).toString());
}

/// Manages the application's navigation state
class AppRouter extends RouterDelegate<RouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfig> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  RouteConfig _currentConfig = const RouteConfig(route: AppRoute.home);

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  RouteConfig get currentConfiguration => _currentConfig;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        MaterialPage(key: const ValueKey('home'), child: const Page1()),
        if (_currentConfig.route != AppRoute.home) ...[
          MaterialPage(
            key: ValueKey(_currentConfig.route.toString()),
            child: _buildPage(_currentConfig),
          ),
        ],
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        // When popping, go back to home
        _currentConfig = const RouteConfig(route: AppRoute.home);
        notifyListeners();
        return true;
      },
    );
  }

  Widget _buildPage(RouteConfig config) {
    switch (config.route) {
      case AppRoute.home:
        return const Page1();
      case AppRoute.page2:
        return const Page2();
      case AppRoute.page2Details:
        return const Page2Details();
      case AppRoute.page3:
        return const Page3();
      case AppRoute.page3WithId:
        return Page3WithId(id: config.params['id'] ?? 'unknown');
    }
  }

  @override
  Future<void> setNewRoutePath(RouteConfig configuration) async {
    _currentConfig = configuration;
    notifyListeners();
  }

  /// Navigate to a new route
  void navigateTo(AppRoute route, {Map<String, String>? params}) {
    _currentConfig = RouteConfig(route: route, params: params ?? {});
    notifyListeners();
  }

  /// Go back to the previous route
  void goBack() {
    _currentConfig = const RouteConfig(route: AppRoute.home);
    notifyListeners();
  }
}
