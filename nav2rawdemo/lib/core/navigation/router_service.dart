import 'package:flutter/material.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<NavigationState> _navigationState =
      ValueNotifier<NavigationState>(NavigationState.initial());

  get navigationState => _navigationState;

  /// Navigate to a new route by its name
  void navigateTo(String routeName, {String? selectedBookId}) {
    // Optional: You could look up the routeName in routeConfigs here
    // if you needed to validate it or access other AppRoute properties,
    // but for simply updating the state, the name is sufficient.
    // AppRoute? route = routeConfigs[routeName];
    // if (route == null) {
    //   debugPrint("Warning: Attempted to navigate to unknown route name: $routeName");
    //   // Decide how to handle: return, throw, or navigate to a default/404 state
    //   // For now, we allow it, letting the RouterDelegate handle unknown states.
    // }

    _navigationState.value = NavigationState(
      routeName: routeName, // Use the provided routeName string
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
