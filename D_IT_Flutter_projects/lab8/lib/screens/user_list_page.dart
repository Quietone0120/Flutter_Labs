import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/http_helper.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final HttpHelper _helper = HttpHelper();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    final data = await _helper.getUsers();
    setState(() {
      _users = data;
      _isLoading = false;
    });
  }

  void _navigateToDetail(User? user, int index) async {
    final User? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailPage(user: user)),
    );

    if (result != null) {
      setState(() {
        if (index == -1) {
          _users.add(result);
        } else {
          _users[index] = result;
        }
      });
    }
  }

  void _deleteUser(int id, int index) async {
    await _helper.deleteUser(id);
    setState(() {
      if (index >= 0 && index < _users.length) {
        _users.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PLAYER LOBBY'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchUsers),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : _users.isEmpty
          ? const Center(
              child: Text(
                "NO HEROES FOUND",
                style: TextStyle(color: Colors.white24, fontSize: 20),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B263B), Color(0xFF415A77)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.cyanAccent.withOpacity(0.3),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.cyanAccent,
                      child: Text(
                        user.name[0],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      user.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "📍 ${user.city}  |  ⚔️ LVL: ${user.age}",
                      style: const TextStyle(color: Colors.cyanAccent),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.amberAccent,
                          ),
                          onPressed: () => _navigateToDetail(user, index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteUser(user.id, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: () => _navigateToDetail(null, -1),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
