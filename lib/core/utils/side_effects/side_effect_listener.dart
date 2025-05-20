import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SideEffectListener<T> extends StatefulWidget {
  const SideEffectListener({
    super.key,
    required this.valueListenable,
    required this.onEvent,
    required this.child,
  });

  final ValueListenable<T?> valueListenable;
  final void Function(BuildContext context, T event) onEvent;
  final Widget child;

  @override
  State<SideEffectListener<T>> createState() => _SideEffectListenerState<T>();
}

class _SideEffectListenerState<T> extends State<SideEffectListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.valueListenable.addListener(_listener);
    _checkInitialEvent();
  }

  void _checkInitialEvent() {
    final event = widget.valueListenable.value;
    if (event != null) {
      widget.onEvent(context, event);
    }
  }

  @override
  void didUpdateWidget(covariant SideEffectListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueListenable != oldWidget.valueListenable) {
      oldWidget.valueListenable.removeListener(_listener);
      widget.valueListenable.addListener(_listener);
      _checkInitialEvent();
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    final event = widget.valueListenable.value;
    if (event != null) {
      widget.onEvent(context, event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
