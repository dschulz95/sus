import 'category.dart';

/// The user-configurable options for a single game round.
class GameSettings {
  final Category category;
  final int playerCount;
  final int imposterCount;

  /// [Duration.zero] disables the discussion timer.
  final Duration discussionDuration;

  /// Whether imposters see a hint word during the reveal phase.
  final bool showImposterHint;

  /// Optional display names, one per player (index 0 → player 1). May be
  /// shorter than [playerCount]; missing or empty names fall back to the
  /// default "Player N" label.
  final List<String> playerNames;

  const GameSettings({
    required this.category,
    required this.playerCount,
    required this.imposterCount,
    this.discussionDuration = const Duration(minutes: 3),
    this.showImposterHint = true,
    this.playerNames = const [],
  });
}
