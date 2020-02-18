import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/appointments-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:flutter/widgets.dart';

class AppointmentsProvider with ChangeNotifier {
  AppointmentsResponse appointmentsResponse;

  List<Appointment> appointments = [];
  List<ServiceItem> _serviceItems = [];

  Map<String, dynamic> serviceFormState = {'id': null, 'name': null};

  AppointmentsService appointmentsService = inject<AppointmentsService>();

  String filterSearchString = "";
  AppointmentStatusState filterStatus;
  DateTime filterDateTime;

  void refreshAppointment(Appointment appointment) {
    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].id == appointment.id) {
        appointments[i] = appointment;
//        notifyListeners();
        break;
      }
    }
  }

  Future<List<Appointment>> loadAppointments() async {
    this.appointmentsResponse =
        await this.appointmentsService.getAppointments();
    appointments = this.appointmentsResponse.items;
    notifyListeners();
    return appointments;
  }

  Future<Appointment> createAppointment(
      AppointmentRequest appointmentRequest) async {
    var newAppointment =
        await this.appointmentsService.createAppointment(appointmentRequest);
    appointments.add(newAppointment);
    notifyListeners();
    return newAppointment;
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
