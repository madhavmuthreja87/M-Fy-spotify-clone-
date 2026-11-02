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
}
