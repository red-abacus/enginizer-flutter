import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/utils/environment.constants.dart';

class AppointmentsService {
  static const String GET_APPOINTMENTS_EXCEPTION = 'GET_APPOINTMENTS_FAILED';
  static const String CREATE_APPOINTMENT_EXCEPTION =
      'CREATE_APPOINTMENT_EXCEPTION';
  static const String GET_APPOINTMENT_DETAILS_EXCEPTION =
      'GET_APPOINTMENT_DETAILS_EXCEPTION';
  static const String CANCEL_APPOINTMENT_EXCEPTION = 'CANCEL_APPOINTMENT_EXCEPTION';

  static const String _APPOINTMENTS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments';
  static const String _APPOINTMENTS_DETAILS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CANCEL_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CANCEL_APPOINTMENT_SUFFIX = '/cancel';

  static const String _STANDARD_TASKS_PREFIX = '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _STANDARD_TASKS_SUFFIX = '/standardTasks';

  Dio _dio = inject<Dio>();

  AppointmentsService();

  Future<AppointmentsResponse> getAppointments() async {
    try {
      final response = await _dio.get(_APPOINTMENTS_API_PATH);
      if (response.statusCode == 200) {
        return AppointmentsResponse.fromJson(response.data);
      } else {
        throw Exception(GET_APPOINTMENTS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_APPOINTMENTS_EXCEPTION);
    }
  }

  Future<Appointment> createAppointment(
      AppointmentRequest appointmentRequest) async {
    try {
      final response = await _dio.post(_APPOINTMENTS_API_PATH,
          data: jsonEncode(appointmentRequest.toJson()));

      if (response.statusCode == 201) {
        return _mapAppointment(response.data);
      } else {
        throw Exception(CREATE_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CREATE_APPOINTMENT_EXCEPTION);
    }
  }

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    try {
      final response = await _dio
          .get(_APPOINTMENTS_DETAILS_API_PATH + appointmentId.toString());
      if (response.statusCode == 200) {
        return _mapAppointmentDetails(response.data);
      } else {
        throw Exception(GET_APPOINTMENT_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_APPOINTMENT_DETAILS_EXCEPTION);
    }
  }

  Appointment _mapAppointment(dynamic response) {
    return Appointment.fromJson(response);
  }

  AppointmentDetail _mapAppointmentDetails(dynamic response) {
    return AppointmentDetail.fromJson(response);
  }

  Future<Appointment> cancelAppointment(int appointmentId) async {
    try {
      final response =
      await _dio.patch(buildCancelAppointmentPath(appointmentId));

      if (response.statusCode == 200) {
        return _mapAppointment(response.data);
      } else {
        throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
    }
  }

  Future getAppointmentStandardTasks(int appointmentId) async {
    try {
      final response =
      await _dio.get(_buildAppointmentStandardTasks(appointmentId));

      if (response.statusCode == 200) {
        return _mapAppointment(response.data);
      } else {
        throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
    }
  }

  String buildCancelAppointmentPath(int appointmentId) {
    return _CANCEL_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        _CANCEL_APPOINTMENT_SUFFIX;
  }

  String _buildAppointmentStandardTasks(int appointmentId) {
    return _STANDARD_TASKS_PREFIX +
    appointmentId.toString() +
    _STANDARD_TASKS_SUFFIX;
  }
}
