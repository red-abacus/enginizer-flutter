import 'dart:io';

import 'package:app/modules/user-details/models/request/change-billing-info.model.dart';
import 'package:app/modules/user-details/models/request/update-user-request.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/utils/environment.constants.dart';

import 'package:http_parser/http_parser.dart';

class UserService {
  static const String GET_USER_DETAILS_EXCEPTION = 'GET_USER_DETAILS_EXCEPTION';
  static const String UPLOAD_USER_PROFILE_IMAGE_EXCEPTION =
      'UPLOAD_USER_PROFILE_IMAGE_EXCEPTION';
  static const String UPDATE_USER_DETAILS_EXCEPTION =
      'UPDATE_USER_DETAILS_EXCEPTION';

  static const String _GET_USER_DETAILS_PATH =
      '${Environment.USERS_BASE_API}/users/';

  static const String _UPLOAD_USER_PROFILE_IMAGE_PREFIX =
      '${Environment.USERS_BASE_API}/users/';
  static const String _UPLOAD_USER_PROFILE_IMAGE_SUFFIX = '/image';

  Dio _dio = inject<Dio>();

  UserService();

  Future<JwtUserDetails> getUserDetails(int userId) async {
    try {
      var response = await _dio.get(_GET_USER_DETAILS_PATH + userId.toString(),
          options: Options(contentType: ContentType.json.toString()));
      return JwtUserDetails.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 401) {
        throw Exception(GET_USER_DETAILS_EXCEPTION);
      } else {
        throw Exception(GET_USER_DETAILS_EXCEPTION);
      }
    }
  }

  Future<JwtUserDetails> updateUserDetails(
      UpdateUserRequest updateUserRequest) async {
    try {
      var response = await _dio.patch(
          _GET_USER_DETAILS_PATH + updateUserRequest.userId.toString(),
          data: updateUserRequest.toJson(),
          options: Options(contentType: ContentType.json.toString()));

      if (response.statusCode == 200) {
        return JwtUserDetails.fromJson(response.data);
      }
    } catch (e) {
      throw HttpException(UPDATE_USER_DETAILS_EXCEPTION);
    }
  }

  Future<JwtUserDetails> updateUserBillingInfo(
      ChangeBillingInfoRequest changeBillingInfo) async {
    try {
      var response = await _dio.patch(
          _GET_USER_DETAILS_PATH + changeBillingInfo.userId.toString(),
          data: changeBillingInfo.toJson(),
          options: Options(contentType: ContentType.json.toString()));

      if (response.statusCode == 200) {
        return JwtUserDetails.fromJson(response.data);
      }
    } catch (e) {
      throw HttpException(UPDATE_USER_DETAILS_EXCEPTION);
    }
  }

  Future<String> uploadImage(File file, int userId) async {
    var formData = FormData();

    formData.files.add(MapEntry(
      "file",
      await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('image', file.path.split('.').last)),
    ));

    try {
      final response =
          await _dio.patch(_buildUploadUserImage(userId), data: formData);
      if (response.statusCode < 300) {
        return response.data;
      } else {
        throw Exception(UPLOAD_USER_PROFILE_IMAGE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(UPLOAD_USER_PROFILE_IMAGE_EXCEPTION);
    }
  }

  _buildUploadUserImage(int userId) {
    return _UPLOAD_USER_PROFILE_IMAGE_PREFIX +
        userId.toString() +
        _UPLOAD_USER_PROFILE_IMAGE_SUFFIX;
  }
}
