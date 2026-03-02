import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  String email;
  String name;
  String lastName;
  String username;
  String password;
  String fileNum;
  int? schoolId;
  List? orders;
  int? balance;
  Map<String, dynamic>? token;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.lastName,
      required this.username,
      required this.password,
      required this.fileNum,
      required this.schoolId,
      this.orders,
      this.balance,
      this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      lastName: json["last_name"] ?? "",
      username: json["username"] ?? "",
      password: json["password"] ?? "",
      fileNum: json["file_num"] ?? "",
      schoolId: json["school_id"] ?? null,
      orders: json["orders"] ?? [],
      balance: json["balance"] ?? 0,
      token: json["token"] ?? {});

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "last_name": lastName,
        "username": username,
        "password": password,
        "file_num": fileNum,
        "school_id": schoolId,
        "orders": orders,
        "balance": balance,
        "token": token
      };
}
