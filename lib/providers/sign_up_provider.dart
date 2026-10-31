import 'package:flutter/material.dart';

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

  void setArtists(List<String> value) {
    artists = value;
    notifyListeners();
  }

  void setGenres(List<String> value) {
    genres = value;
    notifyListeners();
  }
}
