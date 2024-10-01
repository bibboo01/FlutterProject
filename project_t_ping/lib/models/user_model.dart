import 'dart:convert';

User welcomeFromJson(String str) => User.fromJson(json.decode(str));

String welcomeToJson(User data) => json.encode(data.toJson());

class User {
  userModel user;
  Token token;

  User({
    required this.user,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: userModel.fromJson(json["user"]),
        token: Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token.toJson(),
      };
}

class Token {
  String accessToken;
  String refreshToken;

  Token({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class userModel {
  String id;
  String username;
  String email;
  int role;

  userModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory userModel.fromJson(Map<String, dynamic> json) => userModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "role": role,
      };
}
