import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-status.enum.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task-issue.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentMechanicProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetails;

  List<MechanicTask> standardTasks = [];
  List<MechanicTask> issueTasks = [];

  List<dynamic> serviceHistory = [];

  MechanicTask currentTask;

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

  Future<MechanicTask> startAppointmentIssue(
      int appointmentId, MechanicTask mechanicTask) async {
    try {
      MechanicTask task = await _appointmentsService.startAppointmentIssue(
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

  Future<bool> addAppointmentRecommendation(
      int appointmentId, MechanicTaskIssue mechanicTaskIssue) async {
    try {
      bool response = await _appointmentsService.addAppointmentRecommendation(
          appointmentId, mechanicTaskIssue);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> addAppointmentRecommendationImage(
      int appointmentId, MechanicTaskIssue mechanicTaskIssue) async {
    try {
      bool response = await _appointmentsService
          .addAppointmentRecommendationImage(appointmentId, mechanicTaskIssue);
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
}
