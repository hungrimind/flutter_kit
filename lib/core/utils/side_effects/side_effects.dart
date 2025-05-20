import 'package:flutter/widgets.dart';
import 'package:flutter_kit/core/utils/disposable.dart';

mixin SideEffects on Disposable {
  final Map<Type, ValueNotifier<dynamic>> _sideEffectNotifiers = {};

  ValueNotifier<T?> sideEffectNotifier<T>() {
    final notifier = _sideEffectNotifiers[T] as ValueNotifier<T?>?;
    if (notifier == null) {
      final newNotifier = ValueNotifier<T?>(null);
      _sideEffectNotifiers[T] = newNotifier;
      return newNotifier;
    }
    return notifier;
  }

  void notifySideEffect<T>(T sideEffect) {
    final notifier = sideEffectNotifier<T>();
    notifier.value = sideEffect;
  }

  void _disposeSideEffectResources() {
    for (var notifier in _sideEffectNotifiers.values) {
      notifier.dispose();
    }
    _sideEffectNotifiers.clear();
  }

  @override
  @mustCallSuper
  void dispose() {
    _disposeSideEffectResources();
    super.dispose();
  }
}
