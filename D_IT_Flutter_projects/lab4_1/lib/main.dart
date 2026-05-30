import 'package:flutter/material.dart';
import 'profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        canvasColor: const Color.fromARGB(255, 0, 0, 0),
        cardColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: const ArtistProfileScreen(),
    );
  }
}
