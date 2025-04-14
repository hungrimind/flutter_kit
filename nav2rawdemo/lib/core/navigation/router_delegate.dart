import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/navigation_state.dart';
import 'package:nav2demo/core/config/route_config.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
import 'package:nav2demo/pages/screens.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute> with ChangeNotifier {
  final ValueNotifier<AppRoute> _navigationStateNotifier;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate(this._navigationStateNotifier) {
    _navigationStateNotifier.addListener(notifyListeners);
  }

  var routerService = locator.get<RouterService>();

  createPages() {
    List<Page<dynamic>> pages = [];

    for (var page in routerService.navigationStack.value) {
      switch (page.name) {
        case RouteNames.home:
          pages.add(
            MaterialPage(
              key: ValueKey('HomePage'),
              child: HomeScreen(routerService: routerService),
            ),
          );
          break;
        case RouteNames.books:
          pages.add(
            MaterialPage(
              key: ValueKey('BooksPage'),
              child: BooksScreen(routerService: routerService),
            ),
          );
          break;
        case RouteNames.bookDetails:
          if (page.params != null) {
            pages.add(
              MaterialPage(
                key: ValueKey('BookDetailsPage_${page.params}'),
                child: BookDetailsScreen(bookId: page.params!['id']!),
              ),
            );
          }
          break;
        case RouteNames.settings:
          pages.add(
            const MaterialPage(
              key: ValueKey('SettingsPage'),
              child: SettingsScreen(),
            ),
          );
          break;
        case RouteNames.unknown:
        default:
          pages.add(
            const MaterialPage(
              key: ValueKey('UnknownPage'),
              child: UnknownScreen(),
            ),
          );
          break;
      }
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
        routerService.navigateBack();
      },
    );
  }

  @override
  Future<bool> popRoute() {
    return SynchronousFuture(false);
  }

  // setNewRoutePath remains the same
  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _navigationStateNotifier.value = configuration;
    return SynchronousFuture(null);
  }

  // dispose remains the same
  @override
  void dispose() {
    _navigationStateNotifier.removeListener(notifyListeners);
    super.dispose();
  }
}
