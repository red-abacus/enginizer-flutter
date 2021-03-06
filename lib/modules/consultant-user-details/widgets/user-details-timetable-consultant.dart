import 'package:app/modules/authentication/models/provider-schedule-slot.model.dart';
import 'package:app/modules/authentication/models/provider-schedule.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailsTimetableConsultant extends StatelessWidget {
  List<ProviderSchedule> schedules;

  UserDetailsTimetableConsultant({this.schedules});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (ProviderSchedule schedule in schedules)
              _timetableRow(schedule)
          ],
        ),
      ),
    );
  }

  _timetableRow(ProviderSchedule schedule) {
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 4),
            child: Text(
              schedule.dayOfWeek,
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold),
            ),
          ),
          for (ProviderScheduleSlot slot in schedule.slots) _hourContainer(slot),
        ],
      ),
    );
  }

  _hourContainer(ProviderScheduleSlot slot) {
    return Container(
      height: 40,
        child: Container(
          child: new FlatButton(
            color: Colors.white,
            child: new Text('${slot.startTime} - ${slot.endTime}',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    color: black_text),
                textAlign: TextAlign.center), onPressed: () {},
          ),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: red, width: 1),
            borderRadius: new BorderRadius.all(
              const Radius.circular(4.0),
            ),
          ),
        ),
    );
  }
}
