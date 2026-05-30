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
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        canvasColor: const Color(0xFF0F0F0F),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const ArtistProfileScreen(),
    );
  }
}
