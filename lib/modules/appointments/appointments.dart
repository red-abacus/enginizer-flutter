import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
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

  AppointmentsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderAppointments(
              _isLoading, appointmentsProvider.appointments),
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
          _isLoading = false;
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  void _selectAppointment() {}

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
            appointments: appointments, selectAppointment: _selectAppointment);
  }
}
