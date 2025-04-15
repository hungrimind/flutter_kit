import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/router_service.dart';

class AppRouterDelegate extends RouterDelegate<DefaultRoute> with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate() {
    routerService.navigationStack.addListener(notifyListeners);
  }

  final routerService = locator.get<RouterService>();

  List<Page<dynamic>> createPages() {
    List<Page<dynamic>> pages = [];
    for (var page in routerService.navigationStack.value) {

      pages.add(
        MaterialPage(child: page.builder.call(
          ValueKey<String>(page.label ?? '')
          page.label,
          page,
        )!),

        // MaterialPage(
        //   key: ValueKey(
        //     'Page_${page.label}_${page.?['id'] ?? ''}',
        //   ), // Ensure unique key for details pages
        //   child: page.builder,
        // ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> pages = createPages();

    print('pages: ${pages.map((page) => page.key)}');
    return Navigator(
      key: navigatorKey, // Navigator still needs a key
      pages: List.of(pages), // Use a copy to ensure change detection
      onDidRemovePage: (Page page) {
        if (routerService.justPopped) {
          routerService.justPopped = false;
        } else {
          routerService.navigateBack();
        }
      },
    );
  }

  // Called by the Router when the system wants to pop the current route.
  @override
  Future<bool> popRoute() {
    // Check if our internal router service can pop
    if (routerService.canPop()) {
      // If yes, trigger the pop in our state management
      routerService.navigateBack();
      // Return true to indicate we handled the pop.
      return SynchronousFuture(true);
    }
    // If no, indicate that the navigator refused the pop.
    // This might close the app on Android or do nothing on web/desktop.
    return SynchronousFuture(false);
  }

  // Report the current route configuration back to the Router
  @override
  AppRoute? get currentConfiguration {
    // If the stack is empty, return null or a default configuration
    if (routerService.navigationStack.value.isEmpty) {
      return null; // Or AppRoute(RouteNames.home) if you always want a default
    }
    // Return the configuration of the last page in the stack
    return routerService.navigationStack.value.last;
  }

  // Called by the Router when the platform reports a new route information.
  // This can happen from browser back/forward, typing URL, or platform calls.
  @override
  Future<void> setNewRoutePath(DefaultRoute configuration) async {
    routerService.navigateTo(configuration.label);
  }

  // dispose remains the same
  @override
  void dispose() {
    routerService.navigationStack.removeListener(notifyListeners);
    super.dispose();
  }
}
