import 'package:flutter/material.dart';
import 'screens/user_list_page.dart';

void main() => runApp(const GameUserApp());

class GameUserApp extends StatelessWidget {
  const GameUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1B2A), // Dark Navy
        primaryColor: Colors.cyanAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.amberAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B263B),
          elevation: 10,
          titleTextStyle: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      home: const UserListPage(),
    );
  }
}
