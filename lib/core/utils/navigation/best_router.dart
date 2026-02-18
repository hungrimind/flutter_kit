import 'package:flutter/widgets.dart';
import 'package:flutter_kit/core/utils/navigation/router_service.dart';

class BestRouterConfig extends RouterConfig<Object> {
  BestRouterConfig({required RouterService routerService})
    : super(
        routerDelegate: routerService.goRouter.routerDelegate,
        routeInformationProvider: routerService.goRouter.routeInformationProvider,
        backButtonDispatcher: routerService.goRouter.backButtonDispatcher,
        routeInformationParser: routerService.goRouter.routeInformationParser,
      );
}
