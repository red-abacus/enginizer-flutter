import 'dart:convert';
import 'dart:io';

import 'package:app/modules/appointments/model/handover/procedure-info.model.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task-issue.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/model/request/assign-employee-request.model.dart';
import 'package:app/modules/appointments/model/request/receive-form-request.model.dart';
import 'package:app/modules/appointments/enum/mechanic-task-type.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task.model.dart';
import 'package:app/modules/work-estimate-form/enums/transport-request.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/provider-payment.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/order-issue-item-request.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:http_parser/http_parser.dart';

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
  static const String CREATE_RETURN_PROCEDURE_EXCEPTION =
      'CREATE_RETURN_PROCEDURE_EXCEPTION';
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
  static const String APPOINTMENT_ITEMS_EXCEPTION =
      'APPOINTMENT_ITEMS_EXCEPTION';
  static const String SEND_APPOINTMENT_RECOMMENDATIONS_EXCEPTION =
      'SEND_APPOINTMENT_RECOMMENDATIONS_EXCEPTION';
  static const String ASSIGN_EMPLOYEE_EXCEPTION = 'ASSIGN_EMPLOYEE_EXCEPTION';
  static const String ORDER_APPOINTMENT_ITEMS_EXCEPTION =
      'ORDER_APPOINTMENT_ITEMS_EXCEPTION';
  static const String APPOINTMENT_REQUEST_TRANSPORT_EXCEPTION =
      'APPOINTMENT_REQUEST_TRANSPORT_EXCEPTION';
  static const String GET_RECEIVE_PROCEDURE_INFO_EXCEPTION =
      'GET_RECEIVE_PROCEDURE_INFO_EXCEPTION';
  static const String GET_RETURN_PROCEDURE_INFO_EXCEPTION =
      'GET_RECEIVE_PROCEDURE_INFO_EXCEPTION';
  static const String FINISH_APPOINTMENT_EXCEPTION =
      'FINISH_APPOINTMENT_EXCEPTION';
  static const String COMPLETE_APPOOINTMENT_EXCEPTION =
      'COMPLETE_APPOOINTMENT_EXCEPTION';
  static const String PAYMENT_PROVIDER_EXCEPTION = 'PAYMENT_PROVIDER_EXCEPTION';

  static String _APPOINTMENTS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments';
  static const String _APPOINTMENTS_PATH = 'api/appointments';

  static String _APPOINTMENTS_DETAILS_API_PATH =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static String _CANCEL_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CANCEL_APPOINTMENT_SUFFIX = '/cancel';

  static String _STANDARD_TASKS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static String _STANDARD_TASKS_SUFFIX = '/standardTasks';

  static String _CLIENT_TASKS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _CLIENT_TASKS_SUFFIX = '/tasks';

  static String _RECEIVE_PROCEDURE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _RECEIVE_PROCEDURE_SUFFIX = '/procedure/receive';

  static String _RETURN_PROCEDURE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _RETURN_PROCEDURE_SUFFIX = '/procedure/return';

  static String _ADD_RECEIVE_PROCEDURE_PHOTOS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_RECEIVE_PROCEDURE_PHOTOS_SUFFIX = '/images';

  static String _START_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _START_APPOINTMENT_SUFFIX = '/start';

  static String _START_APPOINTMENT_TASK_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _START_APPOINTMENT_TASK_SUFFIX = '/start';

  static String _PAUSE_APPOINTMENT_TASK_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _PAUSE_APPOINTMENT_TASK_SUFFIX = '/pause';

  static String _ADD_APPOINTMENT_RECOMMENDATION_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_APPOINTMENT_RECOMMENDATION_SUFFIX =
      '/recommendations';

  static String _ADD_APPOINTMENT_RECOMMENDATION_IMAGE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ADD_APPOINTMENT_RECOMMENDATION_IMAGE_SUFFIX = '/images';

  static String _STOP_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _STOP_APPOINTMENT_SUFFIX = '/stop';

  static String _APPOINTMENT_REQUEST_ITEMS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _APPOINTMENT_REQUEST_ITEMS_SUFFIX = '/requestItems';

  static String _APPOINTMENTS_ITEMS_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _APPOINTMENTS_ITEMS_SUFFIX = '/items';

  static String _ASSIGN_EMPLOYEE_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ASSIGN_EMPLOYEE_SUFFIX = '/employee';

  static String _ORDER_APPOINTMENT_ITEM_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _ORDER_APPOINTMENT_ITEM_SUFFIX = '/orderItems';

  static String _APPOINTMENT_REQUEST_TRANSPORT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _APPOINTMENT_REQUEST_TRANSPORT_SUFFIX =
      '/requestTransport';

  static String _COMPLETE_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _COMPLETE_APPOINTMENT_SUFFIX = '/complete';

  static String _FINISH_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _FINISH_APPOINTMENT_SUFFIX = '/finish';

  static String _PAYMENT_APPOINTMENT_PREFIX =
      '${Environment.APPOINTMENTS_BASE_API}/appointments/';
  static const String _PAYMENT_APPOINTMENT_SUFFIX = '/payment';

  Dio _dio = inject<Dio>();

  AppointmentsService();

  Future<AppointmentsResponse> getAppointments(
      AppointmentsRequest request) async {
    try {
      var uri = Uri(
          scheme: Environment.APPOINTMENTS_SCHEME,
          host: Environment.APPOINTMENTS_HOST,
          path: _APPOINTMENTS_PATH,
          queryParameters: request.toJson());
            final response = await _dio.getUri(uri);
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

  Future<ProcedureInfo> getReceiveProcedureInfo(int appointmentId) async {
    try {
      final response =
          await _dio.get(_buildReceiveProcedurePath(appointmentId));
      if (response.statusCode == 200) {
        return ProcedureInfo.fromJson(response.data);
      } else {
        throw Exception(GET_RECEIVE_PROCEDURE_INFO_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_RECEIVE_PROCEDURE_INFO_EXCEPTION);
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

  Future<ProcedureInfo> getReturnProcedureInfo(int appointmentId) async {
    try {
      final response = await _dio.get(_buildReturnProcedurePath(appointmentId));
      if (response.statusCode == 200) {
        return ProcedureInfo.fromJson(response.data);
      } else {
        throw Exception(GET_RETURN_PROCEDURE_INFO_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_RETURN_PROCEDURE_INFO_EXCEPTION);
    }
  }

  Future<int> createReturnProcedure(
      ReceiveFormRequest receiveFormRequest) async {
    try {
      final response = await _dio.post(
          _buildReturnProcedurePath(receiveFormRequest.appointmentId),
          data: jsonEncode(receiveFormRequest.toReturnJson()));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(CREATE_RETURN_PROCEDURE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CREATE_RETURN_PROCEDURE_EXCEPTION);
    }
  }

  Future<bool> addReceiveProcedurePhotos(
      ReceiveFormRequest receiveFormRequest) async {
    var formData = FormData();

    for (File file in receiveFormRequest.files) {
      if (file != null) {
        formData.files.add(MapEntry(
          "files",
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last,
              contentType: MediaType('image', file.path.split('.').last)),
        ));
      }
    }

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

  Future<int> addAppointmentRecommendation(
      int appointmentId, MechanicTaskIssue mechanicTaskIssue) async {
    try {
      final response = await _dio.post(
          _buildAddAppointmentRecommendationsPath(appointmentId),
          data: jsonEncode(mechanicTaskIssue.toJson()));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION);
    }
  }

  Future<bool> sendAppointmentRecommendations(
      int appointmentId, List<Map<String, dynamic>> request) async {
    try {
      final response = await _dio.patch(
          _buildAddAppointmentRecommendationsPath(appointmentId),
          data: jsonEncode(request));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(SEND_APPOINTMENT_RECOMMENDATIONS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(SEND_APPOINTMENT_RECOMMENDATIONS_EXCEPTION);
    }
  }

  Future<bool> addAppointmentRecommendationImage(int appointmentId,
      MechanicTaskIssue mechanicTaskIssue, int recommendationId) async {
    var formData = FormData();

    if (mechanicTaskIssue.image != null) {
      formData.files.add(MapEntry(
        "files",
        await MultipartFile.fromFile(mechanicTaskIssue.image.path,
            filename: mechanicTaskIssue.image.path.split('/').last,
            contentType: MediaType(
                'image', mechanicTaskIssue.image.path.split('.').last)),
      ));
    }

    try {
      final response = await _dio.patch(
          _buildAddAppointmentRecommendationImage(
              appointmentId, recommendationId),
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

  Future<bool> requestAppointmentItems(int appointmentId,
      {int providerId}) async {
    Map<String, dynamic> queryParameters = {};

    if (providerId != null) {
      queryParameters['providerId'] = providerId.toString();
    }

    try {
      final response = await _dio.patch(_buildRequestItemsPath(appointmentId),
          data: jsonEncode(queryParameters));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(APPOINTMENT_REQUEST_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(APPOINTMENT_REQUEST_ITEMS_EXCEPTION);
    }
  }

  Future<List<IssueItem>> getAppointmentItems(int appointmentId) async {
    try {
      final response = await _dio.get(_buildGetAppointmentItems(appointmentId));

      if (response.statusCode == 200) {
        return _mapIssueItems(response.data);
      } else {
        throw Exception(APPOINTMENT_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(APPOINTMENT_ITEMS_EXCEPTION);
    }
  }

  Future<AppointmentDetail> assignEmployee(
      int appointmentId, AssignEmployeeRequest request) async {
    try {
      final response = await _dio.patch(_buildAssignEmployeePath(appointmentId),
          data: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(ASSIGN_EMPLOYEE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ASSIGN_EMPLOYEE_EXCEPTION);
    }
  }

  Future<AppointmentDetail> orderAppointmentItems(
      int appointmentId, OrderIssueItemRequest request) async {
    try {
      final response = await _dio.patch(
          _buildOrderAppointmentItem((appointmentId)),
          data: jsonEncode(request.toCreateJson()));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(ORDER_APPOINTMENT_ITEMS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ORDER_APPOINTMENT_ITEMS_EXCEPTION);
    }
  }

  Future<AppointmentDetail> requestTransport(
      int appointmentId, TransportRequest transportRequest) async {
    try {
      final response = await _dio.patch(_buildRequestTransport(appointmentId),
          data: jsonEncode(transportRequest.toJson()));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(APPOINTMENT_REQUEST_TRANSPORT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(APPOINTMENT_REQUEST_TRANSPORT_EXCEPTION);
    }
  }

  Future<AppointmentDetail> finishAppointment(int appointmentId) async {
    try {
      final response = await _dio.patch(_buildFinishAppointment(appointmentId));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(FINISH_APPOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(FINISH_APPOINTMENT_EXCEPTION);
    }
  }

  Future<AppointmentDetail> completeAppointment(int appointmentId) async {
    try {
      final response =
          await _dio.patch(_buildCompleteAppointment(appointmentId));
      if (response.statusCode == 200) {
        return AppointmentDetail.fromJson(response.data);
      } else {
        throw Exception(COMPLETE_APPOOINTMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(COMPLETE_APPOOINTMENT_EXCEPTION);
    }
  }

  Future<ProviderPayment> getAppointmentPayment(
      String returnUrl, int appointmentId) async {
    Map<String, dynamic> map = new Map();
    map['returnUrl'] = returnUrl;

    try {
      final response = await _dio.post(_buildPaymentAppointment(appointmentId),
          data: returnUrl);
      if (response.statusCode == 200) {
        return ProviderPayment.fromJson(response.data);
      } else {
        throw Exception(PAYMENT_PROVIDER_EXCEPTION);
      }
    } catch (error) {
      throw Exception(PAYMENT_PROVIDER_EXCEPTION);
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

  _mapIssueItems(List<dynamic> response) {
    List<IssueItem> items = [];

    response.forEach((item) {
      items.add(IssueItem.fromJson(item));
    });

    return items;
  }

  _buildReceiveProcedurePath(int appointmentId) {
    return _RECEIVE_PROCEDURE_PREFIX +
        appointmentId.toString() +
        _RECEIVE_PROCEDURE_SUFFIX;
  }

  _buildReturnProcedurePath(int appointmentId) {
    return _RETURN_PROCEDURE_PREFIX +
        appointmentId.toString() +
        _RETURN_PROCEDURE_SUFFIX;
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

  _buildGetAppointmentItems(int appointmentId) {
    return _APPOINTMENTS_ITEMS_PREFIX +
        appointmentId.toString() +
        _APPOINTMENTS_ITEMS_SUFFIX;
  }

  _buildAssignEmployeePath(int appointmentId) {
    return _ASSIGN_EMPLOYEE_PREFIX +
        appointmentId.toString() +
        _ASSIGN_EMPLOYEE_SUFFIX;
  }

  _buildOrderAppointmentItem(int appointmentId) {
    return _ORDER_APPOINTMENT_ITEM_PREFIX +
        appointmentId.toString() +
        _ORDER_APPOINTMENT_ITEM_SUFFIX;
  }

  _buildRequestTransport(int appointmentId) {
    return _APPOINTMENT_REQUEST_TRANSPORT_PREFIX +
        appointmentId.toString() +
        _APPOINTMENT_REQUEST_TRANSPORT_SUFFIX;
  }

  _buildFinishAppointment(int appointmentId) {
    return _FINISH_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        _FINISH_APPOINTMENT_SUFFIX;
  }

  _buildCompleteAppointment(int appointmentId) {
    return _COMPLETE_APPOINTMENT_PREFIX +
        appointmentId.toString() +
        _COMPLETE_APPOINTMENT_SUFFIX;
  }

  _buildPaymentAppointment(int providerId) {
    return _PAYMENT_APPOINTMENT_PREFIX +
        providerId.toString() +
        _PAYMENT_APPOINTMENT_SUFFIX;
  }
}
