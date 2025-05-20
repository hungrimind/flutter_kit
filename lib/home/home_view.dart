import 'package:flutter/material.dart';
import 'package:flutter_kit/core/ui/app_theme.dart';
import 'package:flutter_kit/core/utils/side_effects/side_effect_listener.dart';
import 'package:flutter_kit/core/utils/side_effects/toast/toast_events.dart';
import 'package:flutter_kit/core/utils/side_effects/toast/toast_overlay.dart';
import 'package:flutter_kit/home/home_view_model.dart';
import 'package:flutter_kit/core/utils/l10n/translate_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel = HomeViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SideEffectListener<ToastEvent>(
      valueListenable: _viewModel.sideEffectNotifier<ToastEvent>(),
      onEvent: (context, event) {
        switch (event) {
          case ToastEventCounterIsNow _:
            ToastOverlay.of(
              context,
            )?.showToast('Counter is now ${event.value}');
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('MVVM Counter')),
        body: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: _viewModel.counter,
            builder: (context, count, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.translate.counter,
                    textAlign: TextAlign.center,
                    style: context.textStyles.standard,
                  ),
                  Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: context.textStyles.xxxl,
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _viewModel.increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
