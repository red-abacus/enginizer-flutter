import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';

class OrderService {
  Dio _dio = inject<Dio>();

  OrderService();

  static const String GET_ORDERS_EXCEPTION = 'GET_ORDERS_EXCEPTION';

  static const String _GET_ORDERS_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/orders';

  Future<AppointmentsResponse> getOrders(int page,
      {String status, String searchString, int pageSize}) async {
    Map<String, dynamic> queryParameters = {'page': '$page'};
    if (status != null) {
      queryParameters['status'] = status;
    }
    if (searchString != null) {
      queryParameters['search'] = searchString;
    }
    if (pageSize != null) {
      queryParameters['pageSize'] = '$pageSize';
    }

    try {
      final response = await _dio
          .get(_GET_ORDERS_PATH, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return AppointmentsResponse.fromJson(response.data);
      } else {
        throw Exception(GET_ORDERS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_ORDERS_EXCEPTION);
    }
  }
}