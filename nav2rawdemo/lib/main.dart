import 'package:flutter/material.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/navigation/best_router.dart';
import 'package:nav2demo/navigation/router_service.dart';
import 'package:nav2demo/navigation/url_strategy/url_strategy.dart';
import 'package:nav2demo/core/config/logging_navigation_observer.dart';

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
  late BestRouterConfig _bestRouterConfig;

  @override
  void initState() {
    super.initState();
    _bestRouterConfig = BestRouterConfig(
      routerService: locator.get<RouterService>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _bestRouterConfig,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Set the predictive back transitions for Android.
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}
