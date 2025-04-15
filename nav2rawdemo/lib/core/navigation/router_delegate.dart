import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/navigation/router_service.dart';

class AppRouterDelegate extends RouterDelegate<MyRouteSettings>
    with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate() {
    routerService.navigationStack.addListener(notifyListeners);
  }

  final routerService = locator.get<RouterService>();

  List<Page<dynamic>> createPages() {
    List<Page<dynamic>> pages = [];
    for (MyRouteSettings page in routerService.navigationStack.value) {
      Widget child = routes
          .firstWhere((route) => route.path == page.path)
          .builder!(ValueKey(page.path), page.path, page);
      pages.add(
        MaterialPage(
          key: ValueKey(
            'Page_${page.path}',
          ), // Ensure unique key for details pages
          child: child,
          canPop: routerService.canPop(page),
        ),
      );
    }
    print("Page Keys: ${pages.map((page) => page.key)}");
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> pages = createPages();

    return Navigator(
      key: navigatorKey,
      pages: List.of(pages),
      onDidRemovePage: (page) {
        routerService.navigateBack();
      },
    );
  }

  @override
  Future<bool> popRoute() {
    print("POP ROUTE CALLED!!!");
    return SynchronousFuture(false);
  }

  // Report the current route configuration back to the Router
  @override
  MyRouteSettings? get currentConfiguration {
    // If the stack is empty, return null or a default configuration
    print("CURRENT CONFIGURATION: ${routerService.navigationStack.value}");
    if (routerService.navigationStack.value.isEmpty) {
      return null; // Or AppRoute(RouteNames.home) if you always want a default
    }
    // Return the configuration of the last page in the stack
    return routerService.navigationStack.value.last;
  }

  // Called by the Router when the platform reports a new route information.
  // This can happen from browser back/forward, typing URL, or platform calls.
  @override
  Future<void> setNewRoutePath(MyRouteSettings configuration) async {
    print("SETTING NEW ROUTE PATH: $configuration");
    routerService.setPathStack(configuration);
  }

  // dispose remains the same
  @override
  void dispose() {
    routerService.navigationStack.removeListener(notifyListeners);
    super.dispose();
  }
}
