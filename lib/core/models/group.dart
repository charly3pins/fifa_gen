import 'package:fifagen/core/models/member.dart';

class Group {
  String id;
  String name;
  List<Member> members;

  Group({this.id, this.name, this.members});

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    var parsedMembers = List<Member>();
    if (parsedJson['members'] != null) {
      for (var member in parsedJson['members'])
        parsedMembers.add(Member.fromJson(member));
    }
    return Group(
      id: parsedJson['id'],
      name: parsedJson['name'],
      members: parsedMembers,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "members": members,
      };
}
