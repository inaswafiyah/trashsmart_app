import 'dart:convert';

import 'package:trashsmart/data/model/response/avatar_response_model.dart';

class AuthResponseModel {
  final User? user;
  final String? token;

  AuthResponseModel({
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "token": token,
      };
}
class User {
  int? id;
  String? username;
  String? email;
  final int? avatarId;
  final Avatar? avatar;
  dynamic emailVerifiedAt;
  String? phone;
  String? role;
  dynamic createdAt;
  dynamic updatedAt;

  User({
    this.id,
    this.username,
    this.email,
    this.avatarId,
    this.avatar,
    this.emailVerifiedAt,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  // Getter for username with fallback
  String get safeUsername => username ?? 'User';

  // Setter methods
  void setUsername(String newUsername) {
    username = newUsername;
  }

  void setPhone(String newPhone) {
    phone = newPhone;
  }

  void setEmail(String newEmail) {
    email = newEmail;
  }

  // Tambahan: copyWith method
  User copyWith({
    int? id,
    String? username,
    String? email,
    int? avatarId,
    Avatar? avatar,
    dynamic emailVerifiedAt,
    String? phone,
    String? role,
    dynamic createdAt,
    dynamic updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarId: avatarId ?? this.avatarId,
      avatar: avatar ?? this.avatar,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        avatarId: json["avatar_id"],
        avatar: json["avatar"] == null ? null : Avatar.fromMap(json["avatar"]),
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"],
        role: json["role"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "avatar_id": avatarId,
        "avatar": avatar?.toMap(),
        "email_verified_at": emailVerifiedAt,
        "phone": phone,
        "role": role,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
