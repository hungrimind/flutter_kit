# Configure App Startup

In most apps in Flutter you might be aware of putting initialization logic in `runApp` in `main.dart`. The issue with this is if something fails, you are effectivly stuck and need to restart your application. The setup we provide will let you have full control over the loading, error and completed state of initialization of the app.

## How it works

The router of `MaterialApp`, has a `Builder` property, here you can define what your app displays. By default `child`, will resolve to the `/` route which in this case is defined by the routing setup. Prior to this happening though you can conditionally return other views to display which makes this a very simple state machine to let us do initialization logic.

```dart
// startup_view.dart
@override
Widget build(BuildContext context) {
  return ValueListenableBuilder<AppState>(
    valueListenable: _viewModel.appStateNotifier,
    builder: (context, state, _) {
      return MaterialApp.router(
        routerConfig: _routerConfig,
        builder: (context, child) => switch (state) {
            InitializingApp() => _SplashView(),
            AppInitialized() => child!,
            AppInitializationError() => _StartupErrorView(
              onRetry: _viewModel.retryInitialization,
            ),
          },
      );
    },
  );
}
```

For the logic of the initialization, this is done by setting the state to `InitializingApp`, do the `async` task and depending on that set the desired state.

```dart
/// startup_view_model.dart
class StartupViewModel {
  final appStateNotifier = ValueNotifier<AppState>(const InitializingApp());

  Future<void> initializeApp() async {
    appStateNotifier.value = const InitializingApp();
    try {
      // do initialization logic here

      appStateNotifier.value = const AppInitialized();
    } catch (e, st) {
      appStateNotifier.value = AppInitializationError(e, st);
    }
  }

  Future<void> retryInitialization() async {
    locator.reset();
    await initializeApp();
  }

  void dispose() {
    appStateNotifier.dispose();
  }
}
```
