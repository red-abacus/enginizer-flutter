import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/utils/constants.dart' as Constants;
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SchedulerWidget extends StatefulWidget {
  final List<CalendarEntry> calendarEntries;

  SchedulerWidget({this.calendarEntries = const []});

  @override
  SchedulerWidgetState createState() {
    return SchedulerWidgetState();
  }
}

class SchedulerWidgetState extends State<SchedulerWidget> {
  Widget _buildDay(BuildContext context, CalendarEntry calendarEntry) {
    List<Widget> hours = new List();

    hours.add(_buildDayHeader(calendarEntry.dateTime));

    DateTime now = DateTime.now();
    bool isToday = calendarEntry.dateTime.year == now.year &&
        calendarEntry.dateTime.month == now.month &&
        calendarEntry.dateTime.day == now.day;

    Color background = (isToday ? Constants.dark_green : Constants.light_green);

    return new Container(
      margin: EdgeInsets.only(top: 10),
      color: background,
      child: Column(
        children: <Widget>[
          _buildDayHeader(calendarEntry.dateTime),
          GridView.count(
            childAspectRatio: 10 / 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            children: List.generate(
              calendarEntry.entries.length,
              (int index) {
                return _buildGridCard(calendarEntry.entries[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(DateEntry dateEntry) {
    DateEntry selectedDateEntry =
        Provider.of<ProviderServiceProvider>(context).dateEntry;

    Color boxBackground = Colors.transparent;
    Color textColor = Constants.black_text;

    if (selectedDateEntry != null &&
        selectedDateEntry.dateTime == dateEntry.dateTime) {
      boxBackground = Constants.red;
      textColor = Colors.white;
    }

    return new Container(
      width: 100,
      height: 20,
      child: new FlatButton(
        color: boxBackground,
        onPressed: () => onClicked(dateEntry),
        child: new Text(DateUtils.stringFromDate(dateEntry.dateTime, "HH:mm"),
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 10, color: textColor),
            textAlign: TextAlign.center),
      ),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.red, width: 1),
        borderRadius: new BorderRadius.all(
          const Radius.circular(5.0),
        ),
      ),
    );
  }

  Widget _buildSchedule(BuildContext context) {
    List<Widget> days = new List();

    for (int i = 0; i < widget.calendarEntries.length; i++) {
      days.add(_buildDay(context, widget.calendarEntries[i]));
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: days,
    );
  }

  Widget _buildDayHeader(DateTime time) {
    String weekdayString = DateUtils.stringFromDate(time, "EEEE");

    return Container(
      alignment: Alignment(-1, -1),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(
            weekdayString,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12, color: Constants.dark_gray),
          ),
          new Container(
            margin: EdgeInsets.only(left: 10),
            child: new Text(
              time.day.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _buildSchedule(context);
        },
        scrollDirection: Axis.vertical,
        itemCount: 1,
      ),
    );
  }

  onClicked(DateEntry dateEntry) {
    setState(() {
      Provider.of<ProviderServiceProvider>(context).dateEntry = dateEntry;
    });
  }
}
