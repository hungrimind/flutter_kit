# Print Logs

Using `print` statements is fine when you are building small apps, but as your app grows you will require more complex logging solutions.

## How it works

The project is using the [logging package](https://pub.dev/packages/logging) from the Dart team.

There is a `LoggingAbstraction` that only creates logs in the development environment (keeping production logs free). But you can extend it for production with third party solution(s).

## Use the Logger

To create a log within a viewmodel it would look like this:

```dart
class HomeViewModel {
  final _logger = Logger('$HomeViewModel')

  void createTodo() {
    // logic for creating a todo
    _logger.info('Todo created successfully');
  }
}
```

### Development

```bash
INFO: HomeViewModel: Todo created successfully
```

### Production (no local prints)

```bash

```

## Extensibility

The `LoggingAbstraction` is fully extendable through callback functions. You can pass in custom logging handlers for production environments, such as remote logging services.

### Using with Remote Logging

In your startup view model, you can initialize logging with custom callbacks for remote logging services:

```dart
Future<void> initializeApp() async {
  appStateNotifier.value = const InitializingApp();
  try {
    locator.registerMany(modules);

    // Initialize logging with optional remote logging callbacks
    loggingSubscription = _loggingAbstraction.initializeLogging(
      onLogs: [
        (record) => sendToSentry(record),
        (record) => sendToGrafana(record),
        // Add more remote logging services as needed
      ],
    );

    appStateNotifier.value = const AppInitialized();
  } catch (e, st) {
    appStateNotifier.value = AppInitializationError(e, st);
  }
}
```
