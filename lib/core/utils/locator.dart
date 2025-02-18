import 'package:flutter/foundation.dart';
import 'package:flutter_kit/auth/user_service.dart';
import 'package:flutter_kit/core/abstractions/sqlite_abstraction.dart';

final locator = ServiceLocator.instance;

void setupLocator() {
  locator.registerSingleton(() => SqliteAbstraction());

  locator.registerSingleton(
    () => UserService(
      sqliteAbstraction: locator.get<SqliteAbstraction>(),
    ),
  );
}

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, _ServiceFactory> _factories = {};
  final Map<Type, Object> _singletons = {};

  void registerFactory<T extends Object>(T Function() factory) {
    _factories[T] = _ServiceFactory(factory, singleton: false);
  }

  void registerSingleton<T extends Object>(T Function() factory) {
    _factories[T] = _ServiceFactory(factory, singleton: true);
  }

  T get<T extends Object>() {
    final factory = _factories[T];
    if (factory == null) {
      throw Exception('No factory registered for type $T');
    }

    if (factory.singleton) {
      return (_singletons[T] ??= factory.create()) as T;
    }

    return factory.create() as T;
  }

  void reset() {
    _factories.clear();
    _singletons.clear();
  }

  @visibleForTesting
  bool isRegistered<T extends Object>() => _factories.containsKey(T);
}

class _ServiceFactory {
  final Object Function() create;
  final bool singleton;

  const _ServiceFactory(this.create, {required this.singleton});
}
