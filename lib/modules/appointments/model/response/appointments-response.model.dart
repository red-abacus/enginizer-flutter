import 'package:app/modules/appointments/model/appointment.model.dart';

class AppointmentsResponse {
  int total;
  int totalPages;
  List<Appointment> items;

  AppointmentsResponse({this.total, this.totalPages, this.items});

  factory AppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentsResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapAppointments(json['items']));
  }

  static _mapAppointments(List<dynamic> response) {
    List<Appointment> appointmentsList = [];
    response.forEach((item) {
      appointmentsList.add(Appointment.fromJson(item));
    });
    return appointmentsList;
  }
}
