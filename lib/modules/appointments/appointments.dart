import 'package:enginizer_flutter/modules/appointments/providers/appointment.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/appointments/appointment-details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'model/appointment.model.dart';
import 'widgets/appointments-list.dart';

class Appointments extends StatefulWidget {
  static const String route = '/appointments';
  static final IconData icon = Icons.card_travel;

  @override
  State<StatefulWidget> createState() {
    return AppointmentsState(route: route);
  }
}

class AppointmentsState extends State<Appointments> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  List<Appointment> _appointments = [];

  AppointmentsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, _) =>
          Scaffold(
            body: Center(
              child: _renderAppointments(_isLoading, _appointments),
            ),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<AppointmentsProvider>(context).loadAppointments().then((_) {
        setState(() {
          _appointments = Provider
              .of<AppointmentsProvider>(context, listen: false)
              .appointments;
          _isLoading = false;
        });
      });
    }
    _initDone = true;

    super.didChangeDependencies();
  }

  void _selectAppointment(BuildContext ctx, Appointment selectedAppointment) {
    Provider.of<AppointmentProvider>(context, listen: false)
        .selectAppointment(selectedAppointment);
    Navigator.of(context).pushNamed(AppointmentDetails.route);
  }

  void _filterAppointments(String value) {
    setState(() {
      List<Appointment> appointments =
          Provider
              .of<AppointmentsProvider>(context, listen: false)
              .appointments;

      if (value.isEmpty) {
        _appointments = appointments;
      }
      else {
        _appointments = appointments.where((item) =>
            item.filtered(value)).toList();
      }
    });
  }

  _renderAppointments(bool _isLoading, List <Appointment> appointments) {
    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
        appointments: appointments,
        selectAppointment: _selectAppointment,
        filterAppointments: _filterAppointments);
  }
}
