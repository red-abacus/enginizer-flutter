import 'dart:convert';

import 'package:app/config/injection.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/authentication/services/user.service.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = inject<UserService>();

  JwtUserDetails userDetails;

  String email = "";
  String name = "";

  String currentPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";

  initialiseParams() {
    email = this.userDetails?.email;
    name = this.userDetails?.name;
  }

  Future<JwtUserDetails> getUserDetails() async {
    this.userDetails = await _userService.getUserDetails(userDetails.id);
    notifyListeners();
    return this.userDetails;
  }

  Future<JwtUserDetails> updateUserDetails(String email, String name) async {
    var payload = json.encode({'email': email, 'name': name});

    this.userDetails = await _userService.updateUserDetails(userDetails.id, payload);
    notifyListeners();
    return this.userDetails;
  }
}
