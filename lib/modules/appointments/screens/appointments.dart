import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/create-appointment-state.enum.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/screens/appointment-details-map.dart';
import 'package:app/modules/appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-provider-details.modal.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-modal.widget.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/shared/managers/permissions/permissions-appointment.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/locator/locator.manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
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

    LocatorManager.getInstance().getActiveAppointment(context);

    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
          body: Center(
            child: _renderAppointments(_isLoading, _provider.appointments),
          ),
          floatingActionButton: _floatingActionButton()),
    );
  }

  _floatingActionButton() {
    return (PermissionsManager.getInstance().hasAccess(
            MainPermissions.Appointments,
            PermissionsAppointment.CREATE_APPOINTMENT))
        ? FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            onPressed: () => _openAppointmentCreateModal(context),
            child: Icon(Icons.add),
          )
        : Container();
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
      await _provider.loadAppointments(_provider.appointmentsRequest).then((_) {
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

  _selectAppointment(BuildContext ctx, Appointment selectedAppointment) async {
    if (PermissionsManager.getInstance().hasAccess(MainPermissions.Appointments,
        PermissionsAppointment.MANAGE_APPOINTMENTS)) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getAppointmentDetails(selectedAppointment.id)
            .then((value) {
          if (value.serviceItems.length > 0) {
            ServiceProviderItem item = value.serviceItems.first;

            if (item.isPickUpAndReturnService() || item.isTowService()) {
              Provider.of<AppointmentProvider>(context).initialise();
              Provider.of<AppointmentProvider>(context).selectedAppointment =
                  selectedAppointment;
              Navigator.of(context).pushNamed(AppointmentDetailsMap.route);
            } else {
              Provider.of<AppointmentConsultantProvider>(context).initialise();
              Provider.of<AppointmentConsultantProvider>(context)
                  .selectedAppointment = selectedAppointment;
              Navigator.of(context)
                  .pushNamed(AppointmentDetailsConsultant.route);
            }

            new Future.delayed(const Duration(seconds: 1), () {
              setState(() => {
                    setState(() {
                      _isLoading = false;
                    })
                  });
            });
          }
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_appointment_details, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    } else if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Appointments,
        PermissionsAppointment.EXECUTE_APPOINTMENTS)) {
      Provider.of<AppointmentMechanicProvider>(context).initialise();
      Provider.of<AppointmentMechanicProvider>(context).selectedAppointment =
          selectedAppointment;
      Navigator.of(context).pushNamed(AppointmentDetailsMechanic.route);
    } else {
      Provider.of<AppointmentProvider>(context).initialise();
      Provider.of<AppointmentProvider>(context).selectedAppointment =
          selectedAppointment;
      Navigator.of(context).pushNamed(AppointmentDetails.route);
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
    Provider.of<ProviderServiceProvider>(context).createAppointmentState =
        CreateAppointmentState.SelectCar;

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
