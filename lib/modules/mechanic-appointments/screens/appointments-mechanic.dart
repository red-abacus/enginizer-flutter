import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/mechanic-appointments/enums/appointment-type.enum.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/providers/appointments-mechanic.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
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
  var _viewDidAppeared = false;
  var _isLoading = false;

  AppointmentsMechanicProvider _appointmentsMechanicProvider;

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
    _appointmentsMechanicProvider =
        Provider.of<AppointmentsMechanicProvider>(context);

    if (!_viewDidAppeared || !_appointmentsMechanicProvider.initDone) {
      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    _viewDidAppeared = true;
    _appointmentsMechanicProvider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await Provider.of<AppointmentsMechanicProvider>(context)
          .loadAppointments()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENTS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointments, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
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
            filterDateTime: appointmentsMechanicProvider.filterDateTime,
            appointmentType: AppointmentType.MECHANIC);
  }
}
