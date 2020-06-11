import 'dart:convert';
import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/modules/promotions/models/request/create-promotion-request.model.dart';
import 'package:app/modules/promotions/models/request/promotions-request.model.dart';
import 'package:app/modules/promotions/models/response/promotions.response.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class PromotionService {
  Dio _dio = inject<Dio>();

  PromotionService();

  static const String GET_PROMOTIONS_EXCEPTION = 'GET_PROMOTIONS_EXCEPTION';
  static const String ADD_PROMOTION_EXCEPTION = 'ADD_PROMOTION_EXCEPTION';
  static const String ADD_PROMOTION_IMAGES_EXCEPTION =
      'ADD_PROMOTION_IMAGES_EXCEPTION';
  static const String EDIT_PROMOTION_EXCEPTION = 'EDIT_PROMOTION_EXCEPTION';
  static const String DELETE_PROMOTION_IMAGE_EXCEPTION =
      'DELETE_PROMOTION_IMAGE_EXCEPTION';

  static const String _GET_PROMOTIONS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _GET_PROMOTIONS_SUFFIX = '/promotions';

  static const String _ADD_PROMOTION_IMAGES_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _ADD_PROMOTION_IMAGES_MIDDLE = '/promotions/';
  static const String _ADD_PROMOTION_IMAGES_SUFFIX = '/images';

  Future<PromotionsResponse> getPromotions(PromotionsRequest request) async {
    try {
      final response = await _dio.get(
          _buildGetPromotionsPath(request.providerId),
          queryParameters: request.toJson());
      if (response.statusCode == 200) {
        return PromotionsResponse.fromJson(response.data);
      } else {
        throw Exception(GET_PROMOTIONS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROMOTIONS_EXCEPTION);
    }
  }

  Future<Promotion> addPromotion(
      CreatePromotionRequest createPromotionRequest) async {
    try {
      final response = await _dio.post(
          _buildGetPromotionsPath(createPromotionRequest.providerId),
          data: jsonEncode(createPromotionRequest.toJson()));
      if (response.statusCode == 200) {
        return Promotion.fromJson(response.data);
      } else {
        throw Exception(ADD_PROMOTION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_PROMOTION_EXCEPTION);
    }
  }

  Future<Promotion> editPromotion(
      CreatePromotionRequest createPromotionRequest) async {
    print(
        'path ${_buildEditPromotionPath(createPromotionRequest.providerId, createPromotionRequest.promotionId)}');
    try {
      final response = await _dio.put(
          _buildEditPromotionPath(createPromotionRequest.providerId,
              createPromotionRequest.promotionId),
          data: jsonEncode(createPromotionRequest.toJson()));
      if (response.statusCode == 200) {
        return Promotion.fromJson(response.data);
      } else {
        throw Exception(EDIT_PROMOTION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(EDIT_PROMOTION_EXCEPTION);
    }
  }

  Future<List<GenericModel>> addPromotionImages(
      int providerId, int promotionId, List<File> images) async {
    var formData = FormData();

    for (File image in images) {
      formData.files.add(MapEntry(
        "files",
        await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last,
            contentType: MediaType('image', image.path.split('.').last)),
      ));
    }

    try {
      final response = await _dio.patch(
          _buildAddPromotionImagesPath(providerId, promotionId),
          data: formData);

      if (response.statusCode == 200) {
        return _mapPromotionsImages(response.data);
      } else {
        throw Exception(ADD_PROMOTION_IMAGES_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_PROMOTION_IMAGES_EXCEPTION);
    }
  }

  Future<bool> deletePromotionImage(
      int providerId, int promotionId, int imageId) async {
    try {
      final response = await _dio.delete(_buildDeletePromotionImagesPath(providerId, promotionId, imageId));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(DELETE_PROMOTION_IMAGE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(DELETE_PROMOTION_IMAGE_EXCEPTION);
    }
  }

  _buildGetPromotionsPath(int providerId) {
    return _GET_PROMOTIONS_PREFIX +
        providerId.toString() +
        _GET_PROMOTIONS_SUFFIX;
  }

  _buildEditPromotionPath(int providerId, int promotionId) {
    return _GET_PROMOTIONS_PREFIX +
        providerId.toString() +
        _GET_PROMOTIONS_SUFFIX +
        '/${promotionId.toString()}';
  }

  _buildAddPromotionImagesPath(int providerId, int promotionId) {
    return _ADD_PROMOTION_IMAGES_PREFIX +
        providerId.toString() +
        _ADD_PROMOTION_IMAGES_MIDDLE +
        promotionId.toString() +
        _ADD_PROMOTION_IMAGES_SUFFIX;
  }

  _buildDeletePromotionImagesPath(
      int providerId, int promotionId, int imageId) {
    return _ADD_PROMOTION_IMAGES_PREFIX +
        providerId.toString() +
        _ADD_PROMOTION_IMAGES_MIDDLE +
        promotionId.toString() +
        _ADD_PROMOTION_IMAGES_SUFFIX +
        '/${imageId.toString()}';
  }

  _mapPromotionsImages(List<dynamic> response) {
    List<GenericModel> list = [];
    response.forEach((item) {
      list.add(GenericModel.imageFromJson(item));
    });
    return list;
  }
}
