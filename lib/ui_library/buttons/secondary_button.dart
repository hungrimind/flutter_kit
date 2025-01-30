import 'package:flutter/material.dart';
import 'package:flutter_kit/ui_library/mixins/loading_state_mixin.dart';
import 'package:flutter_kit/ui_library/theme/neutral_colors.dart';
import 'package:flutter_kit/ui_library/widgets/loading_indicator.dart';

class SecondaryButton extends StatefulWidget {
  final Widget text;
  final Future<void> Function() onPressed;
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.padding,
    this.margin,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with LoadingStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        return MouseRegion(
          cursor: loading ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: Material(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
            child: Stack(
              children: [
                InkWell(
                  onTap: loading ? null : () => withLoading(widget.onPressed),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    alignment: Alignment.center,
                    width: widget.width,
                    margin: widget.margin,
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                    child: widget.text,
                  ),
                ),
                if (loading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: LoadingIndicator(
                          size: 20,
                          strokeWidth: 2.5,
                          color: Theme.of(context)
                              .extension<NeutralColors>()!
                              .neutral50,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
