import 'package:flutter/foundation.dart';

sealed class HomeToastEvent {}

class HomeToastEventCounterIsNow extends HomeToastEvent {
  final int value;

  HomeToastEventCounterIsNow({required this.value});
}

class HomeViewModel {
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  final ValueNotifier<HomeToastEvent?> toastEvent =
      ValueNotifier<HomeToastEvent?>(null);

  void increment() {
    counter.value++;

    if (counter.value % 10 == 0) {
      toastEvent.value = HomeToastEventCounterIsNow(value: counter.value);
    }
  }

  void dispose() {
    counter.dispose();
  }
}
