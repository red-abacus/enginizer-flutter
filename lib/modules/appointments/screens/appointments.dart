import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointment.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars.provider.dart';
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
  var _initDone = false;
  var _isLoading = false;

  List<Appointment> _appointments = [];

  AppointmentsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderAppointments(_isLoading, _appointments),
        ),
        floatingActionButton: FloatingActionButton(
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
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<AppointmentsProvider>(context, listen: false)
          .loadAppointments()
          .then((_) {
        setState(() {
          _appointments =
              Provider.of<AppointmentsProvider>(context, listen: false)
                  .appointments;
          _isLoading = false;
        });
      });
    }
    _initDone = true;

    super.didChangeDependencies();
  }

  _selectAppointment(BuildContext ctx, Appointment selectedAppointment) {
    Provider.of<AppointmentProvider>(context, listen: false)
        .selectAppointment(selectedAppointment);
    Navigator.of(context).pushNamed(AppointmentDetails.route);
  }

  _filterAppointments(String value) {
    setState(() {
      List<Appointment> appointments =
          Provider.of<AppointmentsProvider>(context, listen: false)
              .appointments;

      if (value.isEmpty) {
        _appointments = appointments;
      } else {
        _appointments =
            appointments.where((item) => item.filtered(value)).toList();
      }
    });
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments);
  }

  void _openAppointmentCreateModal(BuildContext buildContext) {
    Provider.of<ProviderServiceProvider>(context).initFormValues();

    Provider.of<CarsProvider>(context, listen: false).loadCars();
    Provider.of<ProviderServiceProvider>(context, listen: false).loadServices();

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
