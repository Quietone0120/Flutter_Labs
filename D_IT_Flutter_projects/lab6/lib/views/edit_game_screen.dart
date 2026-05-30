import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/app_data.dart';

class EditGameScreen extends StatefulWidget {
  final Game game;

  const EditGameScreen({super.key, required this.game});

  @override
  State<EditGameScreen> createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.game.title);
    priceController = TextEditingController(text: widget.game.price.toString());
    imageController = TextEditingController(text: widget.game.imageUrl);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void updateGame() {
    if (_formKey.currentState!.validate()) {
      final controller = AppData.of(context).controller;

      final updatedGame = widget.game.copyWith(
        title: titleController.text.trim(),
        price: int.parse(priceController.text.trim()),
        imageUrl: imageController.text.trim(),
      );

      controller.updateGame(widget.game.id, updatedGame);

      Navigator.pop(context); // буцах
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Game"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

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
                    return "Title хоосон байна";
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
                  labelText: "Image Path (assets/...png)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Image path оруулна уу";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // 🔄 PREVIEW IMAGE
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Image.asset(
                  imageController.text,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 50),
                ),
              ),

              const Spacer(),

              // 🔥 UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("UPDATE", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
