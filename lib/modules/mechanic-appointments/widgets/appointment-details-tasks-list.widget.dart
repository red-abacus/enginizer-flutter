import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTasksList extends StatefulWidget {
  final Appointment appointment;
  final AppointmentDetail appointmentDetails;

  AppointmentDetailsTasksList(
      {this.appointment, this.appointmentDetails});

  @override
  AppointmentDetailsTasksListState createState() {
    return AppointmentDetailsTasksListState();
  }
}

class AppointmentDetailsTasksListState
    extends State<AppointmentDetailsTasksList> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Appointment Details Tasks List'));
  }
}
