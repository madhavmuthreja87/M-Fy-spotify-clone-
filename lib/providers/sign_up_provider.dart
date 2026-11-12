import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SignUpProvider extends ChangeNotifier {
  String name = '';
  String email = '';
  String username = '';
  String pic = '';
  String gender = '';

  DateTime? dob;

  List<String> languages = [];
  List<String> artists = [];
  List<String> genres = [];

  final Box artistsBox = Hive.box("artistsBox");

  Future<void> restoreProfileFromCloud() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw Exception('User not logged in');
    }

    final userDocId =
        '${user.email!.split('@').first}__${user.uid.substring(0, 3)}';

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .get();

    if (!snapshot.exists) {
      throw Exception('User document not found');
    }

    final data = snapshot.data()!;

    final List<String> cloudArtists = List<String>.from(data['artists'] ?? []);

    await artistsBox.clear();

    for (final artist in cloudArtists) {
      await artistsBox.put(artist, {"name": artist});
    }

    artists = cloudArtists;

    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setUsetname(String value) {
    username = value;
    notifyListeners();
  }

  void setPic(String value) {
    pic = value;
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setDOB(DateTime date) {
    dob = date;
    notifyListeners();
  }

  void setLanguages(List<String> value) {
    languages = value;
    notifyListeners();
  }

  Future<void> setArtists(List<String> value) async {
    artists = value;
    for (String v in value) {
      await artistsBox.put(v, {'name': v});
    }
    notifyListeners();
  }

  List<Map> artistsList() =>
      artistsBox.values.map((a) => Map<String, dynamic>.from(a)).toList();

  void setGenres(List<String> value) {
    genres = value;
    notifyListeners();
  }

  Future<void> clearUserProfile() async {
    name = '';
    email = '';
    username = '';
    pic = '';
    gender = '';
    dob = null;

    languages = [];
    artists = [];
    genres = [];

    await artistsBox.clear();
    notifyListeners();
  }
}
