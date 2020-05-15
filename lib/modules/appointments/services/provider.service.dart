import 'dart:convert';

import 'package:app/modules/consultant-appointments/models/assign-employee-request.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/provider/service-provider-review.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/response/provider-service-response.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:app/utils/environment.constants.dart';

class ProviderService {
  static const String GET_SERVICES_EXCEPTION =
      'GET_APPOINTMENT_SERVICES_EXCEPTION';
  static const String GET_PROVIDERS_EXCEPTION = 'GET_PROVIDERS_EXCEPTION';
  static const String GET_PROVIDER_TIMETABLE_EXCEPTION =
      'GET_PROVIDER_TIMETABLE_EXCEPTION';
  static const String GET_PROVIDER_DETAILS_EXCEPTION =
      'GET_PROVIDER_DETAILS_EXCEPTION';
  static const String GET_PROVIDER_EMPLOYEES_EXCEPTION =
      'GET_PROVIDER_EMPLOYEES_EXCEPTION';
  static const String GET_ITEM_TYPES_EXCEPTION = 'GET_ITEM_TYPES_EXCEPTION';
  static const String GET_PROVIDER_ITEM_TYPES_EXCEPTION =
      'GET_PROVIDER_ITEM_TYPES_EXCEPTION';
  static const String GET_PROVIDER_ITEMS_EXCEPTION =
      'GET_PROVIDER_ITEMS_EXCEPTION';
  static const String GET_PROVIDER_SERVICE_ITEMS_EXCEPTION =
      'GET_PROVIDER_SERVICE_ITEMS_EXCEPTION';
  static const String UPDATE_PROVIDER_DETAILS_EXCEPTION =
      'UPDATE_PROVIDER_DETAILS_FAILED';
  static const String ASSIGN_MECHANIC_TO_APPOINTMENT_EXCEPTION =
      'ASSIGN_MECHANIC_TO_APPOINTMENT_EXCEPTION';

  static const String _SERVICES_PATH =
      '${Environment.PROVIDERS_BASE_API}/services';

  static const String _PROVIDERS_PATH = 'api/providers';

  static const String _PROVIDER_DETAILS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers/';

  static const String _APPOINTMENTS_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers';

  static const String _PROVIDER_TIMETABLE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _PROVIDER_TIMETABLE_SUFFIX = "/timetable";

  static const String _PROVIDER_EMPLOYEE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _PROVIDER_EMPLOYEE_SUFFIX = '/people-timetable';

  static const String _ITEM_TYPES_PATH =
      '${Environment.PROVIDERS_BASE_API}/itemTypes';

  static const String _PROVIDER_ITEMS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _PROVIDER_ITEMS_SUFFIX = '/items';

  static const String _PROVIDER_SERVICE_ITEMS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _PROVIDER_SERVICE_ITEMS_SUFFIX = '/services';

  static const String _SERVICE_PROVIDER_REVIEWS_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _SERVICE_PROVIDER_REVIEWS_SUFFIX = '/reviews';

  static const String _ASSIGN_MECHANIC_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String _ASSIGN_MECHANIC_SUFFIX = '/people-timetable/';

  Dio _dio = inject<Dio>();

  ProviderService();

