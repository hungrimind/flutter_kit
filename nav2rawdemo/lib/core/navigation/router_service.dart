// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/pages/screens.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<RouteState>> _navigationStack =
      ValueNotifier<List<RouteState>>([routes.first]);

  ValueNotifier<List<RouteState>> get navigationStack => _navigationStack;

  var justPopped = false;

  void navigateTo(String routeName, {Map<String, String>? params}) {
    if (routeName == _navigationStack.value.last.label) {
      return;
    }

    final unkownRoute = routes.firstWhere(
      (route) => route.label == UnknownScreen.unknown,
    );

    _navigationStack.value = [
      ..._navigationStack.value,
      routes.firstWhere(
        (route) => route.label == routeName,
        orElse: () => unkownRoute,
      ),
    ];

    print('currentStack: ${_navigationStack.value.map((route) => route.label)}');
  }

  void navigateBack() {
    List<RouteState> temps = [];
    print(
      'navigationStack: ${_navigationStack.value.map((route) => route.label)}',
    );
    print("navigationStack length: ${_navigationStack.value.length}");
    if (_navigationStack.value.length > 1) {
      temps = _navigationStack.value.sublist(
        0,
        _navigationStack.value.length - 1,
      );
    }
    print('temps: ${temps.map((route) => route.label)}');
    _navigationStack.value = temps;
    print('currentStack: ${_navigationStack.value.map((route) => route.label)}');
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void setPathStack(DefaultRoute configuration) {
    print('NOT IMPLEMENTED');
  }

  bool canPop() {
    return _navigationStack.value.length > 1;
  }
}
