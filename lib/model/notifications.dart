import 'package:fifagen/model/user.dart';

class Notifications {
  List<User> friendRequests;

  Notifications({this.friendRequests});

  factory Notifications.fromJSON(Map<String, dynamic> parsedJson) {
    List<User> users = [];
    for (var i = 0; i < parsedJson["friendRequests"].length; i++) {
      users.add(User.fromJSON(parsedJson["friendRequests"][i]));
    }
    return Notifications(
      friendRequests: users,
    );
  }

  Map<String, dynamic> toJSON() => {
        "friendRequests": friendRequests,
      };
}
