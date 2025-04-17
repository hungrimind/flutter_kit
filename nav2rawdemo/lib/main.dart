import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/navigation/route_information_parser.dart';
import 'package:nav2demo/navigation/router_delegate.dart';
import 'package:nav2demo/navigation/router_service.dart';
import 'package:nav2demo/navigation/url_strategy/url_strategy.dart';
import 'package:nav2demo/core/config/logging_navigation_observer.dart';
import 'package:nav2demo/pages/screens.dart';

// Import your Delegate, Parser, Notifier, and other necessary files
void main() {
  setupLocator();
  configureUrlStrategy();

  // Add navigation observer
  final routerService = locator.get<RouterService>();
  routerService.addObserver(LoggingNavigationObserver());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RouterConfig<Object> _routerConfig;

  @override
  void initState() {
    super.initState();
    _routerConfig = RouterConfig(
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(uri: Uri.parse('/')),
      ),
      routerDelegate: AppRouterDelegate(
        routerService: locator.get<RouterService>(),
      ),
      routeInformationParser: AppRouteInformationParser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _routerConfig);
  }
}
