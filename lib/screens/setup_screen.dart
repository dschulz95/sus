import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../l10n/app_localizations.dart';
import '../models/app_language.dart';
import '../models/category.dart';
import '../models/game_settings.dart';
import '../services/config_service.dart';
import '../services/game_engine.dart';
import '../services/term_generator.dart';
import '../theme/app_theme.dart';
import 'reveal_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  static const int _minPlayers = 4;
  static const int _maxPlayers = 12;
  static const List<int> _timeOptions = [0, 2, 3, 5];

  Category _selectedCategory = kCategories.first;
  int _playerCount = 6;
  int _imposterCount = 1;
  int _discussionMinutes = 3;
  bool _showImposterHint = true;

  int get _maxImposters => _playerCount >= 6 ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = appLanguageOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newGame)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _sectionTitle(context, l10n.chooseCategory),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.05,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: kCategories.length,
              itemBuilder: (context, index) {
                final category = kCategories[index];
                return _CategoryTile(
                  category: category,
                  language: lang,
                  selected: category.id == _selectedCategory.id,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              },
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, l10n.numberOfPlayers),
            _Stepper(
              value: _playerCount,
              min: _minPlayers,
              max: _maxPlayers,
              onChanged: (value) => setState(() {
                _playerCount = value;
                if (_imposterCount > _maxImposters) {
                  _imposterCount = _maxImposters;
                }
              }),
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, l10n.numberOfImposters),
            Row(
              children: [
                Expanded(
                  child: _OptionChip(
                    label: l10n.impostersCount(1),
                    selected: _imposterCount == 1,
                    onTap: () => setState(() => _imposterCount = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OptionChip(
                    label: l10n.impostersCount(2),
                    selected: _imposterCount == 2,
                    enabled: _maxImposters >= 2,
                    onTap: () => setState(() => _imposterCount = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, l10n.discussionTime),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final minutes in _timeOptions)
                  _OptionChip(
                    label: _timeLabel(l10n, minutes),
                    selected: _discussionMinutes == minutes,
                    onTap: () => setState(() => _discussionMinutes = minutes),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: AppTheme.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                value: _showImposterHint,
                onChanged: (value) =>
                    setState(() => _showImposterHint = value),
                title: Text(
                  l10n.showImposterHint,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                secondary: const Icon(Icons.lightbulb_outline),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _start,
              child: Text(l10n.startGame),
            ),
          ],
        ),
      ),
    );
  }

  String _timeLabel(AppLocalizations l10n, int minutes) =>
      minutes == 0 ? l10n.discussionOff : '$minutes ${l10n.minutes}';

  Widget _sectionTitle(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      );

  void _start() {
    final settings = GameSettings(
      category: _selectedCategory,
      playerCount: _playerCount,
      imposterCount: _imposterCount,
      discussionDuration: _discussionMinutes == 0
          ? Duration.zero
          : Duration(minutes: _discussionMinutes),
      showImposterHint: _showImposterHint,
    );

    if (_selectedCategory.isDynamic) {
      _startDynamic(settings);
      return;
    }

    final round = GameEngine().createRound(settings);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RevealScreen(round: round)),
    );
  }

  /// Starts a round for a dynamic category: generates the word + hint via the
  /// OpenAI API (with a fallback to the category's static words) first.
  Future<void> _startDynamic(GameSettings settings) async {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GeneratingDialog(message: l10n.generatingWord),
    );

    final apiKey = await const ConfigService().loadOpenAiApiKey();
    final generator = TermGenerator(apiKey: apiKey);
    final result = await generator.generate(settings.category);

    if (!mounted) return;
    Navigator.of(context).pop(); // close the loading dialog
    if (result.fromFallback) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aiUnavailable)),
      );
    }

    final round = GameEngine().createRound(settings, term: result.term);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RevealScreen(round: round)),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final Category category;
  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? AppTheme.cardSelected : AppTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppTheme.accent : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),
                  Text(
                    category.name(language),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (category.isDynamic)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
          iconSize: 28,
          style: IconButton.styleFrom(
            minimumSize: const Size(56, 56),
            backgroundColor: AppTheme.card,
            foregroundColor: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '$value',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        IconButton.filled(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
          iconSize: 28,
          style: IconButton.styleFrom(
            minimumSize: const Size(56, 56),
            backgroundColor: AppTheme.card,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? AppTheme.cardSelected : AppTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? AppTheme.accent : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: enabled ? Colors.white : Colors.white38,
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneratingDialog extends StatelessWidget {
  const _GeneratingDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
