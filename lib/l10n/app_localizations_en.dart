// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Imposter';

  @override
  String get appSubtitle => 'The word game with hidden imposters';

  @override
  String get newGame => 'New game';

  @override
  String get howToPlay => 'How to play';

  @override
  String get language => 'Language';

  @override
  String get chooseCategory => 'Choose a category';

  @override
  String get numberOfPlayers => 'Number of players';

  @override
  String players(int count) {
    return '$count players';
  }

  @override
  String get numberOfImposters => 'Number of imposters';

  @override
  String impostersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imposters',
      one: '1 imposter',
    );
    return '$_temp0';
  }

  @override
  String get discussionTime => 'Discussion time';

  @override
  String get discussionOff => 'Off';

  @override
  String get minutes => 'min';

  @override
  String get startGame => 'Start game';

  @override
  String playerNumber(int number) {
    return 'Player $number';
  }

  @override
  String get passDeviceTo => 'Pass the device to';

  @override
  String get tapToReveal => 'Tap to reveal the card';

  @override
  String get revealCard => 'Reveal card';

  @override
  String get youAreCrew => 'You are a crewmate';

  @override
  String get theWordIs => 'The word is';

  @override
  String get youAreImposter => 'You are the imposter!';

  @override
  String get imposterHint =>
      'You don\'t know the word. Blend in and figure out what the others are describing.';

  @override
  String get hideAndContinue => 'Hide & continue';

  @override
  String get startDiscussion => 'Start discussion';

  @override
  String get discussionTitle => 'Discussion';

  @override
  String get categoryLabel => 'Category';

  @override
  String get timeLeft => 'Time left';

  @override
  String get goToVote => 'Go to vote';

  @override
  String get voteTitle => 'Who is the imposter?';

  @override
  String get voteHint =>
      'Discuss together and select the player you want to vote out.';

  @override
  String get voteOut => 'Vote out';

  @override
  String confirmVoteQuestion(String player) {
    return 'Vote out $player?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get skipVote => 'Skip vote';

  @override
  String get resultTitle => 'Result';

  @override
  String get theWordWas => 'The word was';

  @override
  String get impostersWere => 'The imposter(s)';

  @override
  String get votedOut => 'voted out';

  @override
  String get crewWon => 'The crew wins!';

  @override
  String impostersWin(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The imposters win!',
      one: 'The imposter wins!',
    );
    return '$_temp0';
  }

  @override
  String get noOneVotedOut => 'No one was voted out';

  @override
  String get playAgain => 'Play again';

  @override
  String get backToHome => 'Home';

  @override
  String get rulesTitle => 'How to play';

  @override
  String get rulesBody =>
      '1. Choose a category and the number of players.\n2. One or two players secretly become imposters.\n3. Everyone except the imposters sees the same secret word.\n4. Take turns describing the word without saying it.\n5. Vote out who you think the imposter is.\n\nCrewmates win by catching the imposter. The imposter wins by blending in.';

  @override
  String get close => 'Close';
}
