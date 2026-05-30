import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/app_data.dart';

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void addGame() {
    if (_formKey.currentState!.validate()) {
      final controller = AppData.of(context).controller;

      controller.addGame(
        Game(
          id: DateTime.now().millisecondsSinceEpoch,
          title: titleController.text.trim(),
          price: int.parse(priceController.text.trim()), // эсвэл double.parse
          imageUrl: imageController.text.trim(),
        ),
      );

      Navigator.pop(context); // буцах
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Game"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🎮 TITLE
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Game Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title оруулна уу";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // 💰 PRICE
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Price оруулна уу";
                  }
                  if (int.tryParse(value) == null) {
                    return "Зөв тоо оруул";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // 🖼 IMAGE
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: "Image Path (assets/...)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Image path оруулна уу";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // 🔄 PREVIEW
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Image.asset(
                  imageController.text,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),

              const Spacer(),

              // ➕ ADD BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addGame,
                  child: const Text("ADD GAME"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
