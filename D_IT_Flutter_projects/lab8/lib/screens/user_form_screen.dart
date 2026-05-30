import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/http_helper.dart';

class UserDetailPage extends StatefulWidget {
  final User? user; // Хэрэв null бол "Нэмэх", үгүй бол "Засах" горим

  const UserDetailPage({super.key, this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final HttpHelper _helper = HttpHelper();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _ageController;
  late TextEditingController _hobbiesController;

  @override
  void initState() {
    super.initState();
    // Өгөгдөл байгаа бол Textfield-үүдэд утгыг нь онооно
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _cityController = TextEditingController(text: widget.user?.city ?? '');
    _ageController = TextEditingController(
      text: widget.user?.age.toString() ?? '',
    );
    _hobbiesController = TextEditingController(
      text: widget.user?.hobbies.join(", ") ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Хэрэглэгч засах" : "Шинэ хэрэглэгч нэмэх"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Нэр"),
                  validator: (value) =>
                      value!.isEmpty ? "Нэр оруулна уу" : null,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: "Хот"),
                  validator: (value) =>
                      value!.isEmpty ? "Хот оруулна уу" : null,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: "Нас"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Нас оруулна уу" : null,
                ),
                TextFormField(
                  controller: _hobbiesController,
                  decoration: const InputDecoration(
                    labelText: "Сонирхол (таслалаар тусгаарлах)",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveUser,
                  child: Text(isEdit ? "Засах" : "Хадгалах"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        id: widget.user?.id ?? 99, // Шинэ бол түр зуур 99 id оноов
        name: _nameController.text,
        city: _cityController.text,
        age: int.parse(_ageController.text),
        hobbies: _hobbiesController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
      );

      String result;
      if (widget.user == null) {
        result = await _helper.postUser(user);
      } else {
        result = await _helper.putUser(user);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
        Navigator.pop(context, true); // Амжилттай болсныг мэдэгдээд буцах
      }
    }
  }
}
