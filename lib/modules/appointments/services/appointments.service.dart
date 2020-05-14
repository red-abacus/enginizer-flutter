import 'dart:convert';
import 'dart:io';

import 'package:app/modules/consultant-appointments/models/receive-form-request.model.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-type.enum.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task-issue.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
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
  static const String CANCEL_APPOINTMENT_EXCEPTION =
      'CANCEL_APPOINTMENT_EXCEPTION';
  static const String CREATE_RECEIVE_PROCEDURE_EXCEPTION =
      'CREATE_RECEIVE_PROCEDURE_EXCEPTION';
  static const String ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION =
      'ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION';
  static const String GET_STANDARD_TASKS_EXCEPTION =
      'GET_STANDARD_TASKS_EXCEPTION';
  static const String GET_CLIENT_TASKS_EXCEPTION = 'GET_CLIENT_TASKS_EXCEPTION';
  static const String START_APPOINTMENT_EXCEPTION =
      'START_APPOINTMENT_EXCEPTION';
  static const String START_APPOINTMENT_TASK_EXCEPTION =
      'START_APPOINTMENT_TASK_EXCEPTION';
  static const String PAUSE_APPOINTMENT_TASK_EXCEPTION =
      'PAUSE_APPOINTMENT_TASK_EXCEPTION';
  static const String ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION =
      'ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION';
  static const String ADD_APPOINTMENT_RECOMMENDATION_IMAGE_EXCEPTION =
      'ADD_APPOINTMENT_RECOMMENDATION_IMAGE_EXCEPTION';
  static const String STOP_APPOINTMENT_EXCEPTION = 'STOP_APPOINTMENT_EXCEPTION';
  static const String APPOINTMENT_REQUEST_ITEMS_EXCEPTION =
      'APPOINTMENT_REQUEST_ITEMS_EXCEPTION';

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

  static const String _CLIENT_TASKS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CLIENT_TASKS_SUFFIX = '/tasks';

  static const String _RECEIVE_PROCEDURE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _RECEIVE_PROCEDURE_SUFFIX = '/procedure/receive';

  static const String _ADD_RECEIVE_PROCEDURE_PHOTOS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_RECEIVE_PROCEDURE_PHOTOS_SUFFIX = '/images';

  static const String _START_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _START_APPOINTMENT_SUFFIX = '/start';

  static const String _START_APPOINTMENT_TASK_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _START_APPOINTMENT_TASK_SUFFIX = '/start';

  static const String _PAUSE_APPOINTMENT_TASK_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _PAUSE_APPOINTMENT_TASK_SUFFIX = '/pause';

  static const String _ADD_APPOINTMENT_RECOMMENDATION_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_APPOINTMENT_RECOMMENDATION_SUFFIX =
      '/recommendations';

  static const String _ADD_APPOINTMENT_RECOMMENDATION_IMAGE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_APPOINTMENT_RECOMMENDATION_IMAGE_SUFFIX = '/images';

  static const String _STOP_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _STOP_APPOINTMENT_SUFFIX = '/stop';

  static const String _APPOINTMENT_REQUEST_ITEMS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _APPOINTMENT_REQUEST_ITEMS_SUFFIX = '/requestItems';

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

  Future<Appointment> cancelAppointment(int appointmentId) async {
    try {
      final response =
          await _dio.patch(_buildCancelAppointmentPath(appointmentId));

      if (response.statusCode == 200) {
        return _mapAppointment(response.data);
      } else {
        throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
    }
  }

  Future<List<MechanicTask>> getAppointmentStandardTasks(
      int appointmentId) async {
    try {
      final response =
          await _dio.get(_buildAppointmentStandardTasks(appointmentId));
      if (response.statusCode == 200) {
        return _mapStandardTasks(response.data);
      } else {
        throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CANCEL_APPOINTMENT_EXCEPTION);
    }
  }

  Future<List<MechanicTask>> getAppointmentClientTasks(
      int appointmentId) async {
    try {
      final response =
          await _dio.get(_buildAppointmentClientTasks(appointmentId));
      if (response.statusCode == 200) {
        return _mapClientTasks(response.data);
      } else {
        throw Exception(GET_CLIENT_TASKS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_CLIENT_TASKS_EXCEPTION);
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
      ReceiveFormRequest receiveFormRequest) async {
    // TODO - i tested on swagger and photos are not saved to procedure.
    List<MultipartFile> files = [];

    for (File file in receiveFormRequest.files) {
      if (file != null) {
        files.add(await MultipartFile.fromFile(
          file.path,
        ));
      }
    }

    FormData formData = new FormData.fromMap({"files": files});

    try {
      final response = await _dio.patch(
          _buildAddReceiveProcedurePhotos(receiveFormRequest.appointmentId,
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

  Future<AppointmentDetail> startAppointment(int appointmentId) async {
    try {
      final response =
          await _dio.patch(_buildStartAppointmentPath(appointmentId));

      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(START_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(START_APPOINTMENT_EXCEPTION);
    }
  }

  Future<AppointmentDetail> pauseAppointment(int appointmentId) async {
    try {
      final response =
          await _dio.patch(_buildPauseAppointmentTaskPath(appointmentId));

      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(START_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(START_APPOINTMENT_EXCEPTION);
    }
  }

  Future<AppointmentDetail> stopAppointment(int appointmentId) async {
    try {
      final response =
          await _dio.patch(_buildStopAppointmentPath(appointmentId));

      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(STOP_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(STOP_APPOINTMENT_EXCEPTION);
    }
  }

  Future<MechanicTask> startAppointmentTask(
      int appointmentId, MechanicTask task) async {
    try {
      final response = await _dio
          .patch(_buildStartAppointmentTaskPath(appointmentId, task.id));
      if (response.statusCode == 200) {
        return MechanicTask.fromJson(task.type, response.data);
      } else {
        throw Exception(START_APPOINTMENT_TASK_EXCEPTION);
      }
    } catch (error) {
      throw Exception(START_APPOINTMENT_TASK_EXCEPTION);
    }
  }

  Future<bool> addAppointmentRecommendation(
      int appointmentId, MechanicTaskIssue mechanicTaskIssue) async {
    try {
      final response = await _dio.post(
          _buildAddAppointmentRecommendationsPath(appointmentId),
          data: jsonEncode(mechanicTaskIssue.toJson()));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION);
    }
  }

  Future<bool> addAppointmentRecommendationImage(
      int appointmentId, MechanicTaskIssue mechanicTaskIssue) async {
    print(
        'path ${_buildAddAppointmentRecommendationImage(appointmentId, mechanicTaskIssue.id)}');
    List<MultipartFile> files = [];

    if (mechanicTaskIssue.image != null) {
      files.add(await MultipartFile.fromFile(
        mechanicTaskIssue.image.path,
      ));
    }

    FormData formData = new FormData.fromMap({"files": files});

    try {
      final response = await _dio.patch(
          _buildAddAppointmentRecommendationImage(
              appointmentId, mechanicTaskIssue.id),
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(ADD_APPOINTMENT_RECOMMENDATION_IMAGE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_APPOINTMENT_RECOMMENDATION_IMAGE_EXCEPTION);
    }
  }

  Future<bool> requestAppointmentItems(
      int appointmentId, int providerId) async {
    Map<String, dynamic> queryParameters = {};

    if (providerId != null) {
      queryParameters['providerId'] = providerId.toString();
    }

    try {
      final response = await _dio.patch(_buildRequestItemsPath(appointmentId),
          data: queryParameters);

      print('response ${response.data}');
      print('status code ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(APPOINTMENT_REQUEST_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(APPOINTMENT_REQUEST_ITEMS_EXCEPTION);
    }
  }

  _mapAppointment(dynamic response) {
    return Appointment.fromJson(response);
  }

  _mapAppointmentDetails(dynamic response) {
    return AppointmentDetail.fromJson(response);
  }

  _mapStandardTasks(List<dynamic> response) {
    List<MechanicTask> tasks = [];

    response.forEach((item) {
      tasks.add(MechanicTask.fromJson(MechanicTaskType.STANDARD, item));
    });

    return tasks;
  }

  _mapClientTasks(List<dynamic> response) {
    List<MechanicTask> tasks = [];

    response.forEach((item) {
      tasks.add(MechanicTask.fromJson(MechanicTaskType.CLIENT, item));
    });

    return tasks;
  }

  _buildReceiveProcedurePath(int appointmentId) {
    return _RECEIVE_PROCEDURE_PREFIX +
        appointmentId.toString() +
        _RECEIVE_PROCEDURE_SUFFIX;
  }

  _buildCancelAppointmentPath(int appointmentId) {
    return _CANCEL_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        _CANCEL_APPOINTMENT_SUFFIX;
  }

  _buildAppointmentStandardTasks(int appointmentId) {
    return _STANDARD_TASKS_PREFIX +
        appointmentId.toString() +
        _STANDARD_TASKS_SUFFIX;
  }

  _buildAppointmentClientTasks(int appointmentId) {
    return _CLIENT_TASKS_PREFIX +
        appointmentId.toString() +
        _CLIENT_TASKS_SUFFIX;
  }

  _buildAddReceiveProcedurePhotos(int appointmentId, int procedureId) {
    return _ADD_RECEIVE_PROCEDURE_PHOTOS_PREFIX +
        appointmentId.toString() +
        '/procedure/' +
        procedureId.toString() +
        _ADD_RECEIVE_PROCEDURE_PHOTOS_SUFFIX;
  }

  _buildStartAppointmentPath(int appointmentId) {
    return _START_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        _START_APPOINTMENT_SUFFIX;
  }

  _buildStartAppointmentTaskPath(int appointmentId, int taskId) {
    return _START_APPOINTMENT_TASK_PREFIX +
        appointmentId.toString() +
        '/tasks/' +
        taskId.toString() +
        _START_APPOINTMENT_TASK_SUFFIX;
  }

  _buildPauseAppointmentTaskPath(int appointmentId) {
    return _PAUSE_APPOINTMENT_TASK_PREFIX +
        appointmentId.toString() +
        _PAUSE_APPOINTMENT_TASK_SUFFIX;
  }

  _buildAddAppointmentRecommendationsPath(int appointmentId) {
    return _ADD_APPOINTMENT_RECOMMENDATION_PREFIX +
        appointmentId.toString() +
        _ADD_APPOINTMENT_RECOMMENDATION_SUFFIX;
  }

  _buildAddAppointmentRecommendationImage(
      int appointmentId, int recommendationId) {
    return _ADD_APPOINTMENT_RECOMMENDATION_IMAGE_PREFIX +
        appointmentId.toString() +
        '/recommendations/' +
        recommendationId.toString() +
        _ADD_APPOINTMENT_RECOMMENDATION_IMAGE_SUFFIX;
  }

  _buildStopAppointmentPath(int appointmentId) {
    return _STOP_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        _STOP_APPOINTMENT_SUFFIX;
  }

  _buildRequestItemsPath(int appointmentId) {
    return _APPOINTMENT_REQUEST_ITEMS_PREFIX +
        appointmentId.toString() +
        _APPOINTMENT_REQUEST_ITEMS_SUFFIX;
  }
}
