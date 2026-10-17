import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_language.dart';
import '../models/game_round.dart';
import '../services/game_engine.dart';
import '../widgets/info_card.dart';
import 'setup_screen.dart';

/// Shows the outcome of the vote and reveals the secret word and imposters.
class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.round,
    required this.votedOutNumber,
  });

  final GameRound round;
  final int? votedOutNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = appLanguageOf(context);
    final outcome = determineOutcome(round, votedOutNumber);

    final imposterNames = round.imposters
        .map((p) => l10n.playerNumber(p.number))
        .join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                _outcomeEmoji(outcome),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              Text(
                _outcomeText(outcome, l10n),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 32),
              InfoCard(
                label: l10n.theWordWas,
                value: round.term.localized(lang),
                emphasized: true,
              ),
              const SizedBox(height: 12),
              InfoCard(label: l10n.impostersWere, value: imposterNames),
              const SizedBox(height: 12),
              InfoCard(
                label: l10n.votedOut,
                value: votedOutNumber == null
                    ? '—'
                    : l10n.playerNumber(votedOutNumber!),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _playAgain(context),
                child: Text(l10n.playAgain),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _backToHome(context),
                child: Text(l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _outcomeText(GameOutcome outcome, AppLocalizations l10n) {
    switch (outcome) {
      case GameOutcome.crewWins:
        return l10n.crewWon;
      case GameOutcome.impostersWin:
        return l10n.impostersWin(round.imposters.length);
      case GameOutcome.noVote:
        return l10n.noOneVotedOut;
    }
  }

  String _outcomeEmoji(GameOutcome outcome) {
    switch (outcome) {
      case GameOutcome.crewWins:
        return '🎉';
      case GameOutcome.impostersWin:
        return '🕵️';
      case GameOutcome.noVote:
        return '🤷';
    }
  }

  void _playAgain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SetupScreen()),
    );
  }

  void _backToHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
