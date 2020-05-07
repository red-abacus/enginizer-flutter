import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/utils/date_utils.dart';

class EmployeeTimeSerie {
  String date;
  String hour;
  String status;
  int employeeId;

  EmployeeTimeSerie({this.employeeId, this.date, this.hour, this.status});

  factory EmployeeTimeSerie.fromJson(
      int employeeId, String date, Map<String, dynamic> json) {
    return EmployeeTimeSerie(
        employeeId: employeeId,
        date: date,
        hour: json['hour'] != null ? json['hour'] : "",
        status: json['slotStatus'] != null ? json["slotStatus"] : "");
  }

  DateEntryStatus getStatus() {
    if (status.toLowerCase() == 'free') {
      return DateEntryStatus.Free;
    }

    return DateEntryStatus.Booked;
  }

  DateTime getDate() {
    DateTime date = DateUtils.dateFromString(this.date, 'dd/MM/yyyy');
    return date != null ? date : DateTime.now();
  }
}
