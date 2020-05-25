import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';

class AssignEmployeeRequest {
  int employeeId;

  EmployeeTimeSerie timeSerie;

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'selectedDates': ['${timeSerie.date} ${timeSerie.hour}']
      };
}
