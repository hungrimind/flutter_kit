import 'package:go_router/go_router.dart';

/// Service responsible for context-free navigation in view models.
class RouterService {
  RouterService({required this.routes, this.initialLocation = '/'})
    : goRouter = GoRouter(
        routes: routes,
        initialLocation: initialLocation,
        onException: (context, state, router) {
          if (state.uri.path != '/404') {
            router.go('/404');
          }
        },
      );

  final List<RouteBase> routes;
  final String initialLocation;
  final GoRouter goRouter;

  void goTo(String location, {Object? extra}) {
    goRouter.push(location, extra: extra);
  }

  void replace(String location, {Object? extra}) {
    goRouter.replace(location, extra: extra);
  }

  void back() {
    if (!goRouter.canPop()) {
      return;
    }
    goRouter.pop();
  }

  void replaceAll(List<String> locations) {
    if (locations.isEmpty) {
      return;
    }

    goRouter.go(locations.first);
    for (final location in locations.skip(1)) {
      goRouter.push(location);
    }
  }

  void backUntil(String location) {
    goRouter.go(location);
  }

  void remove(String location) {
    final targetPath = Uri.parse(location).path;
    if (goRouter.state.uri.path == targetPath && goRouter.canPop()) {
      goRouter.pop();
    }
  }
}
