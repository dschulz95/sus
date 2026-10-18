// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Imposter';

  @override
  String get appSubtitle => 'Das Wortspiel mit versteckten Impostern';

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get howToPlay => 'So wird gespielt';

  @override
  String get language => 'Sprache';

  @override
  String get chooseCategory => 'Kategorie wählen';

  @override
  String get numberOfPlayers => 'Anzahl der Spieler';

  @override
  String players(int count) {
    return '$count Spieler';
  }

  @override
  String get numberOfImposters => 'Anzahl der Imposter';

  @override
  String impostersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Imposter',
      one: '1 Imposter',
    );
    return '$_temp0';
  }

  @override
  String get discussionTime => 'Diskussionszeit';

  @override
  String get discussionOff => 'Aus';

  @override
  String get minutes => 'Min.';

  @override
  String get showImposterHint => 'Hinweis für den Imposter anzeigen';

  @override
  String get playerNames => 'Spielernamen';

  @override
  String get playerNameHint => 'Name eingeben';

  @override
  String get startGame => 'Spiel starten';

  @override
  String get generatingWord => 'Wort wird generiert…';

  @override
  String get aiUnavailable =>
      'KI nicht verfügbar – es wird ein Standardwort verwendet.';

  @override
  String playerNumber(int number) {
    return 'Spieler $number';
  }

  @override
  String get passDeviceTo => 'Gerät übergeben an';

  @override
  String get tapToReveal => 'Tippen, um die Karte aufzudecken';

  @override
  String get revealCard => 'Karte aufdecken';

  @override
  String get youAreCrew => 'Du bist ein Crewmitglied';

  @override
  String get theWordIs => 'Das Wort ist';

  @override
  String get youAreImposter => 'Du bist der Imposter!';

  @override
  String get imposterHint =>
      'Du kennst das Wort nicht. Gib dich als Crewmitglied aus und finde heraus, was die anderen beschreiben.';

  @override
  String get hintWord => 'Dein Hinweis';

  @override
  String get imposterHintOn =>
      'Nutze diesen Hinweis, um dich einzufügen und das Wort zu erraten.';

  @override
  String get hideAndContinue => 'Verbergen & weiter';

  @override
  String get startDiscussion => 'Diskussion starten';

  @override
  String get discussionTitle => 'Diskussion';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get whoStarts => 'Wer fängt an?';

  @override
  String get timeLeft => 'Verbleibende Zeit';

  @override
  String get goToVote => 'Zur Abstimmung';

  @override
  String get voteTitle => 'Wer ist der Imposter?';

  @override
  String get voteHint =>
      'Diskutiert gemeinsam und wählt den Spieler, den ihr rauswerfen wollt.';

  @override
  String get voteOut => 'Rauswählen';

  @override
  String confirmVoteQuestion(String player) {
    return '$player rauswählen?';
  }

  @override
  String get confirm => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get skipVote => 'Abstimmung überspringen';

  @override
  String get resultTitle => 'Ergebnis';

  @override
  String get theWordWas => 'Das Wort war';

  @override
  String get impostersWere => 'Imposter';

  @override
  String get votedOut => 'wurde rausgewählt';

  @override
  String get crewWon => 'Die Crew gewinnt!';

  @override
  String impostersWin(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Die Imposter gewinnen!',
      one: 'Der Imposter gewinnt!',
    );
    return '$_temp0';
  }

  @override
  String get noOneVotedOut => 'Niemand wurde rausgewählt';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get backToHome => 'Start';

  @override
  String get rulesTitle => 'So wird gespielt';

  @override
  String get rulesBody =>
      '1. Wählt eine Kategorie und die Anzahl der Spieler.\n2. Ein oder zwei Spieler werden heimlich zu Impostern.\n3. Alle außer den Impostern sehen dasselbe geheime Wort.\n4. Beschreibt abwechselnd das Wort, ohne es zu sagen.\n5. Wählt raus, wen ihr für den Imposter haltet.\n\nDie Crew gewinnt, wenn sie den Imposter erwischt. Der Imposter gewinnt, wenn er unentdeckt bleibt.';

  @override
  String get close => 'Schließen';
}
