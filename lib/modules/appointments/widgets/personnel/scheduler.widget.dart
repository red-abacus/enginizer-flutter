import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/utils/constants.dart' as Constants;
import 'package:app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SchedulerWidget extends StatefulWidget {
  final List<CalendarEntry> calendarEntries;
  DateEntry dateEntry;

  Function dateEntrySelected;
  bool disableSelect = false;

  SchedulerWidget({this.calendarEntries = const [], this.dateEntrySelected, this.dateEntry, this.disableSelect});

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

    Color background = (isToday ? Constants.darker_gray : Constants.light_gray);

    return new Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: background,
          border: Border.all(color: background, width: 1),
          borderRadius: new BorderRadius.all(
            const Radius.circular(5.0),
          )),
      child: Column(
        children: <Widget>[
          _buildDayHeader(calendarEntry.dateTime),
          GridView.count(
            childAspectRatio: 10 / 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
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
    DateEntry selectedDateEntry = widget.dateEntry;

    Color boxBackground = Colors.transparent;
    Color textColor = Constants.black_text;

    if (selectedDateEntry != null &&
        selectedDateEntry.dateTime == dateEntry.dateTime) {
      boxBackground = Constants.red;
      textColor = Colors.white;
    }

    double opacity = (dateEntry.status == DateEntryStatus.Free) ? 1.0 : 0.4;

    return Container(
      width: 100,
      height: 20,
      child: Opacity(
        opacity: opacity,
        child: Container(
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
    if (!widget.disableSelect) {
      if (dateEntry.status == DateEntryStatus.Free) {
        widget.dateEntrySelected(dateEntry);
      }
    }
  }
}
