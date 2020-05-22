import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:flutter/widgets.dart';

class AppointmentsProvider with ChangeNotifier {
  AppointmentsResponse appointmentsResponse;

  List<Appointment> appointments = [];

  Map<String, dynamic> serviceFormState = {'id': null, 'name': null};

  AppointmentsService appointmentsService = inject<AppointmentsService>();

  String filterSearchString = '';
  AppointmentStatusState filterStatus;
  DateTime filterDateTime;

  bool initDone = false;

  void resetFilterParameters() {
    filterSearchString = '';
    filterStatus = null;
    filterDateTime = null;
  }

  void refreshAppointment(Appointment appointment) {
    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].id == appointment.id) {
        appointments[i] = appointment;
        break;
      }
    }
  }

  Future<List<Appointment>> loadAppointments({AppointmentStatusState state}) async {
    try {
      this.appointmentsResponse =
          await this.appointmentsService.getAppointments(state: state);
      appointments = this.appointmentsResponse.items;
      notifyListeners();
      return appointments;
    } catch (error) {
      throw (error);
    }
  }

  Future<Appointment> createAppointment(
      AppointmentRequest appointmentRequest) async {
    try {
      var newAppointment =
          await this.appointmentsService.createAppointment(appointmentRequest);
      appointments.add(newAppointment);
      notifyListeners();
      return newAppointment;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<Appointment>> filterAppointments(String searchString,
      AppointmentStatusState filterStatus, DateTime dateTime) async {
    this.filterSearchString = searchString;
    this.filterStatus = filterStatus;
    this.filterDateTime = dateTime;

    appointments = this
        .appointmentsResponse
        .items
        .where((appointment) => appointment.filtered(
            this.filterSearchString, this.filterStatus, this.filterDateTime))
        .toList();
    notifyListeners();
    return appointments;
  }
}
