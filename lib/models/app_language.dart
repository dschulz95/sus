import 'package:flutter/widgets.dart';

/// The two languages supported by the app.
///
/// This is used to localize the game *data* (category names and terms),
/// whereas the UI strings are handled by Flutter's `gen_l10n` tooling.
enum AppLanguage {
  de,
  en;

  String get code => name;
}

/// Resolves the currently active [AppLanguage] from the ambient Flutter locale.
AppLanguage appLanguageOf(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return locale.languageCode == 'de' ? AppLanguage.de : AppLanguage.en;
}
