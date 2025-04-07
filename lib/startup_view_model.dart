import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/utils/locator.dart';

/// Represents different states of app initialization
sealed class AppState {
  const AppState();
}

class InitializingApp extends AppState {
  const InitializingApp();
}

class AppInitialized extends AppState {
  const AppInitialized();
}

class AppInitializationError extends AppState {
  final String message;
  const AppInitializationError(this.message);
}

/// ViewModel responsible for handling app startup and initialization
class StartupViewModel {
  final appStateNotifier = ValueNotifier<AppState>(const InitializingApp());

  Future<void> initializeApp() async {
    try {
      setupLocator();
      await Future.delayed(const Duration(seconds: 1));
      
      appStateNotifier.value = const AppInitialized();
    } catch (e) {
      appStateNotifier.value = AppInitializationError(e.toString());
    }
  }

  void dispose() {
    appStateNotifier.dispose();
  }
} 