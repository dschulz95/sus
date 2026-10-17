import 'category.dart';

/// The user-configurable options for a single game round.
class GameSettings {
  final Category category;
  final int playerCount;
  final int imposterCount;

  /// [Duration.zero] disables the discussion timer.
  final Duration discussionDuration;

  const GameSettings({
    required this.category,
    required this.playerCount,
    required this.imposterCount,
    this.discussionDuration = const Duration(minutes: 3),
  });
}
