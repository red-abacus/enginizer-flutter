import 'dart:convert';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';

class OrderService {
  Dio _dio = inject<Dio>();

  OrderService();

  static const String GET_ORDERS_EXCEPTION = 'GET_ORDERS_EXCEPTION';
  static const String GET_ORDER_DETAILS_EXCEPTION =
      'GET_ORDER_DETAILS_EXCEPTION';
  static const String ACCEPT_ORDER_EXCEPTION = 'ACCEPT_ORDER_EXCEPTION';
  static const String FINISH_ORDER_EXCEPTION = 'FINISH_ORDER_EXCEPTION';

  static String _GET_ORDERS_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/orders';
  static String _GET_ORDER_DETAILS_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/orders';
  static String _ACCEPT_ORDER_PATH_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/orders/';
  static String _ACCEPT_ORDER_PATH_SUFFX = '/accept';

  static String _FINISH_ORDER_PATH_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/orders/';
  static const String _FINISH_ORDER_PATH_SUFFX = '/finish';

  Future<AppointmentsResponse> getOrders(AppointmentsRequest request) async {
    try {
      final response =
          await _dio.get(_GET_ORDERS_PATH, queryParameters: request.toJson());
      if (response.statusCode == 200) {
        return AppointmentsResponse.fromJson(response.data);
      } else {
        throw Exception(GET_ORDERS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_ORDERS_EXCEPTION);
    }
  }

  Future<AppointmentDetail> getOrderDetails(int orderId) async {
    try {
      final response = await _dio.get(_GET_ORDER_DETAILS_PATH + '/${orderId}');
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(GET_ORDER_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_ORDERS_EXCEPTION);
    }
  }

  Future<AppointmentDetail> acceptOrder(
      int orderId, String deliveryDateTime) async {
    try {
      final response = await _dio.patch(_buildAcceptOrderPath(orderId),
          data: jsonEncode({'deliveryDateTime': deliveryDateTime}));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(ACCEPT_ORDER_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ACCEPT_ORDER_EXCEPTION);
    }
  }

  Future<AppointmentDetail> finishOrder(int orderId) async {
    try {
      final response = await _dio.patch(_buildFinishOrderPath(orderId));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(ACCEPT_ORDER_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ACCEPT_ORDER_EXCEPTION);
    }
  }

  _buildAcceptOrderPath(int orderId) {
    return _ACCEPT_ORDER_PATH_PREFIX +
        orderId.toString() +
        _ACCEPT_ORDER_PATH_SUFFX;
  }

  _buildFinishOrderPath(int orderId) {
    return _FINISH_ORDER_PATH_PREFIX +
        orderId.toString() +
        _FINISH_ORDER_PATH_SUFFX;
  }
}
