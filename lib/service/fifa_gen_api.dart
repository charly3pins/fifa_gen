import 'package:fifagen/model/friendship.dart';
import 'package:fifagen/model/user.dart';
import 'package:fifagen/model/notifications.dart';

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

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<List<User>> findUsers(String username) async {
    final response = await http.get(
        baseURL + "/users" + "?username=" + username,
        headers: {"Content-Type": 'application/json'});

    List<User> users = [];
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i++) {
        users.add(User.fromJSON(jsonData[i]));
      }

      return users;
    }

    return Future.error(response.body);
  }

  Future<Friendship> createFriendRequest(Friendship friend) async {
    String jsonBody = json.encode(friend.toJSON());
    final response = await http.post(baseURL + "/friendship",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Friendship.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<Friendship> getFriendship(Friendship friend) async {
    final response = await http.get(
        baseURL +
            "/friendship" +
            "?userOne=" +
            friend.userOneID +
            "&userTwo=" +
            friend.userTwoID,
        headers: {"Content-Type": 'application/json'});

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return null;
      }
      final jsonData = json.decode(response.body);
      return Friendship.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<Notifications> findNotifications(String id) async {
    final response = await http.get(baseURL + "/notifications" + "?id=" + id,
        headers: {"Content-Type": 'application/json'});

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Notifications.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }
}
