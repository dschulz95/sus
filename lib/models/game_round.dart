import 'category.dart';
import 'game_settings.dart';
import 'player.dart';

/// An immutable snapshot of one game round: the settings, the secret word,
/// and the assigned roles.
class GameRound {
  final GameSettings settings;
  final Term term;
  final List<Player> players;

  const GameRound({
    required this.settings,
    required this.term,
    required this.players,
  });

  List<Player> get imposters => players.where((p) => p.isImposter).toList();

  List<Player> get crewmates => players.where((p) => !p.isImposter).toList();
}
