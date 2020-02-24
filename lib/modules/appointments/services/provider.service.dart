import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-client-review.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-review.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/provider-service-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/models/employee.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class ProviderService {
  static const String SERVICES_PATH =
      '${Environment.PROVIDERS_BASE_API}/services';

  static const String PROVIDERS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers';

  static const String PROVIDER_DETAILS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers/';

  static const String APPOINTMENTS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers';

  static const String PROVIDER_SCHEDULE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_SCHEDULE_SUFFIX = "/schedule";

  static const String PROVIDER_TIMETABLE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_TIMETABLE_SUFFIX = "/timetable";

  static const String PROVIDER_EMPLOYEE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_EMPLOYEE_SUFFIX = '/people-timetable';

  static const String PROVIDER_SERVICE_ITEMS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_SERVICE_ITEMS_SUFFIX = '/services';

  static const String SERVICE_PROVIDER_REVIEWS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String SERVICE_PROVIDER_REVIEWS_SUFFIX = '/reviews';

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

  Future<ServiceProviderResponse> getProvidersByServices(
      List<int> serviceIds) async {
//    final response = await _dio.get(PROVIDERS_PATH,
//        queryParameters: {"serviceProvidedIds": serviceIds});

    final response = await _dio.get(PROVIDERS_PATH);

    if (response.statusCode == 200) {
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
    final response = await _dio.get(_buildProviderSchedulesPath(providerId));

    if (response.statusCode == 200) {
      return _mapProviderSchedules(response.data);
    } else
      throw Exception('PROVIDER_SERVICES_FAILED');
  }

  _buildProviderSchedulesPath(int providerId) {
    return PROVIDER_SCHEDULE_PREFIX +
        providerId.toString() +
        PROVIDER_SCHEDULE_SUFFIX;
  }

  List<ServiceProviderSchedule> _mapProviderSchedules(List response) {
    List<ServiceProviderSchedule> list = [];

    for (Map<String, dynamic> item in response) {
      list.add(ServiceProviderSchedule.fromJson(item));
    }

    return list;
  }

  // GET PROVIDER TIMETABLE
  Future<List<ServiceProviderTimetable>> getServiceProviderTimetables(
      int providerId, String startDate, String endDate) async {
    final response = await _dio.get(_buildProviderTimetablePath(providerId),
        queryParameters: {"startDate": startDate, "endDate": endDate});

    if (response.statusCode == 200) {
      return _mapServiceProviderTimetable(response.data);
    } else
      throw Exception('PROVIDER_SERVICES_FAILED');
  }

  List<ServiceProviderTimetable> _mapServiceProviderTimetable(
      List<dynamic> response) {
    List<ServiceProviderTimetable> list = [];

    response.forEach((item) {
      String localDate = item["localDate"] != null ? item["localDate"] : "";

      List<dynamic> entries = item["timeSeries"];

      entries.forEach((entry) {
        list.add(ServiceProviderTimetable.fromJson(entry, localDate));
      });
    });

    return list;
  }

  _buildProviderTimetablePath(int providerId) {
    return PROVIDER_TIMETABLE_PREFIX +
        providerId.toString() +
        PROVIDER_TIMETABLE_SUFFIX;
  }

  Future<ServiceProvider> getProviderDetails(int providerId) async {
    String path = PROVIDER_DETAILS_PATH + providerId.toString();

    final response = await _dio.get(path);

    if (response.statusCode == 200) {
      return ServiceProvider.fromJson(response.data);
    } else {
      throw Exception("LOAD_PROVIDER_DETAILS_FAILED");
    }
  }

  Future<List<Employee>> getProviderEmployees(
      int providerId, String startDate, String endDate) async {
    final response = await _dio.get(_buildGetProviderEmployeesPath(providerId),
        queryParameters: {"startDate": startDate, "endDate": endDate});

    if (response.statusCode == 200) {
      return _mapProviderEmployees(response.data);
    } else {
      throw Exception('LOAD_PROVIDER_EMPPLOYEES_FAILED');
    }
  }

  _buildGetProviderEmployeesPath(int providerId) {
    return PROVIDER_EMPLOYEE_PREFIX +
        providerId.toString() +
        PROVIDER_EMPLOYEE_SUFFIX;
  }

  _mapProviderEmployees(List<dynamic> response) {
    List<Employee> list = [];

    response.forEach((item) {
      list.add(Employee.fromJson(item));
    });

    return list;
  }

  Future<ServiceProviderItemsResponse> getProviderServiceItems(
      int providerId) async {
    final response =
        await _dio.get(_buildGetProviderServiceItemsPath(providerId));

    if (response.statusCode == 200) {
      return _mapProviderServiceItems(response.data);
    } else {
      throw Exception('LOAD_PROVIDER_SERVICE_TEMS_FAILED');
    }
  }

  _buildGetProviderServiceItemsPath(int providerId) {
    return PROVIDER_SERVICE_ITEMS_PREFIX +
        providerId.toString() +
        PROVIDER_SERVICE_ITEMS_SUFFIX;
  }

  _mapProviderServiceItems(dynamic response) {
    return ServiceProviderItemsResponse.fromJson(response);
  }

  Future<ServiceProviderReview> getServiceProviderReviews(
      int providerId) async {
    final response =
        await _dio.get(_buildGetServiceProviderReviews(providerId));

    if (response.statusCode == 200) {
      return ServiceProviderReview.fromJson(response.data);
    } else {
      throw Exception('LOAD_SERVICE_PROVIDER_REVIEWS_FAILED');
    }
  }

  _buildGetServiceProviderReviews(int providerId) {
    return SERVICE_PROVIDER_REVIEWS_PREFIX +
        providerId.toString() +
        SERVICE_PROVIDER_REVIEWS_SUFFIX;
  }

  Future<ServiceProvider> updateServiceProviderDetails(int providerId, String body) async {
    String path = APPOINTMENTS_PATH + providerId.toString();

    final response = await _dio.patch(path);

    if (response.statusCode == 200) {
      return ServiceProvider.fromJson(response.data);
    }
    else {
      throw Exception("UPDATE_PROVIDER_DETAILS_FAILED");
    }
  }
}
