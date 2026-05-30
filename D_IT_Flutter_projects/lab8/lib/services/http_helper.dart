import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class HttpHelper {
  // ЭНД ӨӨРИЙН WIREMOCK ХАЯГИЙГ ХУУЛЖ ТАВИАРАЙ
  final String authority = 'o2qkq.wiremockapi.cloud';
  final String path = 'users';

  Future<List<User>> getUsers() async {
    final Uri url = Uri.https(authority, path);
    try {
      final http.Response result = await http.get(url);
      if (result.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonResponse = json.decode(result.body);
        return jsonResponse.map((i) => User.fromJson(i)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<String> postUser(User user) async {
    Uri url = Uri.https(authority, path);
    String body = json.encode(user.toJson());
    http.Response r = await http.post(url, body: body);
    return r.body;
  }

  Future<String> putUser(User user) async {
    Uri url = Uri.https(authority, path);
    String body = json.encode(user.toJson());
    http.Response r = await http.put(url, body: body);
    return r.body;
  }

  Future<String> deleteUser(int id) async {
    Uri url = Uri.https(authority, path);
    http.Response r = await http.delete(url);
    return r.body;
  }
}
