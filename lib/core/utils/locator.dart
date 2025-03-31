import 'package:flutter/foundation.dart';

final locator = ServiceLocator.instance;

void setupLocator() {
  // Register your services here
}

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, Lazy<Object>> _lazySingletons = {};

  void registerSingleton<T extends Object>(T Function() create) {
    _lazySingletons[T] = Lazy<Object>(create);
  }

  T get<T extends Object>() {
    final lazy = _lazySingletons[T];
    if (lazy == null) {
      throw Exception('No singleton registered for type $T');
    }
    return lazy.value as T;
  }

  void reset() {
    _lazySingletons.clear();
  }

  @visibleForTesting
  bool isRegistered<T extends Object>() => _lazySingletons.containsKey(T);
}

class Lazy<T> {
  Lazy(this._create);

  final T Function() _create;
  T? _value;

  T get value => _value ??= _create();
}
