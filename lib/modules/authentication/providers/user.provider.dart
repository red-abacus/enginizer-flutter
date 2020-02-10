import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/authentication/models/user-credentials.model.dart';
import 'package:enginizer_flutter/modules/authentication/services/user.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = inject<UserService>();

  UserCredentials userCredentials;

  @Deprecated(
      'The GET method for /users/credentials has been removed from the API')
  Future<void> getLoggedUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String email = prefs.get("email");

    if (email != null && email.isNotEmpty) {
      return _getUserCredentials(prefs.get("email"));
    }

    return null;
  }

  Future<UserCredentials> _getUserCredentials(String email) async {
    try {
      userCredentials = await _userService.getUserCredentials(email);
      return userCredentials;
    } catch (error) {
      throw error;
    }
  }
}
