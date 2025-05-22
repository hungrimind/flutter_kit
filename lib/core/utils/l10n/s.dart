import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_kit/core/utils/l10n/app_localizations.dart'; // Provides lookupAppLocalizations

/// Static access to [AppLocalizations].
///
/// Usage:
/// 1. Initialize in `MaterialApp.builder`: `S.init(context);`
/// 2. Access translations from ViewModels/Services: `S.current.appName`
/// 3. Get current locale: `S.locale`
/// 4. Programmatically load a different locale: `await S.load(Locale('sv'));`
///    (Note: `S.load` updates `S.current` but does not rebuild UI globally.
///     For UI updates, manage `MaterialApp.locale` and let `S.init` refresh.)
class S {
  static AppLocalizations? _currentLocalizations;
  static Locale? _currentLocale;

  /// Initializes `S` with [AppLocalizations] from the given [context].
  /// Must be called once, typically in `MaterialApp.builder`.
  /// Also sets `intl.Intl.defaultLocale`.
  static void init(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      _currentLocalizations = localizations;
      _currentLocale = Locale(
        localizations.localeName,
      ); // Use canonicalized localeName
      intl.Intl.defaultLocale = localizations.localeName;
    } else {
      // This may occur if S.init is called before localizations are available.
      // Ensure AppLocalizations.delegate is in MaterialApp.localizationDelegates.
      debugPrint(
        'S.init(context): AppLocalizations.of(context) returned null. '
        'Verify MaterialApp setup and S.init call timing.',
      );
    }
  }

  /// The current [AppLocalizations] instance.
  /// Throws if `init` was not called or failed.
  static AppLocalizations get current {
    if (_currentLocalizations == null) {
      throw Exception(
        'S.current accessed before S.init(context) was successfully called. '
        'Ensure S.init(context) is called in your MaterialApp builder.',
      );
    }
    return _currentLocalizations!;
  }

  /// The currently active [Locale].
  /// Null if `init` was not called or failed.
  static Locale? get locale => _currentLocale;

  /// Loads and sets localizations for [newLocale]. Updates `S.current` and `S.locale`.
  ///
  /// This method does NOT automatically rebuild UI. It's useful for:
  /// - Accessing translations for a locale different from the main UI.
  /// - Scenarios where locale state is managed externally and `S.current` needs
  ///   to be updated after Flutter's delegates have loaded new locale data.
  ///
  /// For global UI locale changes that rebuild widgets, manage `MaterialApp.locale`
  /// and allow `S.init(context)` (in `MaterialApp.builder`) to update `S.current`.
  static Future<void> load(Locale newLocale) async {
    try {
      final loadedLocalizations = lookupAppLocalizations(newLocale);
      _currentLocalizations = loadedLocalizations;
      _currentLocale = Locale(
        loadedLocalizations.localeName,
      ); // Use canonicalized localeName
      intl.Intl.defaultLocale = loadedLocalizations.localeName;
    } catch (e) {
      debugPrint(
        'S.load(Locale newLocale) failed for locale "${newLocale.toLanguageTag()}": $e',
      );
      rethrow; // Rethrow to signal failure to the caller
    }
  }
}
