import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:flutter/cupertino.dart';

class AppointmentsConsultantProvider with ChangeNotifier {
  List<Appointment> appointments = [];
  AppointmentsResponse _appointmentsResponse;

  String filterSearchString = "";
  AppointmentStatusState filterStatus;
  DateTime filterDateTime;

  AppointmentsService appointmentsService = inject<AppointmentsService>();

  Future<List<Appointment>> filterAppointments(String searchString,
      AppointmentStatusState filterStatus, DateTime dateTime) async {
    this.filterSearchString = searchString;
    this.filterStatus = filterStatus;
    this.filterDateTime = dateTime;

    appointments = this
        ._appointmentsResponse
        .items
        .where((appointment) => appointment.filtered(
            this.filterSearchString, this.filterStatus, this.filterDateTime))
        .toList();
    notifyListeners();
    return appointments;
  }

  void resetParameters() {
    filterSearchString = "";
    filterStatus = null;
    filterDateTime = null;
    appointments = [];
    _appointmentsResponse = null;
  }

  Future<List<Appointment>> loadAppointments() async {
    try {
      _appointmentsResponse = await this.appointmentsService.getAppointments();
      appointments = _appointmentsResponse.items;
      notifyListeners();
      return appointments;
    }
    catch (error) {
      throw(error);
    }
  }

  void refreshAppointment(Appointment appointment) {
    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].id == appointment.id) {
        appointments[i] = appointment;
        break;
      }
    }
  }
}
