import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_kit/navigation/route_information_parser.dart';
import 'package:flutter_kit/navigation/router_delegate.dart';
import 'package:flutter_kit/navigation/router_service.dart';

class BestRouterConfig extends RouterConfig<Object> {
  BestRouterConfig({required RouterService routerService})
    : super(
        routerDelegate: AppRouterDelegate(routerService: routerService),
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(
            uri: Uri.parse(PlatformDispatcher.instance.defaultRouteName),
          ),
        ),
        routeInformationParser: AppRouteInformationParser(
          routes: routerService.supportedRoutes,
        ),
      );
}
