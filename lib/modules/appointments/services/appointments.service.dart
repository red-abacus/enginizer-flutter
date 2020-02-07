import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/appointments-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';
import 'package:http/http.dart' as http;
class AppointmentsService {
  static const String APPOINTMENTS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments';
  static const String APPOINTMENTS_DETAILS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String SERVICES_PATH = '${Environment.API_BASE_URL}/services';
  static const String TIMETABLE_PATH =
      '${Environment.API_BASE_URL}/providers/timetable';
  static const String PROVIDER_TIMETABLE_PREFIX =
      '${Environment.API_BASE_URL}/api/providers/';
  static const String PROVIDER_TIMETABLE_SUFFIX = '/timetable';
  static const String PROVIDER_SERVICES_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_SERVICES_SUFFIX = "/services";

  Dio _dio = inject<Dio>();
  AppointmentsService();
  Future<AppointmentsResponse> getAppointments() async {
    final response = await http.get(APPOINTMENTS_API_PATH);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> parsed = (jsonDecode(response.body) as List);
      return AppointmentsResponse.fromJson(parsed);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
  String buildProviderTimetablePath(int providerId) {
    return PROVIDER_TIMETABLE_PREFIX +
        providerId.toString() +
        PROVIDER_TIMETABLE_SUFFIX;
  }
  Future<List<ServiceItem>> getServices() async {
    final response = await _dio.get('$SERVICES_PATH');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return _mapServices(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_SERVICES_FAILED');
    }
  }
  Future<Appointment> createAppointment(
      AppointmentRequest appointmentRequest) async {
    final response = await http.post(APPOINTMENTS_API_PATH,
        body: jsonEncode(appointmentRequest.toJson()),
        headers: {
          Headers.contentTypeHeader: 'application/json', // set content-length
        });
    if (response.statusCode == 201) {
      Map<String, dynamic> parsed = jsonDecode(response.body);
      return _mapAppointment(parsed);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CREATE_APPOINTMENT_FAILED');
    }
  }
  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    final response = await http.get(APPOINTMENTS_DETAILS_API_PATH + appointmentId.toString(),
        headers: {
          Headers.contentTypeHeader: 'application/json', // set content-length
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = jsonDecode(response.body);
      return _mapAppointmentDetails(parsed);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CREATE_CAR_FAILED');
    }
  }
  Future<List<DateEntry>> scheduleItems(providerId) async {
    final response = await _dio.get(buildProviderTimetablePath(providerId));
  }
  List<ServiceItem> _mapServices(List<dynamic> brands) {
    List<ServiceItem> serviceList = [];
    brands.forEach((brnd) => serviceList.add(ServiceItem.fromJson(brnd)));
    return serviceList;
  }
  Appointment _mapAppointment(dynamic response) {
    return Appointment.fromJson(response);
  }
  AppointmentDetail _mapAppointmentDetails(dynamic response) {
    return AppointmentDetail.fromJson(response);
  }

  Future<ServiceProviderItemsResponse> getServiceProviderItems(
      ServiceProvider serviceProvider) async {
    final response =
    await http.get(buildProviderServicesPath(serviceProvider.id));

    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = jsonDecode(response.body);
      return _mapServiceProviderItems(parsed);
    } else
      throw Exception('PROVIDER_SERVICES_FAILED');
  }

  ServiceProviderItemsResponse _mapServiceProviderItems(
      Map<String, dynamic> response) {
    return ServiceProviderItemsResponse.fromJson(response);
  }

  String buildProviderServicesPath(int providerId) {
    return PROVIDER_SERVICES_PREFIX +
        providerId.toString() +
        PROVIDER_SERVICES_SUFFIX;
  }
}