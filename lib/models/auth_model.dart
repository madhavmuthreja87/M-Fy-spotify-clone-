import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  final String UID;
  final String name;
  final String email;
  final String pic;
  final String gender;
  final String username;
  final DateTime dob;
  final List<String> languages;
  final List<String> artists;
  final List<String> genres;

  AuthModel({
    required this.UID,
    required this.name,
    required this.email,
    required this.pic,
    required this.gender,
    required this.username,
    required this.dob,
    required this.languages,
    required this.artists,
    required this.genres,
  });

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      UID: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      pic: map['pic'],
      gender: map['gender'],
      username: map['username'] ?? '',
      dob: map['dob'] ?? DateTime.now(),
      languages: List<String>.from(map['languages'] ?? []),
      artists: List<String>.from(map['artists'] ?? []),
      genres: List<String>.from(map['genres'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': UID,
      'name': name,
      'email': email,
      'pic': pic,
      'gender': gender,
      'username': username,
      'dob': Timestamp.fromDate(dob),
      'languages': languages,
      'artists': artists,
      'genres': genres,
    };
  }
}
