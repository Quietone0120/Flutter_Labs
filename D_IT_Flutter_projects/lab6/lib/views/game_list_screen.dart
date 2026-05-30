import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'game_detail_screen.dart';
import 'add_game_screen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = AppData.of(context).controller;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 130, 246),

      appBar: AppBar(
        title: const Text("🍄 Play Games"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 191, 36),
        elevation: 0,
      ),

      // ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddGameScreen()),
          ).then((_) {
            setState(() {}); 
          });
        },
      ),

      body: controller.games.isEmpty
          ? const Center(
              child: Text(
                "No games yet 😢",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: controller.games.length,
              itemBuilder: (context, index) {
                final game = controller.games[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GameDetailScreen(game: game),
                      ),
                    ).then((_) {
                      setState(() {}); 
                    });
                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                      ],
                    ),

                    child: Row(
                      children: [
                        // 🖼 IMAGE
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.black, width: 3),
                            ),
                          ),
                          child: Image.asset(
                            game.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),

                        // 📝 INFO
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.orange,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${game.price}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
