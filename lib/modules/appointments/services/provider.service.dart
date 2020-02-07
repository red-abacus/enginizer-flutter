import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-schedule.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/provider-service-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';
import 'package:http/http.dart' as http;

class ProviderService {
  static const String SERVICES_PATH =
      '${Environment.PROVIDERS_BASE_API}/services';

  static const String PROVIDERS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers';

  static const String APPOINTMENTS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers';

  static const String PROVIDER_SCHEDULE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_SCHEDULE_SUFFIX = "/schedule";

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

  Future<List<ServiceProviderSchedule>> getProviderSchedules(int providerId) async {
    final response =
    await http.get(buildProviderSchedulesPath(providerId));

    if (response.statusCode == 200) {
      List parsed = jsonDecode(response.body);
      return _mapProviderSchedules(parsed);
    } else
      throw Exception('PROVIDER_SERVICES_FAILED');
  }

  String buildProviderSchedulesPath(int providerId) {
    return PROVIDER_SCHEDULE_PREFIX +
        providerId.toString() +
        PROVIDER_SCHEDULE_SUFFIX;
  }

  List<ServiceProviderSchedule> _mapProviderSchedules(List response) {
    List<ServiceProviderSchedule> list = [];

    for(Map<String, dynamic> item in response) {
      list.add(ServiceProviderSchedule.fromJson(item));
    }

    return list;
  }
}
