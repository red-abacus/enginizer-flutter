import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:flutter/cupertino.dart';

class AppointmentMechanicProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetails;

  List<MechanicTask> standardTasks = [];

  MechanicTask selectedMechanicTask;

  List<dynamic> serviceHistory = [];

  void initFormValues() {
    standardTasks.forEach((task) => task.issues = List.of(task.issues)
      ..add(AppointmentIssue(id: null, name: '')));
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    selectedAppointmentDetails =
        await this.appointmentsService.getAppointmentDetails(appointment.id);
    notifyListeners();
    return selectedAppointmentDetails;
  }

  Future<List<MechanicTask>> getStandardTasks(int appointmentId) async {
//    standardTasks =
//        await this.appointmentsService.getStandardTasks(appointmentId);
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
}
