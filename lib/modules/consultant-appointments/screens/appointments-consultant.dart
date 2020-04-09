import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/consultant-appointments/widgets/appointments-list-consultant.widget.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsConsultant extends StatefulWidget {
  static const String route = '/appointments-consultant';
  static final IconData icon = Icons.event_available;

  @override
  State<StatefulWidget> createState() {
    return AppointmentsConsultantState(route: route);
  }
}

class AppointmentsConsultantState extends State<AppointmentsConsultant> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;
  var _initDone = false;
  var _isLoading = false;

  AppointmentsConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentsConsultantProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        key: _scaffoldKey,
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
      _loadData();
    }
    _initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      Provider.of<AppointmentsConsultantProvider>(context).resetParameters();
      await Provider.of<AppointmentsConsultantProvider>(context)
          .loadAppointments()
          .then((_) {
        _isLoading = false;
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENTS_EXCEPTION)) {
        SnackBarManager.showSnackBar(
            S.of(context).general_error,
            S.of(context).exception_get_appointments,
            _scaffoldKey.currentState);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectAppointment(BuildContext ctx, Appointment selectedAppointment) {
    Provider.of<AppointmentConsultantProvider>(context).selectedAppointment =
        selectedAppointment;
    Navigator.of(context).pushNamed(AppointmentDetailsConsultant.route);
  }

  _filterAppointments(
      String string, AppointmentStatusState state, DateTime dateTime) {
    Provider.of<AppointmentsConsultantProvider>(context)
        .filterAppointments(string, state, dateTime);
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    AppointmentsConsultantProvider provider =
        Provider.of<AppointmentsConsultantProvider>(context);

    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsListProvider(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments,
            searchString: provider.filterSearchString,
            appointmentStatusState: provider.filterStatus,
            filterDateTime: provider.filterDateTime);
  }
}
