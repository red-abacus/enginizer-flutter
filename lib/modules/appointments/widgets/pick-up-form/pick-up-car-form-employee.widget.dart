import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickUpCarFormEmployeeWidget extends StatelessWidget {
  final Employee employee;
  final Function selectEmployeeTimeSerie;
  final Function deselectEmployeeTimeSerie;
  final List<EmployeeTimeSerie> selectedTimeSeries;

  PickUpCarFormEmployeeWidget(
      {this.employee, this.selectEmployeeTimeSerie, this.selectedTimeSeries, this.deselectEmployeeTimeSerie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 100,
      child: Column(
        children: <Widget>[
          _imageContainer(),
          _nameContainer(),
          for (EmployeeTimeSerie entry in employee.timeSeries)
            _employeeTimeslotContainer(entry)
        ],
      ),
    );
  }

  _imageContainer() {
    return Container(
      child: FadeInImage.assetNetwork(
        image: employee?.image ?? '',
        placeholder: 'assets/images/defaults/default_profile_icon.png',
        fit: BoxFit.fitHeight,
        height: 40,
        width: 40,
      ),
    );
  }

  _nameContainer() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 4),
      child: Text(
        employee?.name,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextHelper.customTextStyle(),
      ),
    );
  }

  _employeeTimeslotContainer(EmployeeTimeSerie entry) {
    bool booked = this.selectedTimeSeries.contains(entry);

    Color boxBackground = booked ? red : Colors.transparent;
    Color textColor = booked ? Colors.white : black_text;

    double opacity = (entry.getStatus() == DateEntryStatus.Free) ? 1.0 : 0.4;

    return Container(
      height: 50,
      child: Opacity(
        opacity: opacity,
        child: Container(
          child: new FlatButton(
            color: boxBackground,
            child: new Text(entry.hour,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    color: textColor),
                textAlign: TextAlign.center),
            onPressed: () {
              if (booked) {
                this.deselectEmployeeTimeSerie(entry);
              }
              else {
                this.selectEmployeeTimeSerie(entry);
              }
            },
          ),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: red, width: 1),
            borderRadius: new BorderRadius.all(
              const Radius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
