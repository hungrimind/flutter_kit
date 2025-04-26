import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get appName => 'Flutter Kit';

  @override
  String get errorGeneric => 'Oops! Something went wrong';

  @override
  String get errorStartingApp =>
      'We encountered an error while starting the app.';

  @override
  String get retry => 'Retry';

  @override
  String get notFoundTitle => '404';

  @override
  String get notFoundMessage => 'Page Not Found';

  @override
  String get notFoundGoHome => 'Go Home';
}
