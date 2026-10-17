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
}
