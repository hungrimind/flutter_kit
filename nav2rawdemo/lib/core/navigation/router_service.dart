// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/navigation/navigation_utils.dart';
import 'package:nav2demo/pages/screens.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<MyRouteSettings>> _navigationStack =
      ValueNotifier<List<MyRouteSettings>>([MyRouteSettings(path: '/')]);

  ValueNotifier<List<MyRouteSettings>> get navigationStack => _navigationStack;

  var justPopped = false;

  void navigateTo(String path) {
    if (path == _navigationStack.value.last.path) {
      return;
    }

    final defaultRoute = MyRouteSettings(path: path);

    _navigationStack.value = [..._navigationStack.value, defaultRoute];

    print('currentStack: ${_navigationStack.value.map((route) => route.path)}');
  }

  void navigateBack() {
    if (_navigationStack.value.length <= 1) {
      // Don't allow popping the last route
      return;
    }

    _navigationStack.value = _navigationStack.value.sublist(
      0,
      _navigationStack.value.length - 1,
    );
    print('currentStack: ${_navigationStack.value.map((route) => route.path)}');
  }

  /// Rebuilds the navigation stack to end at the specified route.
  /// This is typically used by setNewRoutePath to handle browser history changes.
  void setPathStack(MyRouteSettings configuration) {
    // Create a new route with the correct label
    final newRoute = MyRouteSettings(path: configuration.path);

    _navigationStack.value = [newRoute];
  }

  void removePage(MyRouteSettings route) {
    _navigationStack.value =
        _navigationStack.value.where((r) => r != route).toList();
  }

  bool canPop(MyRouteSettings route) {
    return _navigationStack.value.length > 1 &&
        _navigationStack.value.last.path == route.path;
  }
}
