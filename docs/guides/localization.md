# Manage Multiple Languages

Localization is used for displaying text to users in different languages based on their device language. This is implemented using Flutter’s recommended approach, powered by the Dart-maintained [`intl`](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization) package.

## Creating Translations

The translations are stored in `.arb` files, one per supported language. Each file should be named using the language locale. For example, English translations go in `app_en.arb`, and Spanish translations in `app_es.arb`.

Here is an example entry in the English translation file:

```json title="app_en.arb"
{
  "@@locale": "en",
  "appName": "Flutter Kit",
  "@appName": {
    "description": "The name of the app"
  },
  "errorGeneric": "Oops! Something went wrong",
  "@errorGeneric": {
    "description": "The generic error message"
  }
}
```

To generate the necessary code, run:

```bash
flutter pub get
```

Once generated, you can access translations in a few different ways.

### With `BuildContext`

You can access localized strings directly with the standard `AppLocalizations` API:

```dart
Text(
  AppLocalizations.of(context)!.errorGeneric,
)
```

We also provide a `context.translate` extension for convenience:

```dart
Text(
  context.translate.errorGeneric,
)
```

### Without `BuildContext`

If you're working in a view model, service, or anywhere else that doesn’t have access to a `BuildContext`, you can use the static accessor:

```dart
Translate.current.errorGeneric
```

This makes localization usable in pure Dart classes and non-widget layers of your app.

## Adding Other Languages

To add another language, create a new `.arb` file using the correct locale code. Descriptions are optional and primarily for developers.

```json title="app_es.arb"
{
  "@@locale": "es",
  "appName": "Flutter Kit ES",
  "errorGeneric": "Oops! Algo salió mal"
}
```

Then run the generation command again:

```bash
flutter pub get
```

Your app will automatically pick up the new language if the user's device is set to that locale.
