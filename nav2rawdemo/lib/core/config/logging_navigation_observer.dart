// ignore_for_file: avoid_print

import 'package:nav2demo/core/navigation/route_data.dart';
import 'package:nav2demo/core/navigation/navigation_observable.dart';

class LoggingNavigationObserver implements NavigationObserver {
  @override
  void onPush(RouteData route) {
    print('Navigation - Pushed: ${route.path}');
  }

  @override
  void onPop(RouteData route) {
    print('Navigation - Popped: ${route.path}');
  }

  @override
  void onReplace(RouteData route) {
    print('Navigation - Replaced with: ${route.path}');
  }

  @override
  void onRemove(RouteData route) {
    print('Navigation - Removed: ${route.path}');
  }
} 