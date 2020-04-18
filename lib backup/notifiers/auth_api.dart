import 'dart:convert';

import 'package:fifagen/models/user.dart';
import 'package:fifagen/notifiers/errors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthNotifier with ChangeNotifier {
  User _user;
  bool _loggedIn = false;
  String _error;

  /*
  METHODS
  */
  void logout(User user) {
    _loggedIn = false;
    _user = null;

    notifyListeners();
  }

  void clearError() {
    _error = null;
  }

  /*
  SETTER
  */
  void set(String error) {
    _error = error;
    notifyListeners();
  }

  /*
  GETTERS
  */
  User get user => _user;
  bool get isLoggedIn => _loggedIn;
  String get error => _error;

  /*
  API
  */
  final String _baseUrl = 'http://10.0.2.2:8000';

  Future<void> signUp(User user) async {
    user.profilePicture = "soccer_ball.png";
    String jsonBody = json.encode(user.toJson());
    final response = await http.post(_baseUrl + "/users",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _user = User.fromJson(jsonData);
      _loggedIn = true;
      clearError();
    } else {
      _error = ErrorUsernameAlreadyExists;
      _user = null;
    }

    notifyListeners();
  }

  Future<void> logIn(User user) async {
    String jsonBody = json.encode(user.toJson());
    final response = await http.post(_baseUrl + "/token",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _user = User.fromJson(jsonData);
      _loggedIn = true;
      clearError();
    } else {
      _error = ErrorInvalidUsernameOrPassword;
      _user = null;
    }
    notifyListeners();
  }

  /* We receive the user from the FORM with the variables editable changed,
    so we copy the remaining from the _user and if the requests is successfull,
    we update the _user with the edited user ones
  */
  Future<void> updateUser(User user) async {
    // TODO check how to improve this code
    // Only variables that are not editable
    user.id = _user.id;
    user.username = _user.username;
    user.password = _user.password;

    String jsonBody = json.encode(user.toJson());
    final response = await http.put(_baseUrl + "/users/${user.id}",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (_error == null && response.statusCode == 200 && response.body.isEmpty) {
      // TODO check how to improve this code
      // Only variables that are editable
      _user.name = user.name;
      //_user.profilePicture = user.profilePicture; // TODO uncomment when picture is editable

      clearError();
    } else {
      _error = ErrorUpdateUserProfile;
    }

    notifyListeners();
  }
}
