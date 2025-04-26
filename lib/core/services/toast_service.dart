import 'package:flutter/material.dart';

class ToastMessage {
  final String message;
  final Duration duration;
  final VoidCallback? onUndo;

  ToastMessage(
    this.message, {
    this.duration = const Duration(seconds: 4),
    this.onUndo,
  });
}

class ToastService {
  final ValueNotifier<ToastMessage?> _toastNotifier = ValueNotifier(null);
  ValueNotifier<ToastMessage?> get toastNotifier => _toastNotifier;

  void show(String message, {Duration? duration, VoidCallback? onUndo}) {
    _toastNotifier.value = ToastMessage(
      message,
      duration: duration ?? const Duration(seconds: 4),
      onUndo: onUndo,
    );
  }

  void dispose() {
    _toastNotifier.dispose();
  }
}
