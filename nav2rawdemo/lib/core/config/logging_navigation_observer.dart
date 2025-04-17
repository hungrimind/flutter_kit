// ignore_for_file: avoid_print

import 'package:nav2demo/navigation/route_data.dart';
import 'package:nav2demo/navigation/navigation_observable.dart';

class LoggingNavigationObserver implements NavigationObserver {
  @override
  void onPush(RouteData route) {
    print('Navigation - Pushed: ${route.pathWithParams}');
  }

  @override
  void onPop(RouteData route) {
    print('Navigation - Popped: ${route.pathWithParams}');
  }

  @override
  void onReplace(RouteData route) {
    print('Navigation - Replaced with: ${route.pathWithParams}');
  }

  @override
  void onRemove(RouteData route) {
    print('Navigation - Removed: ${route.pathWithParams}');
  }
} 