import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/appointment.model.dart';
import 'appointment-details.dart';

class Appointments extends StatefulWidget {
  static const String route = '/appointments';
  static final IconData icon = Icons.event_available;

  @override
  State<StatefulWidget> createState() {
    return AppointmentsState(route: route);
  }
}

class AppointmentsState extends State<Appointments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;

  var _isLoading = false;
  var _initDone = false;

  AppointmentsProvider _appointmentsProvider;

  AppointmentsState({this.route});

  @override
  Widget build(BuildContext context) {
    _appointmentsProvider = Provider.of<AppointmentsProvider>(context);

    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: _renderAppointments(
              _isLoading, _appointmentsProvider.appointments),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          onPressed: () => _openAppointmentCreateModal(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _appointmentsProvider = Provider.of<AppointmentsProvider>(context);
    _initDone = _initDone == false ? false : _appointmentsProvider.initDone;

    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    _initDone = true;
    _appointmentsProvider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      _appointmentsProvider.resetFilterParameters();
      await _appointmentsProvider.loadAppointments().then((_) {
        setState(() {
          _isLoading = false;
        });
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
    Provider.of<AppointmentProvider>(context)
        .selectAppointment(selectedAppointment);
    Navigator.of(context).pushNamed(AppointmentDetails.route);
  }

  _filterAppointments(
      String string, AppointmentStatusState state, DateTime dateTime) {
    Provider.of<AppointmentsProvider>(context)
        .filterAppointments(string, state, dateTime);
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    AppointmentsProvider provider = Provider.of<AppointmentsProvider>(context);

    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments,
            searchString: provider.filterSearchString,
            appointmentStatusState: provider.filterStatus,
            filterDateTime: provider.filterDateTime);
  }

  void _openAppointmentCreateModal(BuildContext buildContext) {
    Provider.of<ProviderServiceProvider>(context).initFormValues();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCreateModal(
              _createAppointment,
              true,
            );
          });
        });
  }

  _createAppointment(AppointmentRequest appointmentRequest) async {
    try {
      await Provider.of<AppointmentsProvider>(context)
          .createAppointment(appointmentRequest)
          .then((_) {
        Navigator.pop(context);
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CREATE_APPOINTMENT_EXCEPTION)) {
        SnackBarManager.showSnackBar(
            S.of(context).general_error,
            S.of(context).exception_create_appointment,
            _scaffoldKey.currentState);
      }
    }
  }
}
