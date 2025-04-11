import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<NavigationState> _navigationState =
      ValueNotifier<NavigationState>(NavigationState.initial());

  get navigationState => _navigationState;

  /// Navigate to a new route
  void navigateTo(AppRoute route, {String? selectedBookId}) {
    _navigationState.value = NavigationState(
      currentRoute: route,
      selectedBookId: selectedBookId,
    );
  }

  /// Navigate back
  void navigateBack() {
    _navigationState.value = NavigationState.initial();
  }

  /// Clear navigation stack
  void clearNavigation() {
    _navigationState.value = NavigationState.initial();
  }
}
