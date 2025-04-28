import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/l10n/translate_extension.dart';
import 'package:flutter_kit/core/utils/navigation/router_service.dart';
import 'package:flutter_kit/not_found/not_found_view_model.dart';

class NotFoundView extends StatefulWidget {
  const NotFoundView({super.key});

  @override
  State<NotFoundView> createState() => _NotFoundViewState();
}

class _NotFoundViewState extends State<NotFoundView> {
  late final NotFoundViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotFoundViewModel(
      routerService: locator<RouterService>(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              context.translate.notFoundTitle,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.translate.notFoundMessage,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _viewModel.navigateToHome,
              child: Text(context.translate.notFoundGoHome),
            ),
          ],
        ),
      ),
    );
  }
}
