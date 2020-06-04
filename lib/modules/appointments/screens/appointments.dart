import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/appointment-map-state.enum.dart';
import 'package:app/modules/appointments/enum/create-appointment-state.enum.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/screens/appointment-details-map.dart';
import 'package:app/modules/appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-modal.widget.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/appointment/appointment.model.dart';
import 'appointment-details-mechanic.dart';
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

  AppointmentsProvider _provider;

  AppointmentsState({this.route});

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AppointmentsProvider>(context);

    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderAppointments(_isLoading, _provider.appointments),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
//            FloatingActionButton.extended(
//              heroTag: null,
//              backgroundColor: Theme.of(context).primaryColor,
//              elevation: 1,
//              onPressed: () => _showAppointmentMapDetails(AppointmentMapState.InProgress),
//              label: Text(
//                'PR Accepted',
//                style:
//                TextHelper.customTextStyle(null, Colors.white, null, 14),
//              ),
//            ),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 1,
              onPressed: () => _openAppointmentCreateModal(context),
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AppointmentsProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _provider.resetParams();
      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    _initDone = true;
    _provider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.loadAppointments().then((_) {
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
    switch (Provider.of<Auth>(context).authUser.role) {
      case Roles.Client:
        Provider.of<AppointmentProvider>(context).initialiseParams();
        Provider.of<AppointmentProvider>(context).selectedAppointment =
            selectedAppointment;
        Navigator.of(context).pushNamed(AppointmentDetails.route);
        break;
      case Roles.ProviderConsultant:
        Provider.of<AppointmentConsultantProvider>(context).initialise();
        Provider.of<AppointmentConsultantProvider>(context)
            .selectedAppointment = selectedAppointment;
        Navigator.of(context).pushNamed(AppointmentDetailsConsultant.route);
        break;
      case Roles.ProviderPersonnel:
        Provider.of<AppointmentMechanicProvider>(context).initialise();
        Provider.of<AppointmentMechanicProvider>(context).selectedAppointment =
            selectedAppointment;
        Navigator.of(context).pushNamed(AppointmentDetailsMechanic.route);
        break;
      default:
        break;
    }
  }

  _filterAppointments(
      String string, AppointmentStatusState state, DateTime dateTime) {
    _provider.filterAppointments(string, state, dateTime);
    _loadData();
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments,
            searchString: _provider.appointmentsRequest.searchString,
            appointmentStatusState: _provider.appointmentsRequest.state,
            filterDateTime: _provider.appointmentsRequest.dateTime,
            downloadNextPage: _loadData,
            shouldDownload: _provider.shouldDownload(),
          );
  }

  void _openAppointmentCreateModal(BuildContext buildContext) {
    Provider.of<ProviderServiceProvider>(context).initFormValues();
    Provider.of<ProviderServiceProvider>(context).createAppointmentState = CreateAppointmentState.SelectCar;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCreateModal();
          });
        });
  }
}
