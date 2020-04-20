import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/appointment.details.tabbar.state.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/details/appointment-generic-details.widget.dart';
import 'package:app/modules/appointments/widgets/details/appointment_details-car.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetails extends StatefulWidget {
  static const String route = '/appointments/appointmentDetails';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsState(route: route);
  }
}

class AppointmentDetailsState extends State<AppointmentDetails> {
  String route;

  var _initDone = false;
  var _isLoading = false;

  AppointmentDetailsState({this.route});

  AppointmentDetailsTabBarState currentState =
      AppointmentDetailsTabBarState.REQUEST;

  AppointmentProvider _appointmentProvider;

  @override
  Widget build(BuildContext context) {
    if (_appointmentProvider != null &&
        _appointmentProvider.selectedAppointment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return Container();
    }

    return Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, _) => Scaffold(
              appBar: AppBar(
                title: Text(
                  _appointmentProvider.selectedAppointment.name,
                  style: TextHelper.customTextStyle(
                      null, Colors.white, FontWeight.bold, 20),
                ),
                iconTheme:
                    new IconThemeData(color: Theme.of(context).cardColor),
              ),
              body: _content(),
            ));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _appointmentProvider = Provider.of<AppointmentProvider>(context);

      if (_appointmentProvider.selectedAppointment != null) {
        setState(() {
          _isLoading = true;
        });

        _loadData();
      }
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _appointmentProvider
          .getAppointmentDetails(_appointmentProvider.selectedAppointment)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
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
  }

  Widget _content() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              Container(
                child: Container(
                  child: _buildTabBar(),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: _getContent(),
                ),
              )
            ],
          );
  }

  Widget _getContent() {
    switch (currentState) {
      case AppointmentDetailsTabBarState.REQUEST:
        switch (_appointmentProvider.selectedAppointment.getState()) {
          case AppointmentStatusState.SUBMITTED:
          case AppointmentStatusState.PENDING:
          case AppointmentStatusState.SCHEDULED:
          case AppointmentStatusState.IN_WORK:
          case AppointmentStatusState.CANCELED:
          case AppointmentStatusState.DONE:
            return AppointmentGenericDetailsWidget(
                appointment: _appointmentProvider.selectedAppointment,
                appointmentDetail:
                    _appointmentProvider.selectedAppointmentDetail,
                viewEstimate: _seeEstimate,
                cancelAppointment: _cancelAppointment,
                acceptAppointment: _acceptAppointment);
            break;
          default:
            return Container();
            break;
        }
        break;
      case AppointmentDetailsTabBarState.CAR:
        return AppointmentDetailsCarWidget();
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
          _buildTabBarButton(AppointmentDetailsTabBarState.REQUEST),
          _buildTabBarButton(AppointmentDetailsTabBarState.CAR)
        ],
      ),
    );
  }

  Widget _buildTabBarButton(AppointmentDetailsTabBarState state) {
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

  _stateTitle(AppointmentDetailsTabBarState state, BuildContext context) {
    switch (state) {
      case AppointmentDetailsTabBarState.REQUEST:
        return S.of(context).appointment_details_request;
      case AppointmentDetailsTabBarState.CAR:
        return S.of(context).appointment_details_car;
    }

    return '';
  }

  _cancelAppointment(Appointment appointment) async {
    try {
      await _appointmentProvider
          .cancelAppointment(appointment)
          .then((appointment) {
        setState(() {
          Provider.of<AppointmentsProvider>(context)
              .refreshAppointment(appointment);
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CANCEL_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_cancel_appointment, context);
      }
    }
  }

  _seeEstimate() {
    int workEstimateId =
        _appointmentProvider.selectedAppointmentDetail.workEstimateId;

    if (workEstimateId != null && workEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context).refreshValues();
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          workEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _appointmentProvider.selectedAppointment.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: EstimatorMode.ReadOnly)),
      );
    }
  }

  _acceptAppointment() async {
    if (_appointmentProvider.selectedAppointmentDetail != null) {
      if (_appointmentProvider.selectedAppointmentDetail.workEstimateId !=
              null &&
          _appointmentProvider.selectedAppointmentDetail.workEstimateId != 0) {
        try {
          await _appointmentProvider
              .acceptWorkEstimate(
                  _appointmentProvider.selectedAppointmentDetail.workEstimateId,
                  _appointmentProvider.selectedAppointmentDetail.scheduledDate)
              .then((_) {
            setState(() {
              Provider.of<AppointmentsProvider>(context).initDone = false;
              _initDone = false;
            });
          });
        } catch (error) {
          if (error
              .toString()
              .contains(WorkEstimatesService.ACCEPT_WORK_ESTIMATE_EXCEPTION)) {
            FlushBarHelper.showFlushBar(S.of(context).general_error,
                S.of(context).exception_accept_work_estimate, context);
          }
        }
      }
    }
  }
}
