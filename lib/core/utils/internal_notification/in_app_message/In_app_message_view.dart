import 'package:flutter/material.dart';
import 'package:flutter_kit/core/ui/app_theme.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/core/utils/internal_notification/notify_service.dart';
import 'package:flutter_kit/core/utils/internal_notification/in_app_message/in_app_message_event.dart';
import 'package:flutter_kit/core/utils/internal_notification/in_app_message/in_app_message_view_model.dart';

class InAppMessageView extends StatefulWidget {
  final Widget child;

  const InAppMessageView({super.key, required this.child});

  @override
  State<InAppMessageView> createState() => _InAppMessageViewState();
}

class _InAppMessageViewState extends State<InAppMessageView> {
  late final InAppMessageViewModel _viewModel = InAppMessageViewModel(
    notifyService: locator<NotifyService>(),
  );

  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.inAppMessageEvent.addListener(_onToastEventChanged);
  }

  @override
  void dispose() {
    _viewModel.inAppMessageEvent.removeListener(_onToastEventChanged);
    super.dispose();
  }

  void _onToastEventChanged() {
    final toastEvent = _viewModel.inAppMessageEvent.value;
    if (toastEvent != null) {
      Future.delayed(toastEvent.duration, () {
        if (mounted && _viewModel.inAppMessageEvent.value == toastEvent) {
          _viewModel.clearInAppMessageEvent();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<InAppMessageEvent?>(
            valueListenable: _viewModel.inAppMessageEvent,
            builder: (context, toastEvent, _) {
              return AnimatedSwitcher(
                duration: context.durations.duration200,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                          reverseCurve: Curves.easeIn,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child:
                    toastEvent == null
                        ? const SizedBox.shrink()
                        : _Toast(
                          key: ValueKey(toastEvent),
                          toastEvent: toastEvent,
                          onDismiss: () {
                            _viewModel.clearInAppMessageEvent();
                          },
                          onVerticalDragStart: (_) => _dragOffset = 0,
                          onVerticalDragUpdate: (details) {
                            _dragOffset += details.primaryDelta!;
                            if (_dragOffset < -20) {
                              _viewModel.clearInAppMessageEvent();
                            }
                          },
                        ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Toast extends StatelessWidget {
  final InAppMessageEvent toastEvent;
  final VoidCallback onDismiss;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;

  const _Toast({
    super.key,
    required this.toastEvent,
    required this.onDismiss,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.breakpoints.sm),
          child: GestureDetector(
            onVerticalDragStart: onVerticalDragStart,
            onVerticalDragUpdate: onVerticalDragUpdate,
            child: Container(
              margin: EdgeInsets.all(context.spacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: switch (toastEvent) {
                    InAppSuccessEvent() =>
                      isDark
                          ? context.greenColors.green900
                          : context.greenColors.green200,
                    InAppErrorEvent() =>
                      isDark
                          ? context.redColors.red900
                          : context.redColors.red200,
                    InAppWarningEvent() =>
                      isDark
                          ? context.yellowColors.yellow900
                          : context.yellowColors.yellow200,
                    InAppInfoEvent() =>
                      isDark
                          ? context.neutralColors.neutral900
                          : context.neutralColors.neutral200,
                  },
                  width: 1,
                ),
                borderRadius: context.borderRadius.md,
                boxShadow: context.shadows.md,
              ),
              child: Material(
                color: switch (toastEvent) {
                  InAppSuccessEvent() =>
                    isDark
                        ? context.greenColors.green800
                        : context.greenColors.green100,
                  InAppErrorEvent() =>
                    isDark
                        ? context.redColors.red800
                        : context.redColors.red100,
                  InAppWarningEvent() =>
                    isDark
                        ? context.yellowColors.yellow800
                        : context.yellowColors.yellow100,
                  InAppInfoEvent() =>
                    isDark
                        ? context.neutralColors.neutral800
                        : context.neutralColors.neutral100,
                },
                borderRadius: context.borderRadius.md,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.xl,
                    vertical: context.spacing.md,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          toastEvent.message,
                          style: context.textStyles.standard,
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
    );
  }
}
