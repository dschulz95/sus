import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_language.dart';
import '../models/game_round.dart';
import '../theme/app_theme.dart';
import '../widgets/info_card.dart';
import 'vote_screen.dart';

/// Discussion phase with an optional countdown timer.
class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key, required this.round});

  final GameRound round;

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  Timer? _timer;
  late Duration _remaining;

  bool get _hasTimer =>
      widget.round.settings.discussionDuration > Duration.zero;

  @override
  void initState() {
    super.initState();
    _remaining = widget.round.settings.discussionDuration;
    if (_hasTimer) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_remaining <= const Duration(seconds: 1)) {
      _goToVote();
    } else {
      setState(() => _remaining -= const Duration(seconds: 1));
    }
  }

  void _goToVote() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => VoteScreen(round: widget.round)),
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = appLanguageOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.discussionTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              InfoCard(
                label: l10n.whoStarts,
                value: widget.round.startingPlayer.label(l10n),
                emphasized: true,
              ),
              const SizedBox(height: 16),
              InfoCard(
                label: l10n.categoryLabel,
                value: widget.round.settings.category.name(lang),
              ),
              const Spacer(flex: 2),
              if (_hasTimer) ...[
                Text(
                  l10n.timeLeft,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  _format(_remaining),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.accent,
                      ),
                ),
              ],
              const Spacer(flex: 2),
              FilledButton(
                onPressed: _goToVote,
                child: Text(l10n.goToVote),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
