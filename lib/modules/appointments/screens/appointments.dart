import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
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
        body: Center(
          child: _renderAppointments(_isLoading, _appointmentsProvider.appointments),
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

      _appointmentsProvider.resetFilterParameters();
      _appointmentsProvider.loadAppointments().then((_) {
        _isLoading = false;
      });
    }

    _initDone = true;
    _appointmentsProvider.initDone = true;

    super.didChangeDependencies();
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

    Provider.of<CarsProvider>(context).loadCars();
    Provider.of<ProviderServiceProvider>(context).loadServices();

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

  _createAppointment(AppointmentRequest appointmentRequest) {
    Provider.of<AppointmentsProvider>(context)
        .createAppointment(appointmentRequest)
        .then((_) {
      Navigator.pop(context);
    });
  }
}
