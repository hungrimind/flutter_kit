import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/utils/disposable.dart';

mixin ToastMessenger<E> on Disposable {
  final ValueNotifier<E?> _toastEvent = ValueNotifier<E?>(null);

  ValueNotifier<E?> get toastEvent => _toastEvent;

  void notifyToast(E event) {
    _toastEvent.value = event;
  }

  void _disposeToastResources() {
    _toastEvent.dispose();
  }

  @override
  @mustCallSuper
  void dispose() {
    _disposeToastResources();
    super.dispose();
  }
}
