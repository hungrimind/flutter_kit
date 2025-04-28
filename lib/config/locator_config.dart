import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/utils/http/http_abstraction.dart';
import 'package:flutter_kit/core/utils/http/http_interceptor.dart';
import 'package:flutter_kit/config/route_config.dart';
import 'package:flutter_kit/core/services/logging_service.dart';
import 'package:flutter_kit/core/services/toast_service.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/core/utils/navigation/router_service.dart';

void setupLocator() {
  locator
      .registerSingleton<RouterService>(RouterService(supportedRoutes: routes));
  locator.registerSingleton<LoggingService>(LoggingService());
  locator.registerLazySingleton<ToastService>(() => ToastService());

  // Create HttpAbstraction with logging interceptor
  locator.registerLazySingleton<HttpAbstraction>(() {
    final httpAbstraction = HttpAbstraction();

    // Add logging interceptor
    httpAbstraction.addInterceptor(
      HttpLoggingInterceptor(
        logBody: !kReleaseMode, // Only log bodies in debug mode
      ),
    );

    return httpAbstraction;
  });
}