import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/utils/environment.constants.dart';

class AppointmentsService {
  static const String APPOINTMENTS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments';
  static const String APPOINTMENTS_DETAILS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String SERVICES_PATH = '${Environment.PROVIDERS_BASE_API}/services';
  static const String TIMETABLE_PATH =
      '${Environment.PROVIDERS_BASE_API}/providers/timetable';
  static const String PROVIDER_TIMETABLE_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/api/providers/';
  static const String PROVIDER_TIMETABLE_SUFFIX = '/timetable';
  static const String PROVIDER_SERVICES_PREFIX =
      '${Environment.PROVIDERS_BASE_API}/providers/';
  static const String PROVIDER_SERVICES_SUFFIX = "/services";

  static const String CANCEL_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String CANCEL_APPOINTMENT_SUFFIX = '/cancel';

  Dio _dio = inject<Dio>();

  AppointmentsService();

  Future<AppointmentsResponse> getAppointments() async {
    final response = await _dio.get(APPOINTMENTS_API_PATH);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return AppointmentsResponse.fromJson(response.data);
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
    final response = await _dio.post(APPOINTMENTS_API_PATH,
        data: jsonEncode(appointmentRequest.toJson()));

    if (response.statusCode == 201) {
      return _mapAppointment(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CREATE_APPOINTMENT_FAILED');
    }
  }

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    final response = await _dio
        .get(APPOINTMENTS_DETAILS_API_PATH + appointmentId.toString());

    if (response.statusCode == 200) {
      return _mapAppointmentDetails(response.data);
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

  Future<ServiceProviderItemsResponse> getServiceProviderItems(int id) async {
    final response = await _dio.get(buildProviderServicesPath(id));

    if (response.statusCode == 200) {
      return _mapServiceProviderItems(response.data);
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

  Future<Appointment> cancelAppointment(int appointmentId) async {
    final response =
        await _dio.patch(buildCancelAppointmentPath(appointmentId));

    if (response.statusCode == 200) {
      return _mapAppointment(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CANCEL_APPOINTMENT_FAILED');
    }
  }

  String buildCancelAppointmentPath(int appointmentId) {
    return CANCEL_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        CANCEL_APPOINTMENT_SUFFIX;
  }
}
