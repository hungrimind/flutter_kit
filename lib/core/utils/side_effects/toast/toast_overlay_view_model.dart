import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ToastMessage {
  final String message;
  final Duration duration;

  ToastMessage(this.message, {this.duration = const Duration(seconds: 4)});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToastMessage &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          duration == other.duration;

  @override
  int get hashCode => message.hashCode ^ duration.hashCode;
}

class ToastOverlayViewModel {
  final ValueNotifier<ToastMessage?> _toastNotifier = ValueNotifier(null);
  ValueNotifier<ToastMessage?> get toastNotifier => _toastNotifier;

  void showToast(String message, {Duration? duration}) {
    _toastNotifier.value = ToastMessage(
      message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void clearToast() {
    _toastNotifier.value = null;
  }

  void dispose() {
    _toastNotifier.dispose();
  }
}
