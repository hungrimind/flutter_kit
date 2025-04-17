import 'package:flutter_kit/navigation/router_service.dart';

class NotFoundViewModel {
  final RouterService _routerService;

  NotFoundViewModel({
    required RouterService routerService,
  }) : _routerService = routerService;

  void navigateToHome() {
    _routerService.replaceAll('/');
  }
} 