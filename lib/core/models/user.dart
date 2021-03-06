class User {
  String id;
  String name;
  String username;
  String password;
  String profilePicture;

  User({this.id, this.name, this.username, this.password, this.profilePicture});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'],
      name: parsedJson['name'],
      username: parsedJson['username'],
      password: parsedJson['password'],
      profilePicture: parsedJson['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "password": password,
        "profilePicture": profilePicture,
      };
}
