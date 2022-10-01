import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  ///  {
  ///    "createdAt": DATE,
  ///    "id": STRING,
  ///    "username": STRING,
  ///    "email": STRING,
  ///    "fullName": STRING,
  ///    "profileImageUrl": STRING,
  ///  }

  DateTime createdAt;
  String id;
  String username;
  String email;
  String fullName;
  String profileImageUrl;

  UserModel({
    required this.createdAt,
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.profileImageUrl,
  });

  static UserModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      return UserModel(
        createdAt: snapshot.data()?["createdAt"] is String ? DateTime.parse(snapshot.data()?["createdAt"]) : snapshot.data()?["createdAt"].toDate(),
        id: snapshot.data()?["id"],
        username: snapshot.data()?["username"],
        email: snapshot.data()?["email"],
        fullName: snapshot.data()?["fullName"],
        profileImageUrl: snapshot.data()?["profileImageUrl"],
      );
    } catch (e) {
      throw "Error trying to convert user from Firestore to UserModel";
    }
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        createdAt: map["createdAt"] is String ? DateTime.parse(map["createdAt"]) : map["createdAt"].toDate(),
        id: map["id"],
        username: map["username"],
        email: map["email"],
        fullName: map["fullName"],
        profileImageUrl: map["profileImageUrl"],
      );
    } catch (e) {
      throw "Error trying to convert user from Firestore to UserModel";
    }
  }
}
