import 'package:flutter/material.dart';

// void main() {
//   runApp(const StaticApp());
// }

void main() => runApp(const StaticApp());

class StaticApp extends StatelessWidget {
  const StaticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Container(
            color: Colors.purple,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Container(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
