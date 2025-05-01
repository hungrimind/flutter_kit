import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/utils/http/http_abstraction.dart';
import 'package:flutter_kit/core/utils/http/http_interceptor.dart';
import 'package:flutter_kit/config/route_config.dart';
import 'package:flutter_kit/core/utils/toast/toast_service.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/core/utils/navigation/router_service.dart';

final modules = [
  Module<RouterService>(
    builder: () => RouterService(supportedRoutes: routes),
    lazy: false,
  ),
  Module<ToastService>(builder: () => ToastService(), lazy: true),
  Module<HttpAbstraction>(
    builder:
        () => HttpAbstraction(
          interceptors: [
            LoggingInterceptor(
              logBody: !kReleaseMode, // Only log bodies in debug mode
            ),
          ],
        ),
    lazy: true,
  ),
];
