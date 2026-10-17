import 'app_language.dart';

/// A single secret word, localized in German and English.
class Term {
  final String de;
  final String en;

  const Term({required this.de, required this.en});

  String localized(AppLanguage language) =>
      language == AppLanguage.de ? de : en;
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
