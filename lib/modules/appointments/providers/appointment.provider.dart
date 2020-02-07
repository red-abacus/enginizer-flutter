import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  Appointment _selectedAppointment;
  AppointmentDetail _appointmentDetail;

  Appointment get selectedAppointment {
    return _selectedAppointment;
  }

  selectAppointment(Appointment appointment) {
    this._selectedAppointment = appointment;
    notifyListeners();
  }

  Future<AppointmentDetail> getAppointmentDetails(Appointment appointment) async {
    _appointmentDetail = await this.appointmentsService.getAppointmentDetails(appointment.id);
    return _appointmentDetail;
  }
}