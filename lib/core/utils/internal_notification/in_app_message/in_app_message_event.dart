sealed class InAppMessageEvent {
  final Duration duration;
  final String message;

  InAppMessageEvent({
    required this.message,
    this.duration = const Duration(seconds: 4),
  });
}

class InAppSuccessEvent extends InAppMessageEvent {
  InAppSuccessEvent({required super.message});
}

class InAppErrorEvent extends InAppMessageEvent {
  InAppErrorEvent({required super.message});
}

class InAppWarningEvent extends InAppMessageEvent {
  InAppWarningEvent({required super.message});
}

class InAppInfoEvent extends InAppMessageEvent {
  InAppInfoEvent({required super.message});
}
