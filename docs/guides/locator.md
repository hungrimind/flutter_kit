# Manage Global State

Modules are code that can be accessed app wide. These are registered using a locator.

## How to Register a Module

To register a module, you add it to the `modules` list in the `locator_config.dart` file. The builder function is called when the module is first accessed, and the `lazy` property determines if the module is created when the app starts, or when it is first accessed.

```dart
Module<ModuleName>(
  builder: () => ModuleName(),
  lazy: false,
);
```

## Default Modules

There are 3 default modules that are registered when the app starts:

- `RouterService` - The router service is used to navigate between routes.
- `NotifyService` - The notify service is used to show toasts and haptic feedback.
- `HttpAbstraction` - The http abstraction is used to make http requests.

```dart
final modules = [
  Module<RouterService>(
    builder: () => RouterService(routes: routes),
    lazy: false,
  ),
  Module<NotifyService>(
    builder: () => NotifyService(),
    lazy: true,
  ),
  Module<HttpAbstraction>(
    builder:
        () => HttpAbstraction(
          interceptors: [
            LoggingInterceptor(
              logBody: !kReleaseMode, // Only log bodies in debug mode
            ),
          ],
        ),
    lazy: true,
  ),
];
```

## How to Use a Module

To use a module, you can use the `locator` to get the module.

```dart
locator<ModuleName>();
```
