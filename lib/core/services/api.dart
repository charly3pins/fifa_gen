import 'dart:convert';

import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/friendship.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:http/http.dart' as http;

class Api {
  static const _baseUrl = 'http://10.0.2.2:8000';

  var client = new http.Client();

  Future<User> logIn(User user) async {
    print("Api => logIn");
    String jsonBody = json.encode(user.toJson());
    // TODO add catch and return INTERNAL ERROR if the API is down
    var response = await client.post("$_baseUrl/token",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      print("API => OK");
      return User.fromJson(json.decode(response.body));
    }
    print("API => ERROR");
    throw (Errors.InvalidUsernameOrPassword);
  }

  Future<User> signUp(User user) async {
    print("Api => signUp");
    user.profilePicture = "soccer_ball.png";
    String jsonBody = json.encode(user.toJson());
    // TODO add catch and return INTERNAL ERROR if the API is down
    var response = await client.post("$_baseUrl/users",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      print("API => OK");
      return User.fromJson(json.decode(response.body));
    }
    print("API => ERROR");
    throw (Errors.UsernameAlreadyExists);
  }

  Future<List<User>> findUsers(String query) async {
    final response = await client.get("$_baseUrl/users?username=$query",
        headers: {"Content-Type": 'application/json'});

    var results = List<User>();
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body) as List<dynamic>;
      for (var userResult in parsed) {
        results.add(User.fromJson(userResult));
      }
    } else {
      throw (Errors.FindingUsers);
    }

    return results;
  }

  Future<List<User>> findFriends(String userID, String filter) async {
    // TODO add catch and return INTERNAL ERROR if the API is down
    var response = await client.get(
        "$_baseUrl/users/$userID/friendships?filter=$filter",
        headers: {"Content-Type": 'application/json'});

    var friends = List<User>();
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body) as List<dynamic>;
      for (var friend in parsed) {
        friends.add(User.fromJson(friend));
      }
    } else {
      throw (Errors.FindingUsers);
    }

    return friends;
  }

  Future<Friendship> createFriendship(Friendship friendship) async {
    print("Api => createFriendship");
    String jsonBody = json.encode(friendship.toJson());
    // TODO add catch and return INTERNAL ERROR if the API is down
    var response = await client.post(
        "$_baseUrl/users/${friendship.actionUserID}/friendships",
        headers: {"Content-Type": 'application/json'},
        body: jsonBody);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return Friendship.fromJson(parsed);
    }
    print("API => ERROR");
    throw ("Error creating friendship"); // TODO create constant
  }

  Future updateFriendship(Friendship friendship) async {
    print("Api => updateFriendship");
    String jsonBody = json.encode(friendship.toJson());
    // TODO add catch and return INTERNAL ERROR if the API is down
    var response = await client.put(
        "$_baseUrl/users/${friendship.actionUserID}/friendships",
        headers: {"Content-Type": 'application/json'},
        body: jsonBody);

    if (response.statusCode == 200 && response.body.isEmpty) {
      return null;
    }
    print("API => ERROR");
    throw ("Error updating friendship"); // TODO create constant
  }

  Future<Friendship> getFriendship(String userID, String otherUserID) async {
    print("Api => updateFriendship");
    // TODO add catch and return INTERNAL ERROR if the API is down
    var response = await client.get(
        "$_baseUrl/users/$userID/friendships/$otherUserID",
        headers: {"Content-Type": 'application/json'});

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return Friendship.fromJson(parsed);
    }

    throw ("Error getting friendship"); // TODO create constant
  }
}
