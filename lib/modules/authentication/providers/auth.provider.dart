import 'dart:async';

import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/authentication/models/auth.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/user.model.dart';
import 'package:enginizer_flutter/modules/authentication/services/auth.service.dart';
import 'package:enginizer_flutter/utils/jwt.helper.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final AuthService _authService = inject<AuthService>();

  String _token;
  List<User> users = [];

  bool get isAuth {
    return _token != null;
  }

  JwtUser get authUser {
    if (_token == null) {
      return null;
    }
    final jwtUser = JwtHelper.parseJwt(_token);
    return JwtUser.fromJson(jwtUser);
  }

  Future<void> signup(String name, String email, String password,
      String confirmPassword, String type) async {
    return _register(name, email, password, confirmPassword, type);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove("email");
    prefs.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('token')) {
      return false;
    }

    _token = prefs.getString('token');

    notifyListeners();

    return true;
  }

  Future<AuthResponse> _authenticate(String email, String password) async {
    try {
      print("try logon !");
      final response = await _authService.login(email, password);
      print("finish !");
      _token = response.token;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
      prefs.setString("email", email);
      notifyListeners();
      return response;
    } catch (error) {
      print("error ? ${error}");
      throw error;
    }
  }

  Future<AuthResponse> _register(String name, String email, String password,
      String confirmPassword, String type) async {
    try {
      final response = await _authService.register(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          type: type);
      _token = response.token;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
      prefs.setString("email", email);
      notifyListeners();
      return response;
    } catch (error) {
      throw error;
    }
  }
}
