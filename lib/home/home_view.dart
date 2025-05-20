import 'package:flutter/material.dart';
import 'package:flutter_kit/core/ui/app_theme.dart';
import 'package:flutter_kit/core/utils/toast/event_value_listener.dart';
import 'package:flutter_kit/core/utils/toast/toast_overlay.dart';
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
    return EventValueListener<HomeToastEvent>(
      valueListenable: _viewModel.toastEvent,
      onEvent: (context, event) {
        switch (event) {
          case HomeToastEventCounterIsNow _:
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
