import 'dart:convert';

import 'package:app/modules/appointments/enum/service-provider-timetable-status.enum.dart';
import 'package:app/modules/consultant-user-details/models/response/work-station-response.modal.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/provider/service-provider-review.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
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
  static const CREATE_PROVIDER_ITEM_EXCEPTION =
      'CREATE_PROVIDER_ITEM_EXCEPTION';
  static const GET_WORK_STATIONS_EXCEPTION = 'GET_WORK_STATIONS_EXCEPTION';

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

  static const String _GET_WORK_STATIONS_PATH =
      '${Environment.PROVIDERS_BASE_API}/workstations';

  Dio _dio = inject<Dio>();

  ProviderService();

  Future<ServiceProviderItemsResponse> getServices(String type) async {
    try {
      final response = await _dio.get(_buildGetServicesPath(type));
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
      {int page, List<String> serviceNames, int pageSize}) async {
    Map<String, dynamic> queryParameters = {};

    if (serviceNames != null) {
      queryParameters['serviceNames'] = serviceNames;
    }

    if (page != null) {
      queryParameters['page'] = '$page';
    }

    if (pageSize != null) {
      queryParameters['pageSize'] = '$pageSize';
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

  Future<ProviderItem> addProviderItem(
      int providerId, Map<String, dynamic> params) async {
    try {
      final response = await _dio.post(_buildProviderItemsPath(providerId),
          data: jsonEncode(params));
      if (response.statusCode == 200) {
        return ProviderItem.fromJson(response.data);
      } else {
        throw Exception(CREATE_PROVIDER_ITEM_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CREATE_PROVIDER_ITEM_EXCEPTION);
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

  Future<WorkStationResponse> getWorkStations() async {
    String path = _GET_WORK_STATIONS_PATH;

    try {
      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        return WorkStationResponse.fromJson(response.data);
      } else {
        throw Exception(GET_WORK_STATIONS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_WORK_STATIONS_EXCEPTION);
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
      Employee employee = Employee.fromJson(item);

      if (employee.timeSeries.length > 0) {
        list.add(employee);
      }
    });

    return list;
  }

  _mapServices(Map<String, dynamic> commingServices) {
    var response = ServiceProviderItemsResponse.fromJson(commingServices);
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

  _buildGetServicesPath(String type) {
    if (type != null) {
      return _SERVICES_PATH + '?type=$type';
    }

    return _SERVICES_PATH;
  }
}
