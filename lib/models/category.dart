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
///
/// A category is either **static** (it ships with a fixed [terms] list that the
/// game deals from directly) or **dynamic** (it has an AI [promptDe]/[promptEn]
/// describing the theme, and the secret word + hint are generated on demand via
/// the OpenAI API). Dynamic categories still keep a small [terms] list as a
/// fallback when the AI is unavailable.
class Category {
  final String id;
  final String nameDe;
  final String nameEn;
  final String emoji;
  final List<Term> terms;

  /// German/English instructions that describe what kind of word the AI should
  /// generate. Non-null for dynamic categories.
  final String? promptDe;
  final String? promptEn;

  const Category({
    required this.id,
    required this.nameDe,
    required this.nameEn,
    required this.emoji,
    this.terms = const [],
    this.promptDe,
    this.promptEn,
  });

  /// Whether this category generates its secret word via AI.
  bool get isDynamic => promptDe != null && promptEn != null;

  String name(AppLanguage language) =>
      language == AppLanguage.de ? nameDe : nameEn;
}
