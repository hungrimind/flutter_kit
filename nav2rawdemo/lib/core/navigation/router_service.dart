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

  get navigationStack => _navigationStack;
  get currentRoute => _currentRoute;
  void navigateTo(String routeName, {Map<String, String>? params}) {
    _currentRoute.value = routeMap
        .firstWhere(
          (route) => route.name == routeName,
          orElse: () => AppRoute.unknown(),
        )
        .copyWith(params: params);

    _navigationStack.value = [..._navigationStack.value, _currentRoute.value];
    print('currentStack: ${_navigationStack.value.map((route) => route.name)}');
  }

  void navigateBack() {
    List<AppRoute> temps = [];
    print(
      'navigationStack: ${_navigationStack.value.map((route) => route.name)}',
    );
    print("navigationStack length: ${_navigationStack.value.length}");
    if (_navigationStack.value.length > 1) {
      temps = _navigationStack.value.sublist(
        0,
        _navigationStack.value.length - 1,
      );
    }
    print('temps: ${temps.map((route) => route.name)}');
    _navigationStack.value = temps;
    _currentRoute.value = _navigationStack.value.last;
    print('currentStack: ${_navigationStack.value.map((route) => route.name)}');
  }
}
