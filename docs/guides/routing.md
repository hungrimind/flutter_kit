# Manage App Navigation

Routing is implemented with [`go_router`](https://pub.dev/packages/go_router) and a thin `RouterService` wrapper so navigation can still be triggered from ViewModels without passing `BuildContext` around.

This gives you URL synchronization and deep linking on web, while keeping navigation logic simple and testable.

## Default Routes

The boilerplate comes with two routes which should always exist:

- `/` - The home page.
- `/404` - The 404 page, when a route is not found.

```dart
// route_config.dart
final routes = [
  GoRoute(
    path: RoutePaths.home,
    pageBuilder: (context, state) => _buildPage(const HomeView(), state),
  ),
  GoRoute(
    path: RoutePaths.notFound,
    pageBuilder: (context, state) => _buildPage(const NotFoundView(), state),
  ),
];
```

## Adding a New Route

Add new routes using `GoRoute`.

```dart
GoRoute(
  path: '/new-route',
  pageBuilder: (context, state) => _buildPage(const NewRouteView(), state),
),
```

Dynamic route params use `:` in the path.

```dart
GoRoute(
  path: '/new-route/:id',
  pageBuilder: (context, state) {
    final id = state.pathParameters['id'];
    return _buildPage(NewRouteView(id: id), state);
  },
),
```

Use nested routes for parent-child relationships. Child routes should use relative paths (no leading `/`).

## Using a Route

`RouterService` exposes go_router-aligned methods only.

### go

Default navigation method. Updates the URL and rebuilds stack from route hierarchy.

```dart
locator<RouterService>().go('/new-route');
```

### push

Pushes a temporary page/flow on top of the stack.

```dart
locator<RouterService>().push('/new-route');
```

### replace

To replace the current route, you can use the `replace` method.

```dart
locator<RouterService>().replace('/new-route');
```

### canPop and pop

Back navigation checks are available through `canPop()`.

```dart
if (locator<RouterService>().canPop()) {
  locator<RouterService>().pop();
}
```

## Passing Data to a Route

There are 3 common ways to pass data.

### Path Parameters

As shown above, dynamic segments become `pathParameters`.

```dart
// configure the route in route_config.dart
GoRoute(
  path: '/todos/:id',
  pageBuilder: (context, state) {
    final id = state.pathParameters['id'];
    return _buildPage(TodoView(id: id), state);
  },
),

// go to the route
locator<RouterService>().go('/todos/123');
```

### Query Parameters

You can also pass data in the URL query string.

```dart
// configure the route in route_config.dart
GoRoute(
  path: '/todos',
  pageBuilder: (context, state) {
    final id = state.uri.queryParameters['id'];
    return _buildPage(TodoView(id: id), state);
  },
),

// go to the route
locator<RouterService>().go('/todos?id=123');
```

### Extra

For non-URL data, pass a typed object using `extra`.

```dart
// configure the route in route_config.dart
GoRoute(
  path: '/todos',
  pageBuilder: (context, state) {
    final todo = state.extra as Todo;
    return _buildPage(TodoView(id: todo.id, name: todo.name), state);
  },
),

// go to the route
locator<RouterService>().go('/todos', extra: Todo(id: '123', name: 'Test'));
```

## Automatic Routing Depending on Auth

For auth-based navigation, keep guard logic in router configuration instead of scattering checks across ViewModels.

Pass auth-aware routing hooks into `RouterService`:

- `redirect` for auth guard decisions (for example login-gated routes)
- `refreshListenable` so auth state changes trigger redirect re-evaluation

This keeps auth routing centralized while still using `RouterService` methods (`go`, `push`, `replace`, `pop`) for normal app navigation.

Unknown routes are redirected to `/404` through the router exception handler with a loop guard, so you get a stable not-found flow without manual stack management.
