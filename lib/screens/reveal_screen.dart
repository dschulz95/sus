import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_language.dart';
import '../models/game_round.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import '../widgets/info_card.dart';
import 'discussion_screen.dart';

/// Hot-seat reveal phase. Each player privately reveals their role one at a
/// time before the discussion starts.
class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key, required this.round});

  final GameRound round;

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  /// Players in reveal order, rotated so a random player starts.
  late final List<Player> _revealOrder;
  int _index = 0;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    final players = widget.round.players;
    final start = Random().nextInt(players.length);
    _revealOrder = [
      for (var i = 0; i < players.length; i++)
        players[(start + i) % players.length],
    ];
  }

  Player get _current => _revealOrder[_index];
  bool get _isLast => _index == _revealOrder.length - 1;

  String _playerLabel(AppLocalizations l10n, Player player) =>
      player.name.isNotEmpty ? player.name : l10n.playerNumber(player.number);

  void _continue() {
    if (_isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DiscussionScreen(round: widget.round),
        ),
      );
    } else {
      setState(() {
        _index += 1;
        _revealed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(_playerLabel(l10n, _current))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _revealed
                ? _buildRevealed(context, l10n)
                : _buildHidden(context, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildHidden(BuildContext context, AppLocalizations l10n) {
    return Column(
      key: const ValueKey('hidden'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.passDeviceTo,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          _playerLabel(l10n, _current),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 48),
        FilledButton(
          onPressed: () => setState(() => _revealed = true),
          child: Text(l10n.revealCard),
        ),
      ],
    );
  }

  Widget _buildRevealed(BuildContext context, AppLocalizations l10n) {
    final lang = appLanguageOf(context);
    final isImposter = _current.isImposter;

    return Column(
      key: const ValueKey('revealed'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isImposter ? '🕵️' : '🧑‍🚀',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 64),
        ),
        const SizedBox(height: 16),
        Text(
          isImposter ? l10n.youAreImposter : l10n.youAreCrew,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isImposter ? AppTheme.imposter : Colors.white,
              ),
        ),
        const SizedBox(height: 32),
        InfoCard(
          label: l10n.categoryLabel,
          value: widget.round.settings.category.name(lang),
        ),
        if (isImposter) ...[
          if (widget.round.settings.showImposterHint) ...[
            const SizedBox(height: 12),
            InfoCard(
              label: l10n.hintWord,
              value: widget.round.term.hint(lang),
              emphasized: true,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.imposterHintOn,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white70),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Text(
              l10n.imposterHint,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white70),
            ),
          ],
        ] else ...[
          const SizedBox(height: 12),
          InfoCard(
            label: l10n.theWordIs,
            value: widget.round.term.localized(lang),
            emphasized: true,
          ),
        ],
        const SizedBox(height: 48),
        FilledButton(
          onPressed: _continue,
          child: Text(_isLast ? l10n.startDiscussion : l10n.hideAndContinue),
        ),
      ],
    );
  }
}
