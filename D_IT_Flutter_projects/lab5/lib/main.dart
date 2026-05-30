import 'package:flutter/material.dart';
import 'Calscreen.dart';
import 'HistoryScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (context) => Calscreen(),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}
