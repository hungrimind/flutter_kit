import 'package:flutter/material.dart';
import 'package:flutter_kit/core/ui/theme/app_theme.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/home/home_view.dart';
import 'package:flutter_kit/core/services/logging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  
  // Initialize logging
  locator.get<LoggingService>().initializeLogging();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(Brightness.light),
      darkTheme: AppTheme.buildTheme(Brightness.dark),
      home: const HomeView(),
    );
  }
}
