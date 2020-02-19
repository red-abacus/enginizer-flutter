import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsServiceHistory extends StatefulWidget {
  final Appointment appointment;
  final AppointmentDetail appointmentDetails;

  AppointmentDetailsServiceHistory(
      {this.appointment, this.appointmentDetails});

  @override
  AppointmentDetailsServiceHistoryState createState() {
    return AppointmentDetailsServiceHistoryState();
  }
}

class AppointmentDetailsServiceHistoryState
    extends State<AppointmentDetailsServiceHistory> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Appointment Details Service History'));
  }
}
