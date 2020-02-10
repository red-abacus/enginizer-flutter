import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/provider-service-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class ProviderService {
  static const String SERVICES_PATH =
      '${Environment.PROVIDERS_BASE_API}/services';

  static const String PROVIDERS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers';
  static const int DAYS_BETWEEN_START_AND_END_DATE = 6;

  Dio _dio = inject<Dio>();

  ProviderService();

  Future<ProviderServiceResponse> getServices() async {
    final response = await _dio.get(SERVICES_PATH);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapServices(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_SERVICES_FAILED');
    }
  }

  Future<ServiceProviderResponse> getProviders() async {
    final response = await _dio.get(PROVIDERS_PATH);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapProviders(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_PROVIDERS_FAILED');
    }
  }

  Future<List<DateEntry>> scheduleItems(providerId) async {
    final response = await _dio.get(SERVICES_PATH);
  }

  _mapServices(Map<String, dynamic> commingServices) {
    var response = ProviderServiceResponse.fromJson(commingServices);
    return response;
  }

  _mapProviders(Map<String, dynamic> commingServices) {
    var response = ServiceProviderResponse.fromJson(commingServices);
    return response;
  }

  // Get Provider Schedules

  Future<List<ServiceProviderSchedule>> getProviderSchedules(
      int providerId) async {
    var providersURL;

    if (providerId != null) {
      providersURL = '$PROVIDERS_PATH/$providerId/timetable';
    } else {
      providersURL = '$PROVIDERS_PATH/timetable';
    }

    DateTime startDate = new DateTime.now();
    startDate = new DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endDate =
        startDate.add(Duration(days: DAYS_BETWEEN_START_AND_END_DATE));

    final response = await _dio.get(providersURL, queryParameters: {
      "startDate": Constants.date.format(startDate),
      "endDate": Constants.date.format(endDate)
    });

    if (response.statusCode == 200) {
      return _mapProviderSchedules(response.data);
    } else
      throw Exception('PROVIDER_SERVICES_FAILED');
  }

  List<ServiceProviderSchedule> _mapProviderSchedules(List response) {
    List<ServiceProviderSchedule> list = [];

    for (Map<String, dynamic> item in response) {
      list.add(ServiceProviderSchedule.fromJson(item));
    }

    return list;
  }
}
