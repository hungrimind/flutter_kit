import 'package:flutter/material.dart';
import 'package:flutter_kit/startup/startup_view.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const StartupView());
}
