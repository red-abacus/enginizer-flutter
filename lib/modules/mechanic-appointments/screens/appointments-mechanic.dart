import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/providers/appointments-mechanic.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment-details-mechanic.dart';

class AppointmentsMechanic extends StatefulWidget {
  static const String route = '/appointments-mechanic';
  static final IconData icon = Icons.event_available;

  @override
  State<StatefulWidget> createState() {
    return AppointmentsMechanicState(route: route);
  }
}

class AppointmentsMechanicState extends State<AppointmentsMechanic> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  AppointmentsMechanicState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentsMechanicProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: Container(
            child: _renderAppointments(
                _isLoading, appointmentsProvider.appointments),
          ),
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

      Provider.of<AppointmentsMechanicProvider>(context, listen: false)
          .loadAppointments()
          .then((_) {
            setState(() {
              _isLoading = false;
            });

            _selectAppointment(context, null);
      });

      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _selectAppointment(BuildContext ctx, Appointment selectedAppointment) {
    Provider.of<AppointmentMechanicProvider>(context, listen: false)
        .selectedAppointment = selectedAppointment;
    Navigator.of(context).pushNamed(AppointmentDetailsMechanic.route);
  }

  _filterAppointments(
      String string, AppointmentStatusState state, DateTime dateTime) {
    Provider.of<AppointmentsMechanicProvider>(context, listen: false)
        .filterAppointments(string, state, dateTime);
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    AppointmentsMechanicProvider appointmentsMechanicProvider =
        Provider.of<AppointmentsMechanicProvider>(context, listen: false);

    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments,
            searchString: appointmentsMechanicProvider.filterSearchString,
            appointmentStatusState: appointmentsMechanicProvider.filterStatus,
            filterDateTime: appointmentsMechanicProvider.filterDateTime);
  }
}
