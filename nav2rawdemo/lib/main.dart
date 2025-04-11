import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/route_information_parser.dart';
import 'package:nav2demo/core/navigation/router_delegate.dart';
import 'package:nav2demo/core/navigation/router_service.dart';
// Import your Delegate, Parser, Notifier, and other necessary files

void main() {
  setupLocator();
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouterDelegate _routerDelegate;
  late AppRouteInformationParser _routeInformationParser;
  // BackButtonDispatcher is often implicitly handled by MaterialApp.router
  // when using PopNavigatorRouterDelegateMixin, but you can provide your own if needed.
  // late PlatformBackButtonDispatcher _backButtonDispatcher; // Example

  @override
  void initState() {
    super.initState();
    _routeInformationParser = AppRouteInformationParser();
    // Pass the SINGLE instance of the notifier to the delegate
    _routerDelegate = AppRouterDelegate(
      locator.get<RouterService>().navigationState,
    );
    // _backButtonDispatcher = PlatformBackButtonDispatcher(); // If customizing
  }

  @override
  void dispose() {
    _routerDelegate.dispose(); // Dispose the delegate to remove listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Navigator 2.0 Demo',
      routeInformationParser: _routeInformationParser,
      routerDelegate: _routerDelegate,
      // Optional: Provide a custom back button dispatcher if needed.
      // If not provided, MaterialApp.router usually sets one up that works
      // with PopNavigatorRouterDelegateMixin. RootBackButtonDispatcher is common.
      // backButtonDispatcher: RootBackButtonDispatcher(),
      debugShowCheckedModeBanner: false,
    );
  }
}
