import 'dart:io';

import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/utils/environment.constants.dart';

class UserService {
  static const String GET_USER_DETAILS_PATH = '${Environment.USERS_BASE_API}/users/';
  static const String UPDATE_USER_DETAILS_PATH = '${Environment.USERS_BASE_API}/users/credentials';

  Dio _dio = inject<Dio>();

  UserService();

  Future<JwtUserDetails> getUserDetails(int userId) async {
    var response;

    try {
      response = await _dio.get(GET_USER_DETAILS_PATH + userId.toString(),
          options: Options(contentType: ContentType.json.toString()));
    } catch (e) {
      if (e.response.statusCode == 401) {
        throw HttpException('INVALID_USER');
      } else {
        throw HttpException('SERVER_FAIL');
      }
    }

    return JwtUserDetails.fromJson(response.data);
  }

  Future<JwtUserDetails> updateUserDetails(int userId, String payload) async {
    var response;

    try {
      response = await _dio.post(UPDATE_USER_DETAILS_PATH,
          data: payload,
          options: Options(contentType: ContentType.json.toString()));
    } catch (e) {
      if (e.response.statusCode == 401) {
        throw HttpException('USER_DETAILS_UPDATE_FAIL');
      } else {
        throw HttpException('SERVER_FAIL');
      }
    }

    return JwtUserDetails.fromJson(response.data);
  }
}