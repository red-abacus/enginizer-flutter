import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:flutter/cupertino.dart';

class AppointmentMechanicProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetails;

  List<MechanicTask> standardTasks = [];
  List<MechanicTask> issueTasks = [];

  MechanicTask selectedMechanicTask;

  List<dynamic> serviceHistory = [];

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetails =
          await _appointmentsService.getAppointmentDetails(appointment.id);

      if (selectedAppointmentDetails != null) {
        this.issueTasks = selectedAppointmentDetails.tasksFromIssues();
      }
      notifyListeners();
      return selectedAppointmentDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<MechanicTask>> getStandardTasks(int appointmentId) async {
    standardTasks = _mockStandardTasks();
    notifyListeners();
    return standardTasks;
  }

  Future getTestStandardTasks(int appointmentId) async {
    _appointmentsService.getAppointmentStandardTasks(appointmentId);
  }

  List<MechanicTask> _mockStandardTasks() {
    return [
      new MechanicTask(id: 1, name: "CHECK_LIGHTS"),
      new MechanicTask(id: 2, name: "CHECK_BATTERY"),
      new MechanicTask(id: 3, name: "CHECK_LIQUIDS"),
      new MechanicTask(id: 4, name: "CHECK_BRAKES"),
      new MechanicTask(id: 5, name: "CHECK_STEERING"),
      new MechanicTask(id: 6, name: "CHECK_BRAKING_MECHANISM")
    ];
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
}
