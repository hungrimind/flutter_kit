import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/utils/disposable.dart';
import 'package:flutter_kit/core/utils/toast/toast_messenger.dart';

sealed class HomeToastEvent {}

class HomeToastEventCounterIsNow extends HomeToastEvent {
  final int value;

  HomeToastEventCounterIsNow({required this.value});
}

class HomeViewModel extends Disposable with ToastMessenger<HomeToastEvent> {
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  void increment() {
    counter.value++;

    if (counter.value % 10 == 0) {
      notifyToast(HomeToastEventCounterIsNow(value: counter.value));
    }
  }

  @override
  void dispose() {
    counter.dispose();
    super.dispose();
  }
}
