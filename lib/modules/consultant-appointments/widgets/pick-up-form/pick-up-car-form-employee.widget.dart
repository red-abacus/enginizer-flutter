import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickUpCarFormEmployeeWidget extends StatelessWidget {
  final Employee employee;
  final Function selectEmployeeTimeSerie;
  final EmployeeTimeSerie selectedTimeSerie;

  PickUpCarFormEmployeeWidget({this.employee, this.selectEmployeeTimeSerie, this.selectedTimeSerie});

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
      child: Image.network(
        // TODO - need to add image of mechanic
        'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png',
        fit: BoxFit.fitHeight,
        height: 40,
        width: 40,
      ),
    );
  }

  _nameContainer() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Text(
        employee?.name,
        textAlign: TextAlign.center,
        style: TextHelper.customTextStyle(null, Colors.black, null, 14),
      ),
    );
  }

  _employeeTimeslotContainer(EmployeeTimeSerie entry) {
    Color boxBackground = Colors.transparent;
    Color textColor = black_text;

    if (entry == this.selectedTimeSerie) {
      boxBackground = red;
      textColor = Colors.white;
    }

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
              _onClicked(entry);
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

  _onClicked(EmployeeTimeSerie entry) {
    selectEmployeeTimeSerie(entry);
  }
}
