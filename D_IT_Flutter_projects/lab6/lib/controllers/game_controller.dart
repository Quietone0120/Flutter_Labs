import '../models/game.dart';

class GameController {
  final List<Game> _games = [];

  List<Game> get games => _games;

  // ✅ CREATE
  void addGame(Game game) {
    _games.add(game);
  }

  // ✅ READ
  List<Game> getGames() {
    return _games;
  }

  // ✅ UPDATE
  void updateGame(int id, Game updatedGame) {
    final index = _games.indexWhere((g) => g.id == id);
    if (index != -1) {
      _games[index] = updatedGame;
    }
  }

  // ✅ DELETE
  void deleteGame(int id) {
    _games.removeWhere((g) => g.id == id);
  }
}
