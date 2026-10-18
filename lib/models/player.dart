import '../l10n/app_localizations.dart';

/// A participant in a round.
class Player {
  /// 1-based display number, e.g. "Player 3".
  final int number;

  /// Optional display name. Empty when the player has no custom name.
  final String name;

  final bool isImposter;

  const Player({
    required this.number,
    required this.isImposter,
    this.name = '',
  });

  /// The custom name, or the localized "Player N" fallback.
  String label(AppLocalizations l10n) =>
      name.isNotEmpty ? name : l10n.playerNumber(number);
}
