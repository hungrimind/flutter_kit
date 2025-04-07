import 'package:flutter/material.dart';
import 'package:flutter_kit/core/constants/project_info.dart';
import 'package:flutter_kit/core/router/router.dart';
import 'package:flutter_kit/core/ui/theme/app_theme.dart';
import 'package:flutter_kit/core/widgets/toast_overlay.dart';
import 'package:flutter_kit/startup_view_model.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  late final StartupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StartupViewModel();
    _viewModel.initializeApp();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppState>(
      valueListenable: _viewModel.appStateNotifier,
      builder: (context, state, _) {
        return switch (state) {
          InitializingApp() => MaterialApp(
              title: ProjectInfo.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.buildTheme(Brightness.light),
              darkTheme: AppTheme.buildTheme(Brightness.dark),
              home: ToastOverlay(
                child: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          AppInitialized() => MaterialApp.router(
              routerConfig: router,
              title: ProjectInfo.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.buildTheme(Brightness.light),
              darkTheme: AppTheme.buildTheme(Brightness.dark),
              builder: (context, child) => ToastOverlay(child: child!),
            ),
          AppInitializationError(message: final error) => MaterialApp(
              title: ProjectInfo.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.buildTheme(Brightness.light),
              darkTheme: AppTheme.buildTheme(Brightness.dark),
              home: ToastOverlay(
                child: Scaffold(
                  body: Center(
                    child: Text('Error initializing app: $error'),
                  ),
                ),
              ),
            ),
        };
      },
    );
  }
}