  Future<ProviderServiceResponse> getServices() async {
    try {
      final response = await _dio.get(_buildGetServicesPath());
      if (response.statusCode == 200) {
        return _mapServices(response.data);
      } else {
        throw Exception(GET_SERVICES_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_SERVICES_EXCEPTION);
    }
  }

  Future<ServiceProviderResponse> getProviders(
      {int page, List<String> serviceNames}) async {
    Map<String, dynamic> queryParameters = {};

    if (serviceNames != null) {
      queryParameters['serviceNames'] = serviceNames;
    }

    if (page != null) {
      queryParameters['page'] = '$page';
    }

    try {
      var uri = Uri(
          scheme: Environment.PROVIDERS_SCHEME,
          host: Environment.PROVIDERS_HOST,
          path: _PROVIDERS_PATH,
          queryParameters: queryParameters);
      final response = await _dio.getUri(uri);
      if (response.statusCode == 200) {
        return _mapProviders(response.data);
      } else {
        throw Exception(GET_PROVIDERS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROVIDERS_EXCEPTION);
    }
  }

  Future<List<ServiceProviderTimetable>> getServiceProviderTimetables(
      int providerId, String startDate, String endDate) async {
    try {
      final response = await _dio.get(_buildProviderTimetablePath(providerId),
          queryParameters: {"startDate": startDate, "endDate": endDate});

      if (response.statusCode == 200) {
        return _mapServiceProviderTimetable(response.data);
      } else {
        throw Exception(GET_PROVIDER_TIMETABLE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROVIDER_TIMETABLE_EXCEPTION);
    }
  }

  Future<ServiceProvider> getProviderDetails(int providerId) async {
    try {
      String path = _PROVIDER_DETAILS_PATH + providerId.toString();

      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        return ServiceProvider.fromJson(response.data);
      } else {
        throw Exception(GET_PROVIDER_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROVIDER_DETAILS_EXCEPTION);
    }
  }

  Future<List<Employee>> getProviderEmployees(
      int providerId, String startDate, String endDate) async {
    try {
      final response = await _dio.get(
          _buildGetProviderEmployeesPath(providerId),
          queryParameters: {"startDate": startDate, "endDate": endDate});

      if (response.statusCode == 200) {
        return _mapProviderEmployees(response.data);
      } else {
        throw Exception(GET_PROVIDER_EMPLOYEES_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROVIDER_EMPLOYEES_EXCEPTION);
    }
  }

  Future<List<ItemType>> getItemTypes() async {
    try {
      final response = await _dio.get(_ITEM_TYPES_PATH);

      if (response.statusCode == 200) {
        return _mapItemTypes(response.data);
      } else {
        throw Exception(GET_ITEM_TYPES_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_ITEM_TYPES_EXCEPTION);
    }
  }

  List<ItemType> _mapItemTypes(List<dynamic> response) {
    List<ItemType> itemTypes = [];
    response.forEach((item) {
      itemTypes.add(ItemType.fromJson(item));
    });
    return itemTypes;
  }

  Future<List<ProviderItem>> getProviderItems(
      int providerId, Map<String, dynamic> query) async {
    print('quert $query');
    try {
      final response = await _dio.get(_buildProviderItemsPath(providerId),
          queryParameters: query);
      if (response.statusCode == 200) {
        return _mapProviderItems(response.data);
      } else {
        throw Exception(GET_PROVIDER_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROVIDER_ITEMS_EXCEPTION);
    }
  }

  Future<ServiceProviderItemsResponse> getProviderServiceItems(
      int providerId) async {
    try {
      final response =
          await _dio.get(_buildGetProviderServiceItemsPath(providerId));

      if (response.statusCode == 200) {
        return _mapProviderServiceItems(response.data);
      } else {
        throw Exception(GET_PROVIDER_SERVICE_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_PROVIDER_SERVICE_ITEMS_EXCEPTION);
    }
  }

  Future<ServiceProviderReview> getServiceProviderReviews(
      int providerId) async {
    try {
      final response =
          await _dio.get(_buildGetServiceProviderReviews(providerId));

      if (response.statusCode == 200) {
        return ServiceProviderReview.fromJson(response.data);
      } else {
        throw Exception(GET_PROVIDER_SERVICE_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<ServiceProvider> updateServiceProviderDetails(
      int providerId, String body) async {
    String path = _APPOINTMENTS_PATH + providerId.toString();

    try {
      final response = await _dio.patch(path);

      if (response.statusCode == 200) {
        return ServiceProvider.fromJson(response.data);
      } else {
        throw Exception(UPDATE_PROVIDER_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> assignEmployeeToAppointment(
      AssignEmployeeRequest assignEmployeeRequest) async {
    try {
      final response = await _dio.put(
          _buildAssignMechanicToAppointment(assignEmployeeRequest.providerId,
              assignEmployeeRequest.employeeId),
          data: jsonEncode(assignEmployeeRequest.toJson()));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(ASSIGN_MECHANIC_TO_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ASSIGN_MECHANIC_TO_APPOINTMENT_EXCEPTION);
    }
  }

  _mapServiceProviderTimetable(List<dynamic> response) {
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

  _mapProviderItems(List<dynamic> response) {
    List<ProviderItem> providerItems = [];
    response.forEach((item) {
      providerItems.add(ProviderItem.fromJson(item));
    });
    return providerItems;
  }

  _mapProviderEmployees(List<dynamic> response) {
    List<Employee> list = [];

    response.forEach((item) {
      list.add(Employee.fromJson(item));
    });

    return list;
  }

  _mapServices(Map<String, dynamic> commingServices) {
    var response = ProviderServiceResponse.fromJson(commingServices);
    return response;
  }

  _mapProviders(Map<String, dynamic> commingServices) {
    return ServiceProviderResponse.fromJson(commingServices);
  }

  _mapProviderServiceItems(dynamic response) {
    return ServiceProviderItemsResponse.fromJson(response);
  }

  _buildGetServiceProviderReviews(int providerId) {
    return _SERVICE_PROVIDER_REVIEWS_PREFIX +
        providerId.toString() +
        _SERVICE_PROVIDER_REVIEWS_SUFFIX;
  }

  _buildProviderTimetablePath(int providerId) {
    return _PROVIDER_TIMETABLE_PREFIX +
        providerId.toString() +
        _PROVIDER_TIMETABLE_SUFFIX;
  }

  _buildGetProviderEmployeesPath(int providerId) {
    return _PROVIDER_EMPLOYEE_PREFIX +
        providerId.toString() +
        _PROVIDER_EMPLOYEE_SUFFIX;
  }

  _buildProviderItemsPath(int providerId) {
    return _PROVIDER_ITEMS_PREFIX +
        providerId.toString() +
        _PROVIDER_ITEMS_SUFFIX;
  }

  _buildGetProviderServiceItemsPath(int providerId) {
    return _PROVIDER_SERVICE_ITEMS_PREFIX +
        providerId.toString() +
        _PROVIDER_SERVICE_ITEMS_SUFFIX;
  }

  _buildAssignMechanicToAppointment(int serviceProviderId, int mechanicId) {
    return _ASSIGN_MECHANIC_PREFIX +
        serviceProviderId.toString() +
        _ASSIGN_MECHANIC_SUFFIX +
        mechanicId.toString();
  }

  _buildGetServicesPath() {
    return _SERVICES_PATH + '?type=APPOINTMENT';
  }
}
