import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/authentication/models/auth.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/http_exception.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class AuthService {
  static const String AUTH_API_PATH = '${Environment.API_BASE_URL}/auth';
  static const headers = {'Content-Type': 'application/json'};

  Dio _dio = inject<Dio>();

  AuthService();

  Future<AuthResponse> login(String email, String password) async {
    var payload = json.encode({'email': email, 'password': password});
    var response;
    try {
      response = await _dio.post('$AUTH_API_PATH/login',
          data: payload,
          options: Options(contentType: ContentType.json.toString()));
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
}
