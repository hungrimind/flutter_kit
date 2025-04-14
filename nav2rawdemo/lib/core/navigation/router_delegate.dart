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

  @override
  AppRoute get currentConfiguration => _navigationStateNotifier.value;

  var routerService = locator.get<RouterService>();

  @override
  Widget build(BuildContext context) {
    final state = _navigationStateNotifier.value;
    List<Page<dynamic>> pages = [];

    pages.add(
      MaterialPage(
        key: ValueKey('HomePage'),
        child: HomeScreen(routerService: routerService),
      ),
    );

    switch (state.name) {
      case RouteNames.home:
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
        pages.add(
          MaterialPage(
            key: ValueKey('BooksPage'),
            child: BooksScreen(routerService: routerService),
          ),
        );
        if (state.params != null) {
          pages.add(
            MaterialPage(
              key: ValueKey('BookDetailsPage_${state.params}'),
              child: BookDetailsScreen(bookId: state.params!['id']!),
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
