import 'package:flutter/material.dart';
import 'package:flutter_kit/core/services/toast_service.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/home/home_view_model.dart';
import 'package:flutter_kit/l10n/translate_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel = HomeViewModel(
    toastService: locator.get<ToastService>(),
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MVVM Counter'),
        elevation: 0,
      ),
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
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
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
    );
  }
}

