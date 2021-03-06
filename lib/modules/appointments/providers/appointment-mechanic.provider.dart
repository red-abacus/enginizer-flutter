import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/documentation/car-documentation-document.model.dart';
import 'package:app/modules/appointments/model/documentation/car-documentation-topic.model.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task-issue.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/appointments/enum/mechanic-task-status.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task.model.dart';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentMechanicProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  CarService _carService = inject<CarService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetails;

  List<MechanicTask> standardTasks = [];
  List<MechanicTask> issueTasks = [];

  List<CarHistory> carHistory = [];
  List<CarDocumentationTopic> topics = [];

  MechanicTask currentTask;

  initialise() {
    selectedAppointment = null;
    standardTasks = [];
    issueTasks = [];
    carHistory = [];
    currentTask = null;
    selectedAppointmentDetails = null;
    topics = [];
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetails =
          await _appointmentsService.getAppointmentDetails(appointment.id);

      notifyListeners();
      return selectedAppointmentDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future getStandardTasks(int appointmentId) async {
    try {
      standardTasks =
          await _appointmentsService.getAppointmentStandardTasks(appointmentId);
      notifyListeners();
      return standardTasks;
    } catch (error) {
      throw (error);
    }
  }

  Future getClientTasks(int appointmentId) async {
    try {
      issueTasks =
          await _appointmentsService.getAppointmentClientTasks(appointmentId);

      List<MechanicTask> list = [];

      for (MechanicTask mechanicTask in issueTasks) {
        bool remove = true;
        for (Issue issue in selectedAppointmentDetails.issues) {
          if (issue.id == mechanicTask.id) {
            remove = false;
            break;
          }
        }

        if (!remove) {
          list.add(mechanicTask);
        }
      }

      this.issueTasks = list;
      notifyListeners();
      return issueTasks;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> startAppointment(int appointmentId) async {
    try {
      selectedAppointmentDetails =
          await _appointmentsService.startAppointment(appointmentId);
      notifyListeners();
      return selectedAppointmentDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> pauseAppointment(int appointmentId) async {
    try {
      selectedAppointmentDetails =
          await _appointmentsService.pauseAppointment(appointmentId);
      notifyListeners();
      return selectedAppointmentDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> stopAppointment(int appointmentId) async {
    try {
      selectedAppointmentDetails =
          await _appointmentsService.stopAppointment(appointmentId);
      notifyListeners();
      return selectedAppointmentDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<MechanicTask> startAppointmentTask(
      int appointmentId, MechanicTask mechanicTask) async {
    try {
      MechanicTask task = await _appointmentsService.startAppointmentTask(
          appointmentId, mechanicTask);
      notifyListeners();
      return task;
    } catch (error) {
      throw (error);
    }
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    try {
//      workEstimateDetails = await this
//          ._workEstimatesService
//          .getWorkEstimateDetails(workEstimateId);
//      notifyListeners();
//      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<int> addAppointmentRecommendation(
      int appointmentId, MechanicTaskIssue mechanicTaskIssue) async {
    try {
      int response = await _appointmentsService.addAppointmentRecommendation(
          appointmentId, mechanicTaskIssue);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> addAppointmentRecommendationImage(int appointmentId,
      MechanicTaskIssue mechanicTaskIssue, int recommendationId) async {
    try {
      bool response =
          await _appointmentsService.addAppointmentRecommendationImage(
              appointmentId, mechanicTaskIssue, recommendationId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  MechanicTask firstTaskShouldStart() {
    if (standardTasks.length > 0) {
      if (standardTasks[0].status == MechanicTaskStatus.NEW) {
        return standardTasks[0];
      }
    }

    if (issueTasks.length > 0) {
      if (issueTasks[0].status == MechanicTaskStatus.NEW) {
        return issueTasks[0];
      }
    }

    return null;
  }

  MechanicTask nextIssue() {
    for (MechanicTask task in standardTasks) {
      if (task.status == MechanicTaskStatus.NEW) {
        return task;
      }
    }

    for (MechanicTask task in issueTasks) {
      if (task.status == MechanicTaskStatus.NEW) {
        return task;
      }
    }

    return null;
  }

  Future<List<CarHistory>> getCarHistory(int carId) async {
    try {
      carHistory = await _carService.getCarHistory(carId);
      carHistory.sort((a, b) {
        if (a.appointmentScheduledDateTime != null &&
            b.appointmentScheduledDateTime != null) {
          return a.appointmentScheduledDateTime
              .compareTo(b.appointmentScheduledDateTime);
        } else {
          return 0;
        }
      });
      notifyListeners();
      return carHistory;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarDocumentationTopic>> getCarDocumentationTopics(
      int carId, String language) async {
    try {
      topics = await _carService.getCarDocumentationTopics(language, carId);
      notifyListeners();
      return topics;
    } catch (error) {
      throw (error);
    }
  }

  Future<CarDocumentationDocument> getCarDocumentationDocument(
      int carId, String language, CarDocumentationTopic topic) async {
    try {
      CarDocumentationDocument document =
          await _carService.getCarDocument(language, carId, topic.id);
      topic.document = document;
      notifyListeners();
      return document;
    } catch (error) {
      throw (error);
    }
  }
}
