enum TimeEntryStatus { Free, Booked }

class TimeEntry {
  String time;
  TimeEntryStatus status;

  TimeEntry({this.time, this.status});
}

class DateEntry {
  String date;
  List<TimeEntry> timeSeries;

  DateEntry({this.date, this.timeSeries});
}

class TimeTableResponse {
  List<DateEntry> dateEntries;
}
