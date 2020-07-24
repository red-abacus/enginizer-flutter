import 'package:app/modules/dashboard/models/reports.model.dart';
import 'package:app/modules/dashboard/models/request/reports-request.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/utils/environment.constants.dart';

class ReportsService {
  Dio _dio = inject<Dio>();

  ReportsService();

  static const String GET_REPORTS_EXCEPTION = 'GET_REPORTS_EXCEPTION';

  static String _GET_REPORTS_PATH = '${Environment.REPORTS_BASE_API}/reports/car/costs';

  Future<Reports> getReports(ReportsRequest reportsRequest) async {
    try {
      final response =
      await _dio.get(_GET_REPORTS_PATH, queryParameters: reportsRequest.toJson());

      if (response.statusCode < 300) {
        return Reports.fromJson(response.data);
      } else {
        throw Exception(GET_REPORTS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_REPORTS_EXCEPTION);
    }
  }
}
