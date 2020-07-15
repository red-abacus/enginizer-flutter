import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/utils/date_utils.dart';

class CarTimetable {
  DateTime date;
  String status;

  CarTimetable({this.date, this.status});

  factory CarTimetable.fromJson(Map<String, dynamic> json) {
    return CarTimetable(
        date: json['day'] != null
            ? DateUtils.dateFromString(json['day'], 'dd/MM/yyyy')
            : null,
        status: json['status'] != null ? json['status'] : '');
  }

  DateEntryStatus getStatus() {
    if (status.toLowerCase() == 'free') {
      return DateEntryStatus.Free;
    }

    return DateEntryStatus.Booked;
  }
}
