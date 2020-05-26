import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:flutter/widgets.dart';

class AppointmentsProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  AppointmentsResponse appointmentsResponse;
  AppointmentsRequest appointmentsRequest;

  List<Appointment> appointments = [];

  Map<String, dynamic> serviceFormState = {'id': null, 'name': null};

  bool initDone = false;

  bool shouldDownload() {
    if (appointmentsResponse != null) {
      if (appointmentsRequest.currentPage >= appointmentsResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  void resetParams() {
    initDone = false;
    appointmentsResponse = null;

    appointments = [];
    appointmentsRequest = null;
    appointmentsRequest = AppointmentsRequest();
  }

  void refreshAppointment(Appointment appointment) {
    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].id == appointment.id) {
        appointments[i] = appointment;
        break;
      }
    }
  }

  Future<List<Appointment>> loadAppointments() async {
    if (!shouldDownload()) {
      return null;
    }

    try {
      this.appointmentsResponse =
          await this.appointmentsService.getAppointments(appointmentsRequest);
      this.appointments.addAll(this.appointmentsResponse.items);
      appointmentsRequest.currentPage += 1;
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

  filterAppointments(String searchString,
      AppointmentStatusState filterStatus, DateTime dateTime) async {
    appointmentsResponse = null;
    appointments = [];
    appointmentsRequest = AppointmentsRequest();

    appointmentsRequest.searchString = searchString;
    appointmentsRequest.state = filterStatus;
    appointmentsRequest.dateTime = dateTime;
  }
}
