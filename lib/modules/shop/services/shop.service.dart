import 'dart:convert';

import 'package:app/config/injection.dart';
import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';

class ShopService {
  ShopService();

  Dio _dio = inject<Dio>();

  static const String ADD_SHOP_ALERT_EXCEPTION = 'ADD_SHOP_ALERT_EXCEPTION';
  static const String GET_SHOP_ALERTS_EXCEPTION = 'GET_SHOP_ALERTS_EXCEPTION';
  static const String REMOVE_SHOP_ALERT_EXCEPTION =
      'REMOVE_SHOP_ALERT_EXCEPTION';
  static const String EDIT_SHOP_ALERT_EXCEPTION = 'EDIT_SHOP_ALERT_EXCEPTION';

  static const String _GET_SHOP_ALERTS_PATH =
      '${Environment.PROMOTIONS_BASE_API}/alerts';

  static const String _ADD_SHOP_ALERT_PATH =
      '${Environment.PROMOTIONS_BASE_API}/alerts';

  static const String _REMOVE_SHOP_ALERT_PATH =
      '${Environment.PROMOTIONS_BASE_API}/alerts/';

  Future<List<ShopAlert>> getShopAlerts() async {
    try {
      final response = await _dio.get(_GET_SHOP_ALERTS_PATH);

      if (response.statusCode == 200) {
        return _mapShopAlerts(response.data);
      } else {
        throw Exception(GET_SHOP_ALERTS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_SHOP_ALERTS_EXCEPTION);
    }
  }

  Future<bool> createShopAlert(ShopAlert shopAlert) async {
    try {
      final response = await _dio.post(_ADD_SHOP_ALERT_PATH,
          data: jsonEncode(shopAlert.toJson()));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(ADD_SHOP_ALERT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_SHOP_ALERT_EXCEPTION);
    }
  }

  Future<bool> editShopAlert(ShopAlert shopAlert) async {
    try {
      final response = await _dio.put(_ADD_SHOP_ALERT_PATH,
          data: jsonEncode(shopAlert.toJson()));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(EDIT_SHOP_ALERT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(EDIT_SHOP_ALERT_EXCEPTION);
    }
  }

  Future<bool> removeShopAlert(ShopAlert shopAlert) async {
    try {
      final response = await _dio.delete(_buildRemoveAlertPath(shopAlert.id));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(REMOVE_SHOP_ALERT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(REMOVE_SHOP_ALERT_EXCEPTION);
    }
  }

  _buildRemoveAlertPath(int alertId) {
    return _REMOVE_SHOP_ALERT_PATH + alertId.toString();
  }

  _mapShopAlerts(List<dynamic> response) {
    List<ShopAlert> alerts = [];
    response.forEach((element) {
      alerts.add(ShopAlert.fromJson(element));
    });
    return alerts;
  }
}
