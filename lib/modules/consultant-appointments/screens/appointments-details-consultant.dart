import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/cars/widgets/car-general-details.widget.dart';
import 'package:app/modules/consultant-appointments/enums/appointment-details-status-state.dart';
import 'package:app/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/widgets/appointment-car-receive-form.widget.dart';
import 'package:app/modules/consultant-appointments/widgets/details/appointment-details-generic-consultant.widget.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsConsultant extends StatefulWidget {
  static const String route =
      '/appointments-consultant/appointment-details-consultant';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsConsultantState(route: route);
  }
}

class AppointmentDetailsConsultantState
    extends State<AppointmentDetailsConsultant> {
  AppointmentConsultantProvider _appointmentConsultantProvider;

  String route;

  var _isLoading = false;

  AppointmentDetailsStatusState currentState =
      AppointmentDetailsStatusState.REQUEST;

  AppointmentDetailsConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    if (_appointmentConsultantProvider != null &&
            _appointmentConsultantProvider.selectedAppointment == null ||
        _appointmentConsultantProvider != null &&
            _appointmentConsultantProvider.selectedAppointmentDetail == null) {
      return Container();
    }

    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              title: Text(
                _appointmentConsultantProvider.selectedAppointment?.name,
                style: TextHelper.customTextStyle(
                    null, Colors.white, FontWeight.bold, 20),
              ),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _contentWidget()));
  }

  @override
  void didChangeDependencies() {
    _appointmentConsultantProvider =
        Provider.of<AppointmentConsultantProvider>(context);

    if (!_appointmentConsultantProvider.initDone) {
      if (_appointmentConsultantProvider.selectedAppointment != null) {
        setState(() {
          _isLoading = true;
        });
        _loadData();
      }

      _appointmentConsultantProvider.initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _appointmentConsultantProvider
          .getAppointmentDetails(
              _appointmentConsultantProvider.selectedAppointment)
          .then((_) async {
        await _appointmentConsultantProvider
            .getProviderServices(_appointmentConsultantProvider
                .selectedAppointment.serviceProvider.id)
            .then((_) async {
          int lastWorkEstimate = _appointmentConsultantProvider
              .selectedAppointmentDetail
              .lastWorkEstimate();

          if (lastWorkEstimate != 0) {
            await _appointmentConsultantProvider
                .getWorkEstimateDetails(lastWorkEstimate)
                .then((_) {
              setState(() {
                _isLoading = false;
              });
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointment_details, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_service_items, context);
      } else if (error
          .toString()
          .contains(WorkEstimatesService.GET_WORK_ESTIMATE_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_estimate_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Container(
            child: _buildTabBar(),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: _buildContent(),
          ),
        )
      ],
    );
  }

  _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _getContent();
  }

  _getContent() {
    switch (currentState) {
      case AppointmentDetailsStatusState.REQUEST:
        return _getAppointmentDetailsScreen();
      case AppointmentDetailsStatusState.CAR:
        return CarGeneralDetailsWidget(
            car: _appointmentConsultantProvider.selectedAppointmentDetail.car);
        break;
    }
  }

  _getAppointmentDetailsScreen() {
    switch (_appointmentConsultantProvider.selectedAppointmentDetail.status
        .getState()) {
      case AppointmentStatusState.SUBMITTED:
      case AppointmentStatusState.PENDING:
      case AppointmentStatusState.SCHEDULED:
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
      case AppointmentStatusState.CANCELED:
      case AppointmentStatusState.DONE:
        return AppointmentDetailsGenericConsultantWidget(
          appointmentDetail:
              _appointmentConsultantProvider.selectedAppointmentDetail,
          serviceItems: _appointmentConsultantProvider
              .selectedAppointmentDetail.serviceItems,
          serviceProviderItems:
              _appointmentConsultantProvider.serviceProviderItems,
          declineAppointment: _declineAppointment,
          createEstimate: _createEstimate,
          editEstimate: _editEstimate,
          viewEstimate: _viewEstimate,
          assignMechanic: _assignMechanic,
          createPickUpCarForm: _createPickUpCarForm,
          workEstimateDetails: _appointmentConsultantProvider.workEstimateDetails,
        );
      default:
        return Container();
    }
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(AppointmentDetailsStatusState.REQUEST),
          _buildTabBarButton(AppointmentDetailsStatusState.CAR)
        ],
      ),
    );
  }

  Widget _buildTabBarButton(AppointmentDetailsStatusState state) {
    Color bottomColor = (currentState == state) ? red : gray_80;
    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: FlatButton(
              child: Text(
                _stateTitle(state, context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              onPressed: () {
                setState(() {
                  currentState = state;
                });
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }

  String _stateTitle(
      AppointmentDetailsStatusState state, BuildContext context) {
    switch (state) {
      case AppointmentDetailsStatusState.REQUEST:
        return S.of(context).appointment_details_request;
      case AppointmentDetailsStatusState.CAR:
        return S.of(context).appointment_details_car;
    }

    return '';
  }

  _declineAppointment() {
    if (_appointmentConsultantProvider.selectedAppointment != null) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return AlertConfirmationDialogWidget(
                  confirmFunction: (confirm) => {
                        if (confirm)
                          {
                            _cancelAppointment(_appointmentConsultantProvider
                                .selectedAppointment)
                          }
                      },
                  title: S
                      .of(context)
                      .appointment_details_cancel_appointment_title);
            });
          });
    }
  }

  _cancelAppointment(Appointment appointment) async {
    try {
      await _appointmentConsultantProvider
          .cancelAppointment(appointment)
          .then((appointment) {
        Provider.of<AppointmentsConsultantProvider>(context).initDone = false;

        setState(() {
          _appointmentConsultantProvider.initDone = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CANCEL_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_cancel_appointment, context);
      }

      setState(() {
        _appointmentConsultantProvider.initDone = false;
      });
    }
  }

  _createEstimate() {
    if (_appointmentConsultantProvider.selectedAppointmentDetail != null) {
      Provider.of<WorkEstimateProvider>(context).refreshValues();
      Provider.of<WorkEstimateProvider>(context).setIssues(
          _appointmentConsultantProvider.selectedAppointmentDetail.issues);
      Provider.of<WorkEstimateProvider>(context).selectedAppointment =
          _appointmentConsultantProvider.selectedAppointment;
      Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
          _appointmentConsultantProvider.selectedAppointmentDetail;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _appointmentConsultantProvider.selectedAppointment.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(mode: EstimatorMode.Create)),
      );
    }
  }

  _editEstimate() {
    // TODO - consultant provider can edit it's estimator before client accepts it?
    int lastWorkEstimateId = _appointmentConsultantProvider
        .selectedAppointmentDetail
        .lastWorkEstimate();

    if (lastWorkEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context).refreshValues();
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          lastWorkEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _appointmentConsultantProvider.selectedAppointment.serviceProvider.id;
      Provider.of<WorkEstimateProvider>(context).selectedAppointment =
          _appointmentConsultantProvider.selectedAppointment;
      Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
          _appointmentConsultantProvider.selectedAppointmentDetail;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(mode: EstimatorMode.Edit)),
      );
    }
  }

  _viewEstimate() {
    int lastWorkEstimateId = _appointmentConsultantProvider
        .selectedAppointmentDetail
        .lastWorkEstimate();

    if (lastWorkEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context).refreshValues();
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          lastWorkEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _appointmentConsultantProvider.selectedAppointment.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(
                mode: EstimatorMode.ReadOnly,
                dateEntry: _appointmentConsultantProvider
                    .selectedAppointmentDetail
                    .getWorkEstimateDateEntry())),
      );
    }
  }

  _assignMechanic() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Container();
          });
        });
  }

  _createPickUpCarForm() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCarReceiveFormModal(
                appointmentDetail:
                    _appointmentConsultantProvider.selectedAppointmentDetail,
                refreshState: _refreshState);
          });
        });
  }

  _refreshState() {
    setState(() {
      _isLoading = true;
    });

    _loadData();
  }
}
