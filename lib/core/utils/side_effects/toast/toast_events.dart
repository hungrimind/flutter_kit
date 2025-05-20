sealed class ToastEvent {}

class ToastEventCounterIsNow extends ToastEvent {
  final int value;

  ToastEventCounterIsNow({required this.value});
}
