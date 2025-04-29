import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/navigation/url_strategy/url_strategy.dart';
import 'package:flutter_kit/startup/startup_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  runApp(const StartupView());
}
