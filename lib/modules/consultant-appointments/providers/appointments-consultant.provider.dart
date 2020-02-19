import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/appointments-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
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

  Future<List<Appointment>> loadAppointments() async {
    _appointmentsResponse = await this.appointmentsService.getAppointments();
    appointments = _appointmentsResponse.items;
    notifyListeners();
    return appointments;
  }
}
