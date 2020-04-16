import 'dart:convert';

import 'package:fifagen/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersNotifier with ChangeNotifier {
  List<User> _users = [];
  String _error;

  /*
  METHODS
  */
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearUsers() {
    _users = [];
    notifyListeners();
  }

  /*
  SETTER
  */
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  /*
  GETTERS
  */
  List<User> get users => _users;
  String get error => _error;

  /*
  API
  */
  final String _baseUrl = 'http://10.0.2.2:8000';

  Future<void> findUsers(String query) async {
    final response = await http.get(_baseUrl + "/users" + "?username=" + query,
        headers: {"Content-Type": 'application/json'});

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _users = [];
      for (var i = 0; i < jsonData.length; i++) {
        _users.add(User.fromJson(jsonData[i]));
      }
      clearError();
    } else {
      _error = "Error finding users";
    }

    notifyListeners();
  }
}
