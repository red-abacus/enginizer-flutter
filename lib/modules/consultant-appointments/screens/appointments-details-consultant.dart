import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/enums/appointment-details-status-state.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/details/appointment-details-new-consultant.widget.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/details/appointment-details-scheduled-consultant.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;

  var _initDone = false;
  var _isLoading = false;

  AppointmentDetailsStatusState currentState =
      AppointmentDetailsStatusState.REQUEST;

  AppointmentDetailsConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
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

      AppointmentConsultantProvider provider =
          Provider.of<AppointmentConsultantProvider>(context);
      provider.getAppointmentDetails(provider.selectedAppointment).then((_) {
        provider
            .getProviderServices(
                provider.selectedAppointment.serviceProvider.id)
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
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
    AppointmentConsultantProvider provider =
        Provider.of<AppointmentConsultantProvider>(context);

    switch (currentState) {
      case AppointmentDetailsStatusState.REQUEST:
        if (provider.selectedAppointment.status.name.toLowerCase() ==
            "submitted") {
          return AppointmentDetailsScheduledConsultantWidget(
              appointment: provider.selectedAppointment,
              appointmentDetail: provider.selectedAppointmentDetail,
              serviceItems: provider.selectedAppointmentDetail.serviceItems,
              serviceProviderItems: provider.serviceProviderItems);
        } else {
          AppointmentDetailsNewConsultantWidget(
              appointment: provider.selectedAppointment,
              appointmentDetail: provider.selectedAppointmentDetail,
              serviceItem: provider.selectedAppointmentDetail.serviceItems,
              serviceProviderItem: provider.serviceProviderItems);
        }
        break;
      case AppointmentDetailsStatusState.CAR:
        // TODO - need to add car details when finished
        return Container();
        break;
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
                stateTitle(state, context),
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

  String stateTitle(AppointmentDetailsStatusState state, BuildContext context) {
    switch (state) {
      case AppointmentDetailsStatusState.REQUEST:
        return S.of(context).appointment_details_request;
      case AppointmentDetailsStatusState.CAR:
        return S.of(context).appointment_details_car;
    }
  }
}
