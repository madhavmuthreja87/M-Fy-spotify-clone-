import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  //--------------------SIGN UP -------------------------
  Future<bool> signUp(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await authService.SignUp(email, password);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //--------------- LOGIN USING EMAIL AND PASSWORD -----------------------------
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await authService.logIn(email, password);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
