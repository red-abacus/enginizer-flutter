import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:flutter/cupertino.dart';


class AppointmentProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  Appointment _selectedAppointment;
  AppointmentDetail _selectedAppointmentDetail;

  Appointment get selectedAppointment {
    return _selectedAppointment;
  }

  AppointmentDetail get selectedAppointmentDetail {
    return _selectedAppointmentDetail;
  }

  selectAppointment(Appointment appointment) {
    this._selectedAppointment = appointment;
  }

  Future<AppointmentDetail> getAppointmentDetails(Appointment appointment) async {
    _selectedAppointmentDetail = await this.appointmentsService.getAppointmentDetails(appointment.id);
    notifyListeners();
    return _selectedAppointmentDetail;
  }

  Future<Appointment> cancelAppointment(Appointment appointment) async {
    _selectedAppointment = await this.appointmentsService.cancelAppointment(appointment.id);
    notifyListeners();
    return _selectedAppointment;
  }
}
