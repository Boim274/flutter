import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? email;
  String? uid;
  String? name;
  int? score;
  int? coins;
  String? photoUrl;
  Timestamp? createAt;
  Timestamp? lastLoginAt;

  UserModel({
    this.email,
    this.uid,
    this.name,
    this.photoUrl,
    this.score,
    this.coins,
    this.createAt,
    this.lastLoginAt,
  });

  // Factory constructor to create a UserModel instance from Firestore document data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      uid: json["uid"],
      name: json["name"],
      photoUrl: json["photoUrl"],
      score: json["score"] ?? 0, // Default to 0 if not present
      coins: json["coins"] ?? 0, // Default to 0 if not present
      createAt: json["createAt"] is Timestamp ? json["createAt"] : null,
      lastLoginAt:
          json["lastLoginAt"] is Timestamp ? json["lastLoginAt"] : null,
    );
  }

  // Method to convert UserModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "uid": uid,
      "name": name,
      "photoUrl": photoUrl,
      "score": score,
      "coins": coins,
      "createAt": createAt,
      "lastLoginAt": lastLoginAt,
    };
  }
}
