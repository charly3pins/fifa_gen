class User {
  final String id;
  String name;
  String username;
  String password;

  User({this.id, this.name, this.username, this.password});

  factory User.fromJSON(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'],
      name: parsedJson['name'],
      username: parsedJson['username'],
      password: parsedJson['password'],
    );
  }

  Map<String, dynamic> toJSON() => {
        "name": name,
        "username": username,
        "password": password,
      };
}
