import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/authentication/models/auth.model.dart';
import 'package:app/modules/authentication/models/http_exception.dart';
import 'package:app/utils/environment.constants.dart';

class AuthService {
  static const FORGOT_PASSWORD_EXCEPTION = 'FORGOT_PASSWORD_EXCEPTION';
  static const FORGOT_PASSWORD_EXCEPTION_USER_NOT_FOUND =
      'FORGOT_PASSWORD_EXCEPTION_USER_NOT_FOUND';

  static const String AUTH_API_PATH = '${Environment.AUTH_BASE_URL}/auth';

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
      print('error ${e}');
      print('error ${e.response}');
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
}
