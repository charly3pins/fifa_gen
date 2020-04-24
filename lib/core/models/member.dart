class Member {
  String id;
  String name;
  String username;
  String profilePicture;
  bool isAdmin;

  Member(
      {this.id, this.name, this.username, this.profilePicture, this.isAdmin});

  factory Member.fromJson(Map<String, dynamic> parsedJson) {
    return Member(
      id: parsedJson['id'],
      name: parsedJson['name'],
      username: parsedJson['username'],
      profilePicture: parsedJson['profilePicture'],
      isAdmin: parsedJson['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "profilePicture": profilePicture,
        "isAdmin": isAdmin,
      };
}
