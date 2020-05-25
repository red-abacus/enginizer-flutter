import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/mechanic-task-screen-state.enum.dart';
import 'package:app/modules/shared/widgets/grouped-chart.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsMechanicEfficiencyWidget extends StatefulWidget {
  @override
  _AppointmentDetailsMechanicEfficiencyWidgetState createState() {
    return _AppointmentDetailsMechanicEfficiencyWidgetState();
  }
}

class _AppointmentDetailsMechanicEfficiencyWidgetState
    extends State<AppointmentDetailsMechanicEfficiencyWidget> {
  MechanicTaskScreenState _currentState = MechanicTaskScreenState.TASK;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildTabBar(),
          _getContent(),
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: <Widget>[
                Container(
                  color: Color.fromRGBO(197, 161, 161, 1.0),
                  width: 20,
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).mechanic_appointment_chart_your_time,
                    style: TextHelper.customTextStyle(null, gray3, null, 14),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: <Widget>[
                Container(
                  color: Color.fromRGBO(224, 225, 226, 1.0),
                  width: 20,
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).mechanic_appointment_chart_standard_time,
                    style: TextHelper.customTextStyle(null, gray3, null, 14),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getContent() {
    // TODO - need to populate with actual data from appointment
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      height: 400,
      child: GroupedStackedWeightPatternBarChart(
        GroupedStackedWeightPatternBarChart.createSampleData(),
      ),
    );
  }

  _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(MechanicTaskScreenState.TASK),
          _buildTabBarButton(MechanicTaskScreenState.CLIENT),
        ],
      ),
    );
  }

  Widget _buildTabBarButton(MechanicTaskScreenState state) {
    Color bottomColor = (_currentState == state) ? red : gray_80;

    return Expanded(
      flex: 1,
      child: Container(
        child: Center(
          child: FlatButton(
            child: Text(
              state == MechanicTaskScreenState.CLIENT
                  ? S.of(context).mechanic_appointment_client_requests
                  : S.of(context).mechanic_appointment_standard_verifications,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Lato",
                  color: red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            onPressed: () {
              if (_currentState != state) {
                setState(() {
                  _currentState = state;
                });
              }
            },
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ),
        ),
      ),
    );
  }
}
