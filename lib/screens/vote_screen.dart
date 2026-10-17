import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/game_round.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

/// Group vote: the players jointly select one person to vote out.
class VoteScreen extends StatelessWidget {
  const VoteScreen({super.key, required this.round});

  final GameRound round;

  void _goToResult(BuildContext context, int? number) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(round: round, votedOutNumber: number),
      ),
    );
  }

  void _confirmVote(BuildContext context, Player player) {
    final l10n = AppLocalizations.of(context)!;
    final label =
        player.name.isNotEmpty ? player.name : l10n.playerNumber(player.number);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmVoteQuestion(label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _goToResult(context, player.number);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.voteTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.voteHint,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: round.players.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final player = round.players[index];
                    final label = player.name.isNotEmpty
                        ? player.name
                        : l10n.playerNumber(player.number);
                    return Card(
                      color: AppTheme.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        onTap: () => _confirmVote(context, player),
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.cardSelected,
                          foregroundColor: Colors.white,
                          child: Text('${player.number}'),
                        ),
                        title: Text(
                          label,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _goToResult(context, null),
                child: Text(l10n.skipVote),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
