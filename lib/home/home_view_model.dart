import 'package:flutter/foundation.dart';
import 'package:flutter_kit/core/utils/disposable.dart';
import 'package:flutter_kit/core/utils/side_effects/side_effects.dart';
import 'package:flutter_kit/core/utils/side_effects/toast/toast_events.dart';

class HomeViewModel extends Disposable with SideEffects {
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  void increment() {
    counter.value++;

    if (counter.value % 10 == 0) {
      notifySideEffect<ToastEvent>(
        ToastEventCounterIsNow(value: counter.value),
      );
    }
  }

  @override
  void dispose() {
    counter.dispose();
    super.dispose();
  }
}
