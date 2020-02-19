import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsCarDetails extends StatefulWidget {
  final Appointment appointment;
  final AppointmentDetail appointmentDetails;

  AppointmentDetailsCarDetails(
      {this.appointment, this.appointmentDetails});

  @override
  AppointmentDetailsCarDetailsState createState() {
    return AppointmentDetailsCarDetailsState();
  }
}

class AppointmentDetailsCarDetailsState
    extends State<AppointmentDetailsCarDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Appointment Details Car Details'));
  }
}
