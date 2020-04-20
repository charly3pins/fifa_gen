import 'package:fifagen/core/models/user.dart';

class Group {
  String id;
  String name;
  List<User> members;

  Group({this.id, this.name, this.members});

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    return Group(
      id: parsedJson['id'],
      name: parsedJson['name'],
      members: parsedJson['members'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "members": members,
      };
}
