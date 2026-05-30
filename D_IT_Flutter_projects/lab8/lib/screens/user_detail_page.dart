import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/http_helper.dart';

class UserDetailPage extends StatefulWidget {
  final User? user;
  const UserDetailPage({super.key, this.user});
  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _helper = HttpHelper();

  // Controller-уудыг тодорхойлох
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _hobbyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Хэрэв засах горим бол хуучин утгуудыг талбарт оруулна
    if (widget.user != null) {
      _nameCtrl.text = widget.user!.name;
      _cityCtrl.text = widget.user!.city;
      _ageCtrl.text = widget.user!.age.toString();
      _hobbyCtrl.text = widget.user!.hobbies.join(', ');
    }
  }

  @override
  void dispose() {
    // Memory leak-ээс сэргийлж устгана
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _ageCtrl.dispose();
    _hobbyCtrl.dispose();
    super.dispose();
  }

  void _saveHero() async {
    // Текст талбараас утгуудыг авч байна
    String name = _nameCtrl.text.trim();
    String city = _cityCtrl.text.trim();
    int level = int.tryParse(_ageCtrl.text) ?? 1;
    List<String> hobbies = _hobbyCtrl.text.isNotEmpty
        ? _hobbyCtrl.text.split(',').map((e) => e.trim()).toList()
        : [];

    // Хоосон бол хадгалахгүй
    if (name.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hero Name and Realm are required!")),
      );
      return;
    }

    // Шинэ объект үүсгэх
    User hero = User(
      id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: name,
      city: city,
      age: level,
      hobbies: hobbies,
    );

    // API руу илгээх (Mock)
    if (widget.user == null) {
      await _helper.postUser(hero);
    } else {
      await _helper.putUser(hero);
    }

    // Дэлгэцээс буцахдаа шинэ баатрын мэдээллийг хамт явуулна
    if (mounted) {
      Navigator.pop(context, hero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "CREATE HERO" : "UPGRADE HERO"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildGameInput(_nameCtrl, "Hero Name", Icons.person),
              _buildGameInput(_cityCtrl, "Realm (City)", Icons.fort),
              _buildGameInput(
                _ageCtrl,
                "Initial Level (Age)",
                Icons.bolt,
                isNumber: true,
              ),
              _buildGameInput(
                _hobbyCtrl,
                "Skills (Hobbies)",
                Icons.auto_awesome,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveHero, // Энд дарж хадгална
                  child: Text(
                    widget.user == null ? "SPAWN HERO" : "LEVEL UP",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInput(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          prefixIcon: Icon(icon, color: Colors.cyanAccent),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyanAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
