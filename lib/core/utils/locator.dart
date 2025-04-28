final locator = ModuleLocator.instance;

class Module<T> {
  final T Function() builder;
  final bool lazy;
  Type get type => T;

  T? _instance;

  Module({
    required this.builder,
    required this.lazy,
  });

  T getInstance() {
    if (lazy) {
      _instance ??= builder();
      return _instance!;
    } else {
      return builder();
    }
  }
}

class ModuleLocator {
  ModuleLocator._();
  static final ModuleLocator instance = ModuleLocator._();
  final Map<Type, Module> _modules = {};

  void registerMany<T>(List<Module> modules) {
    for (var module in modules) {
      final type = module.type;
      if (_modules.containsKey(type)) {
        throw ModuleAlreadyRegisteredException(type);
      }
      _modules[type] = module;

      if (!module.lazy) {
        module.getInstance();
      }
    }
  }

  T call<T>() {
    final module = _modules[T];
    if (module == null) {
      throw ModuleNotFoundException(T);
    }
    return (module as Module<T>).getInstance();
  }

  void reset() {
    _modules.clear();
  }
}

class ModuleNotFoundException implements Exception {
  final Type type;
  ModuleNotFoundException(this.type);
}

class ModuleAlreadyRegisteredException implements Exception {
  final Type type;
  ModuleAlreadyRegisteredException(this.type);
}
