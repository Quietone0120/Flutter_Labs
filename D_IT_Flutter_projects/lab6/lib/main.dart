import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'controllers/game_controller.dart';
import 'views/game_list_screen.dart';
import 'models/game.dart';

void main() {
  final controller = GameController();

  controller.addGame(
    Game(id: 1, title: "Chess", price: 10, imageUrl: "assets/g1.png"),
  );
  controller.addGame(
    Game(id: 2, title: 'Sudoku', price: 5, imageUrl: 'assets/g2.png'),
  );
  controller.addGame(
    Game(id: 3, title: "Chess", price: 10, imageUrl: "assets/g1.png"),
  );
  controller.addGame(
    Game(id: 4, title: 'Sudoku', price: 5, imageUrl: 'assets/g2.png'),
  );
  controller.addGame(
    Game(id: 5, title: "Chess", price: 10, imageUrl: "assets/g1.png"),
  );
  controller.addGame(
    Game(id: 6, title: 'Sudoku', price: 5, imageUrl: 'assets/g2.png'),
  );

  runApp(AppData(controller: controller, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameListScreen(),
    );
  }
}
