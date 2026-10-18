import 'category.dart';
import 'game_settings.dart';
import 'player.dart';

/// An immutable snapshot of one game round: the settings, the secret word,
/// the assigned roles, and who starts the discussion.
class GameRound {
  final GameSettings settings;
  final Term term;
  final List<Player> players;

  /// The player who opens the discussion. Chosen at random when the round is
  /// created, but only revealed after everyone has seen their card.
  final Player startingPlayer;

  const GameRound({
    required this.settings,
    required this.term,
    required this.players,
    required this.startingPlayer,
  });

  List<Player> get imposters => players.where((p) => p.isImposter).toList();

  List<Player> get crewmates => players.where((p) => !p.isImposter).toList();
}
