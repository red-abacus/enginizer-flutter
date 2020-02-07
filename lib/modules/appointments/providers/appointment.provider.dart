import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  Appointment _selectedAppointment;

  Appointment get selectedAppointment {
    return _selectedAppointment;
  }

  selectAppointment(Appointment appointment) {
    this._selectedAppointment = appointment;
    notifyListeners();
  }
}