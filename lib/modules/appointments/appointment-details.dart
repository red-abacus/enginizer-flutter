import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/appointments/enum/appointment.details.tabbar.state.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointment.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/details/appointment-details.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AppointmentDetails extends StatefulWidget {
  static const String route = '/appointments/appointmentDetails';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsState(route: route);
  }
}

class AppointmentDetailsState extends State<AppointmentDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;

  AppointmentDetailsState({this.route});

  AppointmentDetailsTabBarState currentState =
      AppointmentDetailsTabBarState.REQUEST;

  AppointmentProvider appointmentProvider;

  @override
  Widget build(BuildContext context) {
    appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Container(
                child: _buildTabBar(),
              ),
            ),
            _getContent(),
          ],
        ));
  }

  Widget _getContent() {
    switch (currentState) {
      case AppointmentDetailsTabBarState.REQUEST:
        return AppointmentDetailsWidget(appointment: appointmentProvider.selectedAppointment);
      case AppointmentDetailsTabBarState.CAR:
        // TODO: Handle this case.
        break;
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

  String stateTitle(AppointmentDetailsTabBarState state, BuildContext context) {
    switch (state) {
      case AppointmentDetailsTabBarState.REQUEST:
        return S.of(context).appointment_details_request;
      case AppointmentDetailsTabBarState.CAR:
        return S.of(context).appointment_details_car;
    }
  }
}
