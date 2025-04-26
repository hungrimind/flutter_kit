import 'package:flutter/material.dart';
import 'package:flutter_kit/core/services/toast_service.dart';
import 'package:flutter_kit/core/utils/locator.dart';

class ToastOverlay extends StatefulWidget {
  final Widget child;

  const ToastOverlay({
    super.key,
    required this.child,
  });

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> {
  final toastService = locator.get<ToastService>();
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<ToastMessage?>(
            valueListenable: toastService.toastNotifier,
            builder: (context, toastMessage, _) {
              if (toastMessage != null) {
                Future.delayed(toastMessage.duration, () {
                  if (toastService.toastNotifier.value == toastMessage) {
                    toastService.toastNotifier.value = null;
                  }
                });
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                        reverseCurve: Curves.easeIn,
                      )),
                      child: child,
                    ),
                  );
                },
                child: toastMessage == null
                    ? const SizedBox.shrink()
                    : SafeArea(
                        key: ValueKey(toastMessage.message),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: GestureDetector(
                              onVerticalDragStart: (_) => _dragOffset = 0,
                              onVerticalDragUpdate: (details) {
                                _dragOffset += details.primaryDelta!;
                                if (_dragOffset < -20) {
                                  toastService.toastNotifier.value = null;
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: .2),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: .05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            toastMessage.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        if (toastMessage.onUndo != null)
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                            ),
                                            onPressed: () {
                                              toastMessage.onUndo?.call();
                                              toastService.toastNotifier.value =
                                                  null;
                                            },
                                            child: Text(
                                              'Undo',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
