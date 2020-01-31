import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/utils/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class SchedulerWidget extends StatefulWidget {
  final List<DateEntry> dateEntries;

  SchedulerWidget({this.dateEntries = const []});

  @override
  SchedulerWidgetState createState() {
    return SchedulerWidgetState();
  }
}

class SchedulerWidgetState extends State<SchedulerWidget> {
  Widget _buildDay(
      BuildContext context, DateTime day, List<DateTime> timeEntries) {
    List<Widget> hours = new List();

    hours.add(_buildDayHeader(day));
    DateTime now = DateTime.now();
    bool isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    Color background = (isToday ? Constants.dark_green : Constants.light_green);

    for (int i = 0; i < timeEntries.length; i++) {
      String timeText = timeEntries[i].toIso8601String();
      Text start = new Text(timeText,
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Constants.black_text),
          textAlign: TextAlign.center);

      hours.add(new Container(
        child: new FlatButton(
          color: Colors.transparent,
          onPressed: () => onClicked(timeText, day),
          child: new Column(
            children: [start],
          ),
        ),
        margin: EdgeInsets.all(5),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black54, width: 1)),
      ));
    }
    return Container(
        color: background,
        child: Column(
          children: hours,
        ));
  }

  Widget _buildSchedule(BuildContext context) {
    //array of widgets containing all days
    List<Widget> days = new List();
    for (int i = 0; i < widget.dateEntries.length; i++) {
//      DateTime today = widget.dateEntries[i].date;
//      String format = Constants.Constants.date.
//      startOfDay = DateTime.parse(widget.dateEntries[i].timeSeries[0]);
//      startOfDay = startOfDay.add(new Duration(days: 1));
//      DateTime from = startOfDay.add(new Duration(hours: 9));
//      DateTime to = startOfDay.add(new Duration(hours: 17));

//      days.add(_buildDay(context, from, to));
      //days.add(_buildDay(context, startOfDay.add(new Duration(days: i))));
    }
    return new SingleChildScrollView(
      child: new Row(
        children: days,
      ),
    );
  }

  Widget _buildDayHeader(DateTime time) {
    DateFormat df = new DateFormat("E");
    String weekdayName = df.format(time);

    return Container(
      alignment: Alignment(-1, -1),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(
            weekdayName,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          new Text(
            time.day.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16, color: Colors.black),
          )
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
          scrollDirection: Axis.horizontal,
          // TODO: Fix ListView entering infinite loop, temporary setting itemCount to 0 till then
          itemCount: 0,
        ));
    /*
    PageView.builder(
        itemBuilder: (context, index) {
          return _buildWeek(context, DateTime.now());
        },
        onPageChanged: (direction) {
          //index += direction;
          //call for next values
        },
        scrollDirection: Axis.horizontal,
      ),
     */
  }

  onClicked(String timeText, DateTime day) {
    print("onTapped title=" + timeText + "index=" + day.toString());
    //window.console.debug();
  }

  int calculateFromTime() {
    DateFormat hour = new DateFormat("hh:mm");
    if (widget.dateEntries == null || widget.dateEntries.isEmpty) return 0;
    for (DateEntry dateEntry in widget.dateEntries) {
      DateFormat day = new DateFormat("dd/MM/yyyy");
      DateTime today = day.parse(dateEntry.date);
//      DateTime from = today.add(new Duration(
//          milliseconds:
//              hour.parse(dateEntry.timeSeries[0].time).millisecondsSinceEpoch));
//      DateTime to = today.add(new Duration(
//          milliseconds: hour
//              .parse(dateEntry.timeSeries[dateEntry.timeSeries.length - 1].time)
//              .millisecondsSinceEpoch));
    }
  }

  int calculateEndTime() {
    return 19;
  }
}
