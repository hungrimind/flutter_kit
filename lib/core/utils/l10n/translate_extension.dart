import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/l10n/app_localizations.dart';

extension Localizations on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
