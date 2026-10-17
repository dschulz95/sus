import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_language.dart';
import 'setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = appLanguageOf(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SegmentedButton<AppLanguage>(
                  segments: const [
                    ButtonSegment(value: AppLanguage.de, label: Text('DE')),
                    ButtonSegment(value: AppLanguage.en, label: Text('EN')),
                  ],
                  selected: {lang},
                  onSelectionChanged: (selection) =>
                      onLocaleChanged(Locale(selection.first.code)),
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                '🕵️',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 72),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white70),
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: () => _startGame(context),
                child: Text(l10n.newGame),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _showRules(context),
                child: Text(l10n.howToPlay),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SetupScreen()),
    );
  }

  void _showRules(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rulesTitle),
        content: SingleChildScrollView(child: Text(l10n.rulesBody)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
