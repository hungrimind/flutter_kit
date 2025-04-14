import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<AppRoute>> _navigationStack =
      ValueNotifier<List<AppRoute>>([AppRoute.initial()]);

  get navigationStack => _navigationStack;

  void navigateTo(String routeName, {Map<String, String>? params}) {
    if (routeName == _navigationStack.value.last.name) {
      return;
    }

    _navigationStack.value = [
      ..._navigationStack.value,
      routeMap
          .firstWhere(
            (route) => route.name == routeName,
            orElse: () => AppRoute.unknown(),
          )
          .copyWith(params: params),
    ];
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
    print('currentStack: ${_navigationStack.value.map((route) => route.name)}');
  }
}
