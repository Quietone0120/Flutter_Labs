import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List history = ModalRoute.of(context)!.settings.arguments as List;

    return Scaffold(
      appBar: AppBar(title: Text("History")),

      body: ListView.builder(
        itemCount: history.length,

        itemBuilder: (context, index) {
          return ListTile(title: Text(history[index]));
        },
      ),
    );
  }
}
