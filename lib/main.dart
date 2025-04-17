import 'package:flutter/material.dart';
import 'package:flutter_kit/navigation/url_strategy/url_strategy.dart';
import 'package:flutter_kit/startup/startup.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  runApp(const StartupView());
}
