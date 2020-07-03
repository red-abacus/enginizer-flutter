import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';

class AssignEmployeeRequest {
  int employeeId;

  List<EmployeeTimeSerie> timeSeries;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map['employeeId'] = employeeId;

    List<String> dates = [];

    for (EmployeeTimeSerie timeSerie in timeSeries) {
      dates.add('${timeSerie.date} ${timeSerie.hour}');
    }

    map['selectedDates'] = dates;
    return map;
  }
}
