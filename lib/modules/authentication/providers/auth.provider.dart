import 'dart:async';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/authentication/models/auth.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/authentication/services/auth.service.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:app/modules/shared/managers/permissions/permissions-appointment.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/locator/locator.manager.dart';
import 'package:app/utils/firebase/firebase_manager.dart';
import 'package:app/utils/jwt.helper.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final AuthService _authService = inject<AuthService>();
  final NotificationService _notificationService =
      inject<NotificationService>();

  String _token;
  List<User> users = [];

  ServiceProviderResponse serviceProviderResponse;

  bool get isAuth {
    return _token != null;
  }

  void setToken(String token) {
    _token = token;
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

  Future<bool> forgotPassword(String email) async {
    try {
      return _forgotPassword(email);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> logout() async {
    if (FirebaseManager.getInstance().fcmToken.isNotEmpty) {
      await unregister(FirebaseManager.getInstance().fcmToken);
    }

    LocatorManager.getInstance().logout();

    PermissionsManager.removeInstance();
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

    if (authUser != null) {
      PermissionsManager.getInstance().userRole = authUser.role;

      if (FirebaseManager.getInstance().fcmToken.isNotEmpty) {
        register(FirebaseManager.getInstance().fcmToken);
      }

      PermissionsManager.getInstance().initialise(authUser);

      if (PermissionsManager.getInstance().hasAccess(
          MainPermissions.Appointments,
          PermissionsAppointment.SHARE_APPOINTMENT_LOCATION)) {
        LocatorManager.getInstance().refresh();
      }
    }

    notifyListeners();

    return true;
  }

  Future<AuthResponse> _authenticate(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      _token = response.token;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
      prefs.setString("email", email);

      if (authUser != null) {
        PermissionsManager.getInstance().userRole = authUser.role;

        if (FirebaseManager.getInstance().fcmToken.isNotEmpty) {
          register(FirebaseManager.getInstance().fcmToken);
        }
        PermissionsManager.getInstance().initialise(authUser);

        if (PermissionsManager.getInstance().hasAccess(
            MainPermissions.Appointments,
            PermissionsAppointment.SHARE_APPOINTMENT_LOCATION)) {
          LocatorManager.getInstance().refresh();
        }
      }

      notifyListeners();
      return response;
    } catch (error) {
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

  Future<bool> _forgotPassword(String email) async {
    try {
      final response = await _authService.forgotPassword(email: email);
      notifyListeners();
      return response;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> register(String fcmToken) async {
    try {
      bool response = await this._notificationService.register(fcmToken);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> unregister(String fcmToken) async {
    try {
      bool response = await this._notificationService.unregister(fcmToken);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }
}
