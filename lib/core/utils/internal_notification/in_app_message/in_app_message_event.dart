sealed class InAppMessageEvent {
  final Duration duration;
  final String message;

  InAppMessageEvent({
    required this.message,
    this.duration = const Duration(seconds: 4),
  });
}

class InAppSuccessEvent extends InAppMessageEvent {
  InAppSuccessEvent({required super.message}) : super();
}

class InAppErrorEvent extends InAppMessageEvent {
  InAppErrorEvent({required super.message}) : super();
}

class InAppWarningEvent extends InAppMessageEvent {
  InAppWarningEvent({required super.message}) : super();
}

class InAppInfoEvent extends InAppMessageEvent {
  InAppInfoEvent({required super.message}) : super();
}
