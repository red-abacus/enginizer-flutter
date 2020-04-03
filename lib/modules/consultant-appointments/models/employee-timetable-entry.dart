import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/consultant-appointments/enums/employee-status.dart';
import 'package:app/utils/date_utils.dart';

class EmployeeTimetableEntry {
  String hour;
  EmployeeStatus status;
  DateEntryStatus dateStatus = DateEntryStatus.Free;

  static List<EmployeeTimetableEntry> generateRandomEntries() {
    List<EmployeeTimetableEntry> list = [];

    DateTime dateTime = DateUtils.startOfDay(DateTime.now());
    dateTime = DateUtils.addHourToDate(dateTime, 8);

    for(int i=0; i<11; i++) {
      EmployeeTimetableEntry entry = new EmployeeTimetableEntry();
      entry.hour = DateUtils.stringFromDate(dateTime, "HH:mm");
      entry.status = i % 2 == 0 ? EmployeeStatus.FREE : EmployeeStatus.BOOKED;
      list.add(entry);

      dateTime = DateUtils.addHourToDate(dateTime, 1);
    }

    return list;
  }
}