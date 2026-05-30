import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/app_data.dart';
import 'edit_game_screen.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final controller = AppData.of(context).controller;

    return Scaffold(
      backgroundColor: const Color(0xFF87B05A), // 🟩 grass

      appBar: AppBar(
        title: Text(game.title),
        backgroundColor: const Color(0xFF5A3A1B), // 🟫 dirt
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🧱 IMAGE
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5A3A1B),
                border: Border.all(color: Colors.black, width: 4),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                game.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, size: 80),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // 🎮 TITLE
            Text(
              game.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 💰 PRICE (safe)
            Text(
              'Price: \$${game.price}',
              style: const TextStyle(fontSize: 20),
            ),

            const Spacer(),

            // 🔥 EDIT + DELETE BUTTONS
            Row(
              children: [
                // ✏️ EDIT
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditGameScreen(game: game),
                        ),
                      ).then((_) {
                        Navigator.pop(context); // refresh хийх
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: const Center(
                        child: Text(
                          "EDIT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ❌ DELETE
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // confirm dialog
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text("Delete this game?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteGame(game.id);
                                Navigator.pop(context); // dialog
                                Navigator.pop(context); // detail screen
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A3A1B),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: const Center(
                        child: Text(
                          "DELETE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
