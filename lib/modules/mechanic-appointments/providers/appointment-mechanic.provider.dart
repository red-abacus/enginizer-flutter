import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:flutter/cupertino.dart';

class AppointmentMechanicProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetails;

  List<MechanicTask> standardTasks = [];

  MechanicTask selectedMechanicTask;

  WorkEstimateDetails workEstimateDetails;

  List<dynamic> serviceHistory = [];

  void initFormValues() {
    standardTasks.forEach((task) =>
        task.issues = List.of(task.issues)..add(Issue(id: null, name: '')));
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetails =
          await this.appointmentsService.getAppointmentDetails(appointment.id);
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

  List<MechanicTask> _mockStandardTasks() {
    return [
      new MechanicTask(id: 1, name: "CHECK_LIGHTS", completed: false),
      new MechanicTask(id: 2, name: "CHECK_BATTERY", completed: false),
      new MechanicTask(id: 3, name: "CHECK_LIQUIDS", completed: false),
      new MechanicTask(id: 4, name: "CHECK_BRAKES", completed: false),
      new MechanicTask(id: 5, name: "CHECK_STEERING", completed: false),
      new MechanicTask(id: 6, name: "CHECK_BRAKING_MECHANISM", completed: false)
    ];
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    try {
      workEstimateDetails = await this
          ._workEstimatesService
          .getWorkEstimateDetails(workEstimateId);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }
}
