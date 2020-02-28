import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/request/work-estimate-request.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/work-estimates.provider.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/estimator/estimator-modal.widget.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/enums/appointment-details-status-state.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/screens/pick-up-car-form-consultant.modal.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/details/appointment-details-generic-consultant.widget.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/widgets/estimator/create-work-estimate-modal.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'assign-employee-consultant-modal.dart';

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

  var _initDone = false;
  var _isLoading = false;

  AppointmentDetailsStatusState currentState =
      AppointmentDetailsStatusState.REQUEST;

  AppointmentDetailsConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    _appointmentConsultantProvider =
        Provider.of<AppointmentConsultantProvider>(context);

    if (_appointmentConsultantProvider.selectedAppointment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
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
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _appointmentConsultantProvider =
          Provider.of<AppointmentConsultantProvider>(context);
      _appointmentConsultantProvider
          .getAppointmentDetails(
              _appointmentConsultantProvider.selectedAppointment)
          .then((_) {
        _appointmentConsultantProvider
            .getProviderServices(_appointmentConsultantProvider
                .selectedAppointment.serviceProvider.id)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
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
        return Container();
        break;
    }
  }

  _getAppointmentDetailsScreen() {
    switch (_appointmentConsultantProvider.selectedAppointment.getState()) {
      case AppointmentStatusState.SUBMITTED:
      case AppointmentStatusState.PENDING:
      case AppointmentStatusState.SCHEDULED:
        return AppointmentDetailsGenericConsultantWidget(
          appointment: _appointmentConsultantProvider.selectedAppointment,
          appointmentDetail:
              _appointmentConsultantProvider.selectedAppointmentDetail,
          serviceItems: _appointmentConsultantProvider
              .selectedAppointmentDetail.serviceItems,
          serviceProviderItems:
              _appointmentConsultantProvider.serviceProviderItems,
          declineAppointment: _declineAppointment,
          createEstimate: _createEstimate,
          editEstimate: _editEstimate,
          assignMechanic: _assignMechanic,
          createPickUpCarForm: _createPickUpCarForm,
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

  _declineAppointment(Appointment appointment) {
    _appointmentConsultantProvider
        .cancelAppointment(appointment)
        .then((appointment) {
      Provider.of<AppointmentsConsultantProvider>(context)
          .refreshAppointment(appointment);

      setState(() {
        _initDone = false;
      });
    });
  }

  _createEstimate() {
    if (_appointmentConsultantProvider.selectedAppointmentDetail != null) {
      Provider.of<CreateWorkEstimateProvider>(context).refreshValues();
      Provider.of<CreateWorkEstimateProvider>(context).setIssues(
          _appointmentConsultantProvider.selectedAppointmentDetail.issues);

      showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return CreateEstimatorModal(createBid: _createWorkEstimate);
            });
          });
    }
  }

  _editEstimate() {
    Provider.of<WorkEstimatesProvider>(context).initValues();
    Provider.of<ProviderServiceProvider>(context).loadItemTypes();
    Provider.of<WorkEstimatesProvider>(context).workEstimateId =
        _appointmentConsultantProvider.selectedAppointmentDetail.workEstimateId;
    Provider.of<WorkEstimatesProvider>(context).serviceProvider =
        _appointmentConsultantProvider.selectedAppointment.serviceProvider;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return EstimatorModal(mode: EstimatorMode.Edit);
          });
        });
  }

  _createWorkEstimate(WorkEstimateRequest workEstimateRequest) {
    _appointmentConsultantProvider
        .createWorkEstimate(
            _appointmentConsultantProvider.selectedAppointment.id,
            _appointmentConsultantProvider.selectedAppointmentDetail.car.id,
            _appointmentConsultantProvider.selectedAppointmentDetail.user.uid,
            workEstimateRequest)
        .then((_) {
      setState(() {
        _initDone = false;
      });
    });
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
            return AssignEmployeeConsultantModal();
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
                return PickUpCarFormConsultantModal();
              });
        });
  }
}
