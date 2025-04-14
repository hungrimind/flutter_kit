import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<AppRoute> _currentRoute = ValueNotifier<AppRoute>(
    AppRoute.initial(),
  );

  final ValueNotifier<List<AppRoute>> _navigationStack =
      ValueNotifier<List<AppRoute>>([AppRoute.initial()]);

  get currentRoute => _currentRoute;
  get navigationStack => _navigationStack;

  void navigateTo(String routeName, {Map<String, String>? params}) {
    _currentRoute.value = routeMap
        .firstWhere(
          (route) => route.name == routeName,
          orElse: () => AppRoute.unknown(),
        )
        .copyWith(params: params);
    _navigationStack.value = [..._navigationStack.value, _currentRoute.value];
  }

  /// Navigate back
  void navigateBack() {
    if (_navigationStack.value.length > 1) {
      _navigationStack.value = _navigationStack.value.take(1).toList();
    }
    _currentRoute.value = _navigationStack.value.last;
  }
}
