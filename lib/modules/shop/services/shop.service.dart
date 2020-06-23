import 'dart:convert';

import 'package:app/config/injection.dart';
import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';

class ShopService {
  ShopService();

  Dio _dio = inject<Dio>();

  static const String ADD_SHOP_ALERT_EXCEPTION = 'ADD_SHOP_ALERT_EXCEPTION';

  static const String _ADD_SHOP_ALERT_PATH =
      '${Environment.PROMOTIONS_BASE_API}/alerts';

  Future<ShopAlert> createShopAlert(ShopAlert shopAlert) async {
    try {
      final response = await _dio.post(_ADD_SHOP_ALERT_PATH,
          data: jsonEncode(shopAlert.toJson()));

      if (response.statusCode == 200) {
        return ShopAlert.fromJson(response.data);
      } else {
        throw Exception(ADD_SHOP_ALERT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_SHOP_ALERT_EXCEPTION);
    }
  }
}
