import 'dart:convert';
import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/authentication/services/auth.service.dart';
import 'package:app/modules/authentication/services/user.service.dart';
import 'package:app/modules/user-details/models/request/change-billing-info.model.dart';
import 'package:app/modules/user-details/models/request/change-password-request.model.dart';
import 'package:app/modules/user-details/models/request/update-user-request.model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = inject<UserService>();
  final AuthService _authService = inject<AuthService>();

  JwtUserDetails userDetails;

  UpdateUserRequest updateUserRequest;
  ChangePasswordRequest changePasswordRequest;
  ChangeBillingInfoRequest changeBillingInfoRequest;

  String currentPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";

  initialiseParams() {}

  Future<JwtUserDetails> getUserDetails(int userId) async {
    try {
      this.userDetails = await _userService.getUserDetails(userId);
      notifyListeners();
      updateUserRequest = UpdateUserRequest.fromUserDetails(this.userDetails);
      changeBillingInfoRequest =
          ChangeBillingInfoRequest.fromUserDetails(this.userDetails);
      return this.userDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<JwtUserDetails> updateUserDetails(
      UpdateUserRequest updateUserRequest) async {
    try {
      this.userDetails =
          await _userService.updateUserDetails(updateUserRequest);
      notifyListeners();
      return this.userDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<JwtUserDetails> updateUserBillingInfo(
      ChangeBillingInfoRequest changeBillingInfoRequest) async {
    try {
      this.userDetails =
          await _userService.updateUserBillingInfo(changeBillingInfoRequest);
      notifyListeners();
      return this.userDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<String> uploadUserProfileImage(File file, int userId) async {
    try {
      var response = await _userService.uploadImage(file, userId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<String> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    try {
      var response = await _authService.changePassword(changePasswordRequest);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }
}
