import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/authentication/models/user-credentials.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class UserService {
  static const String GET_USER_CREDENTIALS_API_PATH = '${Environment.USERS_BASE_API}/users/credentials';

  static const headers = {'Content-Type': 'application/json'};

  Dio _dio = inject<Dio>();

  UserService();

  Future<UserCredentials> getUserCredentials(String email) async {
    var response;

    try {
      response = await _dio.get(GET_USER_CREDENTIALS_API_PATH,
          options: Options(contentType: ContentType.json.toString()),
          queryParameters: {"email": email});
    } catch (e) {
      if (e.response.statusCode == 401) {
        throw HttpException('INVALID_USER');
      } else {
        throw HttpException('SERVER_FAIL');
      }
    }

    return UserCredentials.fromJson(response.data);
  }
}