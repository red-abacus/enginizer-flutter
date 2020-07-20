import 'dart:convert';
import 'dart:io';

import 'package:app/modules/user-details/models/request/change-password-request.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/authentication/models/auth.model.dart';
import 'package:app/modules/authentication/models/http_exception.dart';
import 'package:app/utils/environment.constants.dart';

class AuthService {
  static const FORGOT_PASSWORD_EXCEPTION = 'FORGOT_PASSWORD_EXCEPTION';
  static const FORGOT_PASSWORD_EXCEPTION_USER_NOT_FOUND =
      'FORGOT_PASSWORD_EXCEPTION_USER_NOT_FOUND';
  static const CHANGE_PASSWORD_EXCEPTION = 'CHANGE_PASSWORD_EXCEPTION';
  static const CHANGE_PASSWORD_OLD_PASSWORD_EXCEPTION = 'CHANGE_PASSWORD_OLD_PASSWORD_EXCEPTION';

  static const String AUTH_API_PATH = '${Environment.AUTH_BASE_URL}/auth';

  static const String _CHANGE_PASSWORD_PATH = '${Environment.AUTH_BASE_URL}/auth/changePassword';

  Dio _dio = inject<Dio>();

  AuthService();

  Future<AuthResponse> login(String email, String password) async {
    var payload = json.encode({'email': email, 'password': password});
    var response;
    try {
      response = await _dio.post('$AUTH_API_PATH/login',
          data: payload,
          options:
              Options(headers: {}, contentType: ContentType.json.toString()));
    } catch (e) {
      if (e.response.statusCode == 401) {
        throw HttpException('INVALID_CREDENTIALS');
      } else {
        throw HttpException('SERVER_FAIL');
      }
    }

    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> register(
      {String name,
      String email,
      String password,
      String confirmPassword,
      String type}) async {
    var payload = json.encode({
      "name": name,
      "email": email,
      "confirmPassword": confirmPassword,
      "password": password,
      "userType": type
    });
    var response;
    try {
      response = await _dio.post('$AUTH_API_PATH/register', data: payload);
    } catch (e) {
      if (e.response.statusCode == 401) {
        throw HttpException('INVALID_CREDENTIALS');
      } else {
        throw HttpException('SERVER_FAIL');
      }
    }

    return AuthResponse.fromJson(response.data);
  }

  Future<bool> forgotPassword({String email}) async {
    var payload = json.encode({"email": email});
    try {
      final response =
          await _dio.post('$AUTH_API_PATH/forgotPassword', data: payload);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw (FORGOT_PASSWORD_EXCEPTION);
      }
    } catch (e) {
      if (e.response.statusCode == 404) {
        throw (FORGOT_PASSWORD_EXCEPTION_USER_NOT_FOUND);
      } else {
        throw (FORGOT_PASSWORD_EXCEPTION);
      }
    }
  }

  Future<String> changePassword(ChangePasswordRequest changePasswordRequest) async {
    try {
      final response =
          await _dio.post(_CHANGE_PASSWORD_PATH, data: changePasswordRequest.toJson());
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw (FORGOT_PASSWORD_EXCEPTION);
      }
    } catch (e) {
      if (e.response != null) {
        if (e.response.data['message'].contains('general.messages.400.changePassword.incorrectOldPassword')) {
          throw(CHANGE_PASSWORD_OLD_PASSWORD_EXCEPTION);
        }
        else {
          throw(CHANGE_PASSWORD_EXCEPTION);
        }
      }
      else {
        throw(CHANGE_PASSWORD_EXCEPTION);
      }
    }
  }
}
