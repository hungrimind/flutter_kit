import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'core/navigation/app_router.dart';

void main() {
  // Configure url strategy for web
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final routeInformationParser = AppRouteInformationParser();

    return MaterialApp.router(
      title: 'Navigator 2.0 Raw Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: RouterConfig<RouteConfig>(
        routeInformationParser: routeInformationParser,
        routerDelegate: appRouter,
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: const RouteInformation(location: '/'),
        ),
      ),
    );
  }
}

/// Parses route information from the platform
class AppRouteInformationParser extends RouteInformationParser<RouteConfig> {
  @override
  Future<RouteConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location ?? '/');
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) {
      return const RouteConfig(route: AppRoute.home);
    }

    switch (pathSegments[0]) {
      case 'page2':
        if (pathSegments.length > 1 && pathSegments[1] == 'details') {
          return const RouteConfig(route: AppRoute.page2Details);
        }
        return const RouteConfig(route: AppRoute.page2);
      case 'page3':
        if (pathSegments.length > 1) {
          return RouteConfig(
            route: AppRoute.page3WithId,
            params: {'id': pathSegments[1]},
          );
        }
        return const RouteConfig(route: AppRoute.page3);
      default:
        return const RouteConfig(route: AppRoute.home);
    }
  }

  @override
  RouteInformation? restoreRouteInformation(RouteConfig configuration) {
    switch (configuration.route) {
      case AppRoute.home:
        return const RouteInformation(location: '/');
      case AppRoute.page2:
        return const RouteInformation(location: '/page2');
      case AppRoute.page2Details:
        return const RouteInformation(location: '/page2/details');
      case AppRoute.page3:
        return const RouteInformation(location: '/page3');
      case AppRoute.page3WithId:
        return RouteInformation(
          location: '/page3/${configuration.params['id']}',
        );
    }
  }
}

// This is a simple implementation using go_router package
// For a more complex implementation with custom RouterDelegate, see the commented code below
