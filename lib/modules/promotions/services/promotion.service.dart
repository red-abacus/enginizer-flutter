import 'package:app/config/injection.dart';
import 'package:app/modules/promotions/models/request/promotions-request.model.dart';
import 'package:app/modules/promotions/models/response/promotions.response.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';

class PromotionService {
  Dio _dio = inject<Dio>();

  PromotionService();

  static const String GET_PROMOTIONS_EXCEPTION = 'GET_PROMOTIONS_EXCEPTION';
  static const String _GET_PROMOTIONS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _GET_PROMOTIONS_SUFFIX = '/promotions';

  Future<PromotionsResponse> getPromotions(
      PromotionsRequest request) async {
    try {
      final response = await _dio.get(_buildGetPromotionsPath(request.providerId),
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

  _buildGetPromotionsPath(int providerId) {
    return _GET_PROMOTIONS_PREFIX +
        providerId.toString() +
        _GET_PROMOTIONS_SUFFIX;
  }
}
