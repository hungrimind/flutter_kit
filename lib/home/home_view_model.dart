import 'package:flutter/foundation.dart';

/// Manages the counter state and logic for the home screen
class HomeViewModel {
  /// The current count value as a ValueNotifier
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  /// Increments the counter by 1
  void incrementCounter() {
    counter.value++;
  }

  /// Resets the counter to 0
  void resetCounter() {
    counter.value = 0;
  }
  
  /// Dispose resources when they are no longer needed
  void dispose() {
    counter.dispose();
  }
} 