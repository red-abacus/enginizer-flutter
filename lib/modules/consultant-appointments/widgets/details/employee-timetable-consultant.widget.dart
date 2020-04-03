import 'package:app/modules/consultant-appointments/enums/employee-status.dart';
import 'package:app/modules/consultant-appointments/models/employee-timetable-entry.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeTimetableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<EmployeeTimetableEntry> list =
        EmployeeTimetableEntry.generateRandomEntries();

    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 100,
      child: Column(
        children: <Widget>[
          _imageContainer(),
          _nameContainer(),
          for (EmployeeTimetableEntry entry in list)
            _employeeTimeslotContainer(entry)
        ],
      ),
    );
  }

  _imageContainer() {
    return Container(
      child: Image.network(
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
        'Dorel Pop',
        style: TextHelper.customTextStyle(null, Colors.black, null, 14),
      ),
    );
  }

  _employeeTimeslotContainer(EmployeeTimetableEntry entry) {
    Color boxBackground = Colors.transparent;
    Color textColor = black_text;

//    if (selectedDateEntry != null &&
//        selectedDateEntry.dateTime == dateEntry.dateTime) {
//      boxBackground = Constants.red;
//      textColor = Colors.white;
//    }

    double opacity = (entry.status == EmployeeStatus.FREE) ? 1.0 : 0.4;

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

  _onClicked(EmployeeTimetableEntry entry) {
    if (entry.status == EmployeeStatus.FREE) {
      if (entry.status == EmployeeStatus.FREE) {
        entry.status = EmployeeStatus.BOOKED;
      }
      else {
        entry.status = EmployeeStatus.FREE;
      }
    }
  }
}
