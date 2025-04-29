import 'package:flutter_kit/core/utils/navigation/route_data.dart';

abstract class NavigationObserver {
  void onPush(RouteMatchData route);
  void onPop(RouteMatchData route);
  void onReplace(RouteMatchData route);
  void onRemove(RouteMatchData route);
}

mixin ObservableRouter {
  final List<NavigationObserver> _observers = [];

  void addObserver(NavigationObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(NavigationObserver observer) {
    _observers.remove(observer);
  }

  void notifyPush(RouteMatchData route) {
    for (final observer in _observers) {
      observer.onPush(route);
    }
  }

  void notifyPop(RouteMatchData route) {
    for (final observer in _observers) {
      observer.onPop(route);
    }
  }

  void notifyReplace(List<RouteMatchData> routes) {
    for (final observer in _observers) {
      for (final route in routes) {
        observer.onReplace(route);
      }
    }
  }

  void notifyRemove(RouteMatchData route) {
    for (final observer in _observers) {
      observer.onRemove(route);
    }
  }
}
