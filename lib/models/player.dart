/// A participant in a round.
class Player {
  /// 1-based display number, e.g. "Player 3".
  final int number;
  final bool isImposter;

  const Player({required this.number, required this.isImposter});
}
