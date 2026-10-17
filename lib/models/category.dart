import 'app_language.dart';

/// A single secret word, localized in German and English.
///
/// Each term also carries an associated [hint] word. The hint is shown to
/// imposters (when the option is enabled) so they get a thematic clue without
/// learning the exact secret word.
class Term {
  final String de;
  final String en;
  final String hintDe;
  final String hintEn;

  const Term({
    required this.de,
    required this.en,
    required this.hintDe,
    required this.hintEn,
  });

  String localized(AppLanguage language) =>
      language == AppLanguage.de ? de : en;

  String hint(AppLanguage language) =>
      language == AppLanguage.de ? hintDe : hintEn;
}

/// A themed collection of secret words that can be dealt to the crew.
class Category {
  final String id;
  final String nameDe;
  final String nameEn;
  final String emoji;
  final List<Term> terms;

  const Category({
    required this.id,
    required this.nameDe,
    required this.nameEn,
    required this.emoji,
    required this.terms,
  });

  String name(AppLanguage language) =>
      language == AppLanguage.de ? nameDe : nameEn;
}
