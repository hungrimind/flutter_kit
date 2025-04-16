import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:nav2demo/core/locator.dart';
import 'package:nav2demo/core/navigation/internals/route_information_parser.dart';
import 'package:nav2demo/core/navigation/internals/router_delegate.dart';
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

  @override
  void initState() {
    super.initState();
    _routeInformationParser = AppRouteInformationParser();
    _routerDelegate = AppRouterDelegate();
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Navigator 2.0 Demo',
      routeInformationParser: _routeInformationParser,
      routerDelegate: _routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
