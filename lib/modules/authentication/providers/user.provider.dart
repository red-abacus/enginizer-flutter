import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/authentication/models/unit-provider.model.dart';
import 'package:app/modules/authentication/services/auth.service.dart';
import 'package:app/modules/authentication/services/user.service.dart';
import 'package:app/modules/user-details/models/request/change-billing-info.model.dart';
import 'package:app/modules/user-details/models/request/change-password-request.model.dart';
import 'package:app/modules/user-details/models/request/update-unit-request.model.dart';
import 'package:app/modules/user-details/models/request/update-user-request.model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = inject<UserService>();
  final AuthService _authService = inject<AuthService>();
  final ProviderService _providerService = inject<ProviderService>();

  JwtUserDetails userDetails;
  ServiceProvider serviceProvider;

  UpdateUserRequest updateUserRequest;
  ChangePasswordRequest changePasswordRequest;
  ChangeBillingInfoRequest changeBillingInfoRequest;
  UpdateUnitRequest updateUnitRequest;

  String currentPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";

  initialiseParams() {
    updateUserRequest = UpdateUserRequest.fromUserDetails(this.userDetails);
    changeBillingInfoRequest =
        ChangeBillingInfoRequest.fromUserDetails(this.userDetails);
    updateUnitRequest = UpdateUnitRequest.fromUserDetails(this.serviceProvider);
  }

  Future<JwtUserDetails> getUserDetails(int userId) async {
    try {
      this.userDetails = await _userService.getUserDetails(userId);
      notifyListeners();
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

  Future<String> uploadProviderImage(File file, int providerId) async {
    try {
      var response =
          await _providerService.uploadProviderProfileImage(file, providerId);
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

  Future<UnitProvider> editProvider(UpdateUnitRequest updateUnitRequest) async {
    try {
      UnitProvider response =
          await _providerService.editProvider(updateUnitRequest);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<ServiceProvider> getServiceProvider(int providerId) async {
    try {
      serviceProvider =
      await _providerService.getProviderDetails(providerId);
      notifyListeners();
      return serviceProvider;
    } catch (error) {
      throw (error);
    }
  }
}
