import 'package:flutter/material.dart';
import 'package:flutter_kit/auth/login/login_page.dart';
import 'package:flutter_kit/auth/user_service.dart';
import 'package:flutter_kit/core/abstractions/sqlite_abstraction.dart';
import 'package:flutter_kit/core/ui/theme/app_theme.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  await locator.get<SqliteAbstraction>().loadSqlite();
  locator.get<UserService>().checkForSession();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final UserService userService = locator.get<UserService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(Brightness.light),
      darkTheme: AppTheme.buildTheme(Brightness.dark),
      home: ValueListenableBuilder(
        valueListenable: userService.userNotifier,
        builder: (context, user, child) {
          if (user == null) {
            return const LoginPage(title: 'Login');
          }
          return const HomePage();
        },
      ),
    );
  }
}
