import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';

class AppointmentsResponse {
  int total;
  int totalPages;
  List<Appointment> items;

  AppointmentsResponse({this.total, this.totalPages, this.items});

  factory AppointmentsResponse.fromJson(List<dynamic> data) {
    return AppointmentsResponse(
        items: _mapAppointments(data));
  }

  static _mapAppointments(List<dynamic> response) {
    List<Appointment> appointmentsList = [];
    response.forEach((item) {
      appointmentsList.add(Appointment.fromJson(item));
    });
    return appointmentsList;
  }
}
