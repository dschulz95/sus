import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Imposter'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The word game with hidden imposters'**
  String get appSubtitle;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlay;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get chooseCategory;

  /// No description provided for @numberOfPlayers.
  ///
  /// In en, this message translates to:
  /// **'Number of players'**
  String get numberOfPlayers;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'{count} players'**
  String players(int count);

  /// No description provided for @numberOfImposters.
  ///
  /// In en, this message translates to:
  /// **'Number of imposters'**
  String get numberOfImposters;

  /// No description provided for @impostersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 imposter} other{{count} imposters}}'**
  String impostersCount(num count);

  /// No description provided for @discussionTime.
  ///
  /// In en, this message translates to:
  /// **'Discussion time'**
  String get discussionTime;

  /// No description provided for @discussionOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get discussionOff;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @showImposterHint.
  ///
  /// In en, this message translates to:
  /// **'Show hint for the imposter'**
  String get showImposterHint;

  /// No description provided for @playerNames.
  ///
  /// In en, this message translates to:
  /// **'Player names'**
  String get playerNames;

  /// No description provided for @playerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get playerNameHint;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get startGame;

  /// No description provided for @generatingWord.
  ///
  /// In en, this message translates to:
  /// **'Generating word…'**
  String get generatingWord;

  /// No description provided for @aiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI unavailable – using a standard word instead.'**
  String get aiUnavailable;

  /// No description provided for @playerNumber.
  ///
  /// In en, this message translates to:
  /// **'Player {number}'**
  String playerNumber(int number);

  /// No description provided for @passDeviceTo.
  ///
  /// In en, this message translates to:
  /// **'Pass the device to'**
  String get passDeviceTo;

  /// No description provided for @tapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal the card'**
  String get tapToReveal;

  /// No description provided for @revealCard.
  ///
  /// In en, this message translates to:
  /// **'Reveal card'**
  String get revealCard;

  /// No description provided for @youAreCrew.
  ///
  /// In en, this message translates to:
  /// **'You are a crewmate'**
  String get youAreCrew;

  /// No description provided for @theWordIs.
  ///
  /// In en, this message translates to:
  /// **'The word is'**
  String get theWordIs;

  /// No description provided for @youAreImposter.
  ///
  /// In en, this message translates to:
  /// **'You are the imposter!'**
  String get youAreImposter;

  /// No description provided for @imposterHint.
  ///
  /// In en, this message translates to:
  /// **'You don\'t know the word. Blend in and figure out what the others are describing.'**
  String get imposterHint;

  /// No description provided for @hintWord.
  ///
  /// In en, this message translates to:
  /// **'Your hint'**
  String get hintWord;

  /// No description provided for @imposterHintOn.
  ///
  /// In en, this message translates to:
  /// **'Use this clue to blend in and figure out the word.'**
  String get imposterHintOn;

  /// No description provided for @hideAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Hide & continue'**
  String get hideAndContinue;

  /// No description provided for @startDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Start discussion'**
  String get startDiscussion;

  /// No description provided for @discussionTitle.
  ///
  /// In en, this message translates to:
  /// **'Discussion'**
  String get discussionTitle;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @whoStarts.
  ///
  /// In en, this message translates to:
  /// **'Who starts?'**
  String get whoStarts;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get timeLeft;

  /// No description provided for @goToVote.
  ///
  /// In en, this message translates to:
  /// **'Go to vote'**
  String get goToVote;

  /// No description provided for @voteTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is the imposter?'**
  String get voteTitle;

  /// No description provided for @voteHint.
  ///
  /// In en, this message translates to:
  /// **'Discuss together and select the player you want to vote out.'**
  String get voteHint;

  /// No description provided for @voteOut.
  ///
  /// In en, this message translates to:
  /// **'Vote out'**
  String get voteOut;

  /// No description provided for @confirmVoteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Vote out {player}?'**
  String confirmVoteQuestion(String player);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @skipVote.
  ///
  /// In en, this message translates to:
  /// **'Skip vote'**
  String get skipVote;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @theWordWas.
  ///
  /// In en, this message translates to:
  /// **'The word was'**
  String get theWordWas;

  /// No description provided for @impostersWere.
  ///
  /// In en, this message translates to:
  /// **'The imposter(s)'**
  String get impostersWere;

  /// No description provided for @votedOut.
  ///
  /// In en, this message translates to:
  /// **'voted out'**
  String get votedOut;

  /// No description provided for @crewWon.
  ///
  /// In en, this message translates to:
  /// **'The crew wins!'**
  String get crewWon;

  /// No description provided for @impostersWin.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{The imposter wins!} other{The imposters win!}}'**
  String impostersWin(num count);

  /// No description provided for @noOneVotedOut.
  ///
  /// In en, this message translates to:
  /// **'No one was voted out'**
  String get noOneVotedOut;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get backToHome;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get rulesTitle;

  /// No description provided for @rulesBody.
  ///
  /// In en, this message translates to:
  /// **'1. Choose a category and the number of players.\n2. One or two players secretly become imposters.\n3. Everyone except the imposters sees the same secret word.\n4. Take turns describing the word without saying it.\n5. Vote out who you think the imposter is.\n\nCrewmates win by catching the imposter. The imposter wins by blending in.'**
  String get rulesBody;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
