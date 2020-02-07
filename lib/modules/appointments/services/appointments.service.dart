import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/appointments-response.model.dart';
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

  Future<Appointment> createAppointment(Appointment appointment) async {
    final response = await http.post(APPOINTMENTS_API_PATH,
        body: jsonEncode(appointment.toJson()),
        headers: {
          Headers.contentTypeHeader: 'application/json', // set content-length
        });

    if (response.statusCode == 201) {
      // If server returns an OK response, parse the JSON.

      Map<String, dynamic> parsed = jsonDecode(response.body);

      return _mapAppointment(parsed);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CREATE_CAR_FAILED');
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
}
