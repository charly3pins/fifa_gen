import 'dart:convert';

import 'package:fifagen/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthNotifier with ChangeNotifier {
  User _user;
  bool _loggedIn = false;

  /*
  METHODS
  */
  void logout(User user) {
    _loggedIn = false;
    _user = User();

    notifyListeners();
  }

  /*
  GETTERS
  */
  User get user => _user;
  bool get isLoggedIn => _loggedIn;

  /*
  API
  */
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<void> signUp(User user) async {
    user.profilePicture = "soccer_ball.png";
    String jsonBody = json.encode(user.toJson());
    final response = await http.post(baseUrl + "/users",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _user = User.fromJson(jsonData);
      _loggedIn = true;

      notifyListeners();
    }
  }

  Future<void> logIn(User user) async {
    String jsonBody = json.encode(user.toJson());
    final response = await http.post(baseUrl + "/token",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _user = User.fromJson(jsonData);
      _loggedIn = true;

      notifyListeners();
    }
  }
}
