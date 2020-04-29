import 'dart:convert';
import 'dart:io';

import 'package:app/modules/consultant-appointments/models/receive-form-request.model.dart';
import 'package:app/modules/consultant-appointments/models/receive-form.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/utils/environment.constants.dart';

class AppointmentsService {
  static const String GET_APPOINTMENTS_EXCEPTION = 'GET_APPOINTMENTS_FAILED';
  static const String CREATE_APPOINTMENT_EXCEPTION = 'CREATE_APPOINTMENT_EXCEPTION';

  static const String GET_APPOINTMENT_DETAILS_EXCEPTION =
      'GET_APPOINTMENT_DETAILS_EXCEPTION';
  static const String CANCEL_APPOINTMENT_EXCEPTION =
      'CANCEL_APPOINTMENT_EXCEPTION';
  static const String CREATE_RECEIVE_PROCEDURE_EXCEPTION =
      'CREATE_RECEIVE_PROCEDURE_EXCEPTION';
  static const String ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION =
      'ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION';

  static const String _APPOINTMENTS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments';
  static const String _APPOINTMENTS_DETAILS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CANCEL_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CANCEL_APPOINTMENT_SUFFIX = '/cancel';

  static const String _STANDARD_TASKS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _STANDARD_TASKS_SUFFIX = '/standardTasks';

  static const String _RECEIVE_PROCEDURE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _RECEIVE_PROCEDURE_SUFFIX = '/procedure/receive';

  static const String _ADD_RECEIVE_PROCEDURE_PHOTOS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_RECEIVE_PROCEDURE_PHOTOS_SUFFIX = '/images';

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

  ReceiveForm _mapReceiveForm(dynamic response) {
    return ReceiveForm.fromJson(response);
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

  Future<int> createReceiveProcedure(
      ReceiveFormRequest receiveFormRequest) async {
    try {
      final response = await _dio.post(
          _buildReceiveProcedurePath(receiveFormRequest.appointmentId),
          data: jsonEncode(receiveFormRequest.toJson()));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(CREATE_RECEIVE_PROCEDURE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CREATE_RECEIVE_PROCEDURE_EXCEPTION);
    }
  }

  Future<bool> addReceiveProcedurePhotos(
      // TODO - i tested on swagger and photos are not saved to procedure.
      ReceiveFormRequest receiveFormRequest) async {
    List<MultipartFile> files = [];

    for (File file in receiveFormRequest.files) {
      if (file != null) {
        files.add(await MultipartFile.fromFile(
          file.path,
        ));
      }
    }

    FormData formData = new FormData.fromMap({
      "files": files
    });

    try {
      final response = await _dio.patch(
          _buildAddReceiveProcedurePhotos(
              receiveFormRequest.appointmentId,
              receiveFormRequest.receiveFormId),
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION);
    }
  }

  _buildReceiveProcedurePath(int appointmentId) {
    return _RECEIVE_PROCEDURE_PREFIX +
        appointmentId.toString() +
        _RECEIVE_PROCEDURE_SUFFIX;
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

  _buildAddReceiveProcedurePhotos(int appointmentId, int procedureId) {
    return _ADD_RECEIVE_PROCEDURE_PHOTOS_PREFIX +
        appointmentId.toString() +
        '/procedure/' +
        procedureId.toString() +
        _ADD_RECEIVE_PROCEDURE_PHOTOS_SUFFIX;
  }
}
