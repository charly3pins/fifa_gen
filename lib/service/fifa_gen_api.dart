import 'package:fifagen/model/friend.dart';

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

  Future<Friend> sendFriendRequest(Friend friend) async {
    String jsonBody = json.encode(friend.toJSON());
    final response = await http.post(baseURL + "/friends",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Friend.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<Friend> getFriendship(Friend friend) async {
    final response = await http.get(
        baseURL +
            "/friends" +
            "?sender=" +
            friend.sender +
            "&receiver=" +
            friend.receiver,
        headers: {"Content-Type": 'application/json'});

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Friend.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<int> getNotifications(String id) async {
    final response = await http.get(baseURL + "/notifications" + "?id=" + id,
        headers: {"Content-Type": 'application/json'});

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    }

    return Future.error(response.body);
  }
}
