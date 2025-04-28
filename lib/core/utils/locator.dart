import 'package:flutter/foundation.dart';


final locator = ServiceLocator.instance;

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, Object> _singletons = {};
  final Map<Type, Lazy<Object>> _lazySingletons = {};

  void registerSingleton<T extends Object>(T instance) {
    _singletons[T] = instance;
  }

  void registerLazySingleton<T extends Object>(T Function() create) {
    _lazySingletons[T] = Lazy<Object>(create);
  }

  T get<T extends Object>() {
    final singleton = _singletons[T];
    if (singleton != null) {
      return singleton as T;
    }

    final lazy = _lazySingletons[T];
    if (lazy != null) {
      return lazy.value as T;
    }

    throw Exception('No singleton registered for type $T');
  }

  void reset() {
    _singletons.clear();
    _lazySingletons.clear();
  }

  @visibleForTesting
  bool isRegistered<T extends Object>() =>
      _singletons.containsKey(T) || _lazySingletons.containsKey(T);
}

class Lazy<T> {
  Lazy(this._create);

  final T Function() _create;
  T? _value;

  T get value => _value ??= _create();
}
