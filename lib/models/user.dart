import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  String name;
  String lastName;
  String username;
  String password;
  String fileNum;

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.username,
    required this.password,
    required this.fileNum,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        username: json["username"],
        password: json["password"],
        fileNum: json["file_num"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "username": username,
        "password": password,
        "file_num": fileNum,
      };
}
