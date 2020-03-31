import '../model/user.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class FifaGenAPI {
  final String baseURL = 'http://10.0.2.2:8000';

  Future<User> createUser(User user) async {
    String jsonBody = json.encode(user.toJSON());
    final response = await http.post(baseURL + "/users",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<User> login(User user) async {
    String jsonBody = json.encode(user.toJSON());
    final response = await http.post(baseURL + "/token",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }
}
